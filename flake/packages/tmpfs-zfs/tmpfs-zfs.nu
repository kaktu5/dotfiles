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

def "main format" [
  device: path # Target block device
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

  $"
    label: gpt
    name=boot, type=U, start=1MiB, size=1024MiB
    name=nixos, type=L, size=+
  " | ^sfdisk $device
  ^udevadm settle

  let boot_part = get_part_path $device 0
  let nixos_part = get_part_path $device 1

  ^mkfs.vfat -F 32 $boot_part

  ^modprobe zfs
  ^zpool create ...[
    "nixos", $nixos_part,
    "-f",
    "-o", $"ashift=($asize)",
    "-O", "mountpoint=none",
    "-O", "acltype=posixacl",
    "-O", "xattr=sa",
    "-O", "compression=zstd-fast",
  ]

  ^zfs create nixos/nix -o mountpoint=legacy -o atime=off

  ^zfs create nixos/nix/store -o compression=zstd-6

  ^zfs create nixos/persist -o mountpoint=legacy -o com.sun:auto-snapshot=true

  let boot_by_uuid = $"/dev/disk/by-uuid/(^blkid --output value --match-tag UUID $boot_part)"
  {
    "/boot": {
      device: $boot_by_uuid,
      fsType: "vfat",
    },
    "/nix": {
      device: "nixos/nix",
      fsType: "zfs",
    },
    "/nix/store": {
      device: "nixos/nix/store",
      fsType: "zfs",
    },
    "/persist": {
      device: "nixos/persist",
      fsType: "zfs",
    },
  }
}

def "main mount" [target: path = "/mnt"]: record -> nothing {
  ^mount --mkdir --types tmpfs none $target

  let fs_list = ($in | transpose mountpoint config | sort-by mountpoint)
  for fs in $fs_list {
    ^mount --mkdir --types $fs.config.fsType $fs.config.device $"($target)($fs.mountpoint)"
  }
}

def main []: nothing -> nothing {}
