{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  interval = "weekly";
  cfg = config.kkts.hardware.filesystems;
in {
  options.kkts.hardware.filesystems = {
    enable = mkEnableOption "fstrim service";
    btrfs.enable = mkEnableOption "btrfs autoscrub service";
    zfs.enable = mkEnableOption "zfs autoscrub service";
  };
  config = {
    environment.systemPackages = with pkgs; [
      (mkIf cfg.btrfs.enable btrfs-progs)
      (mkIf cfg.zfs.enable zfs)
    ];
    services = {
      fstrim = mkIf cfg.enable {
        enable = true;
        inherit interval;
      };
      btrfs.autoScrub = mkIf cfg.btrfs.enable {
        enable = true;
        inherit interval;
      };
      zfs.autoScrub = mkIf cfg.zfs.enable {
        enable = true;
        inherit interval;
      };
    };
  };
}