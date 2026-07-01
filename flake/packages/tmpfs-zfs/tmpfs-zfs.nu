$env.config.filesize = {
  unit: "binary"
  precision: 0
}

def get_part_path [device: path, index: int]: nothing -> path {
  $"/dev/(^lsblk --json --list --output NAME,PKNAME
    | from json
    | get blockdevices
    | where pkname == ($device | path expand | path basename)
    | get name
    | get $index)"
}

def get_part_uuid [part_path: path]: nothing -> string {
  ^blkid --output value --match-tag UUID $part_path
}

def "main format" [
  device: path # Target block device
  --passphrase-file (-p): path # Path to a file with passphrase
  --block-size (-b): filesize = 4KiB # Block size
]: nothing -> record {
  if not ($device | path exists) {
    error make {msg: $"Device does not exist: ($device)"}
  }

  let bs = ($block_size | into int)
  let asize = ($bs | math log 2 | math round | into int)
  if not ($bs > 0 and ($bs bit-and ($bs - 1)) == 0 and $asize >= 9 and $asize <= 24) {
    error make {msg: $"Invalid block size: ($block_size). Must be a power of 2 between 512B and 16MiB."}
  }

  let id = ($device | hash sha256 | str substring 0..7)

  $"
    label: gpt
    type=U, start=1MiB, size=1024MiB
    type=L, size=+
  " | ^sfdisk --wipe always $device
  ^udevadm settle

  let boot_part = get_part_path $device 0
  let nixos_part = get_part_path $device 1
  let nixos_id = $"nixos-($id)"

  ^mkfs.vfat -F 32 $boot_part

  ^cryptsetup luksFormat ...[
    $nixos_part, $nixos_id,
    "--cipher", "aes-xts-plain64",
    "--key-size", 512,
    "--hash", "sha512",
    "--pbkdf", "argon2id",
    "--pbkdf-memory", (2 * 1024 * 1024),
    "--pbkdf-force-iterations", 6,
    "--key-file", $passphrase_file,
    "--batch-mode",
  ]
  ^cryptsetup open --key-file $passphrase_file $nixos_part $nixos_id

  ^zpool create ...[
    $nixos_id, $"/dev/mapper/($nixos_id)",
    "-f",
    "-o", $"ashift=($asize)",
    "-O", "mountpoint=none",
    "-O", "acltype=posixacl",
    "-O", "xattr=sa",
    "-O", "compression=zstd-fast",
  ]

  ^zfs create $"($nixos_id)/nix" -o mountpoint=legacy -o atime=off
  ^zfs create $"($nixos_id)/nix/store" -o compression=zstd-6
  ^zfs create $"($nixos_id)/persist" -o mountpoint=legacy -o com.sun:auto-snapshot=true

  {
    boot: {
      zfs: {
        pools: {
          $nixos_id: {
            devNodes: "/dev/mapper"
          },
        },
      },
      initrd: {
        luks: {
          devices: {
            nixos: {
              device: $"/dev/disk/by-uuid/(get_part_uuid $nixos_part)",
              allowDiscards: true,
            },
          },
        },
      },
    },
    fileSystems: {
      "/boot": {
        device: $"/dev/disk/by-uuid/(get_part_uuid $boot_part)",
        fsType: "vfat",
      },
      "/nix": {
        device: $"($nixos_id)/nix",
        fsType: "zfs",
      },
      "/nix/store": {
        device: $"($nixos_id)/nix/store",
        fsType: "zfs",
      },
      "/persist": {
        device: $"($nixos_id)/persist",
        fsType: "zfs",
      },
    },
  }
}

def "main mount" [input: path, target: path = "/mnt"]: nothing -> nothing {
  let input = open $input

  let fs_list = ($input.fileSystems | transpose mountpoint config | sort-by mountpoint)
  for fs in $fs_list {
    ^mount --mkdir --types $fs.config.fsType $fs.config.device $"($target)($fs.mountpoint)"
  }
}

def main []: nothing -> nothing {}
