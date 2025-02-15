{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  cfg = config.kkts.hardware.bluetooth;
in {
  options.kkts.hardware.bluetooth.enable = mkEnableOption "bluetooth support";
  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      input.General.ClassicBondedOnly = true;
    };
    services.blueman.enable = true;
  };
}
