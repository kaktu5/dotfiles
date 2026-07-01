{pkgs}: let
  inherit (pkgs) callPackage;
in {
  tmpfs-zfs = callPackage ./tmpfs-zfs {};
}
