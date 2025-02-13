{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  interval = "weekly";
  cfg = config.kkts.hardware.fileSystems;
in {
  options.kkts.hardware.fileSystems = {
    trim.enable = mkEnableOption "fstrim service";
    scrub = {
      btrfs.enable = mkEnableOption "btrfs autoscrub service";
      zfs.enable = mkEnableOption "zfs autoscrub service";
    };
  };
  config = {
    environment.systemPackages = with pkgs; [
      (mkIf cfg.scrub.btrfs.enable btrfs-progs)
      (mkIf cfg.scrub.zfs.enable zfs)
    ];
    services = {
      fstrim = mkIf cfg.trim.enable {
        enable = true;
        inherit interval;
      };
      btrfs.autoScrub = mkIf cfg.scrub.btrfs.enable {
        enable = true;
        inherit interval;
      };
      zfs.autoScrub = mkIf cfg.scrub.zfs.enable {
        enable = true;
        inherit interval;
      };
    };
  };
}
