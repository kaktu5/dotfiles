{
  lib,
  pkgs,
  btrfs,
  zfs,
  ...
}: let
  inherit (lib) mkIf;
  interval = "weekly";
in {
  environment.systemPackages = with pkgs; [
    (mkIf btrfs btrfs-progs)
    (mkIf zfs zfs)
  ];
  services = {
    fstrim = {
      enable = true;
      inherit interval;
    };
    btrfs.autoScrub = {
      enable = btrfs;
      inherit interval;
    };
    zfs.autoScrub = {
      enable = zfs;
      inherit interval;
    };
  };
}
