{
  lib,
  cryptsetup,
  dosfstools,
  kmod,
  systemd,
  util-linux,
  writers,
  zfs,
}: let
  inherit (lib.strings) makeBinPath readFile;
  inherit (writers) writeNuBin;
in
  writeNuBin "tmpfs-zfs" ''
    $env.PATH = "${makeBinPath [cryptsetup dosfstools kmod systemd util-linux zfs]}"

    ${readFile ./tmpfs-zfs.nu}
  ''
