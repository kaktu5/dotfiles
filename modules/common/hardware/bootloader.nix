{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  cfg = config.kkts.hardware.bootloader;
in {
  options.kkts.hardware.bootloader.enable = mkEnableOption "bootloader";
  config.boot.loader = mkIf cfg.enable {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 14;
      memtest86.enable = true;
    };
    timeout = 1;
  };
}
