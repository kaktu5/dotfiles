{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.kkts.hardware.wifi;
in {
  options.kkts.hardware.wifi.enable = mkEnableOption "wifi support";

  config = mkIf cfg.enable {
    persistence.directories = ["/etc/NetworkManager/system-connections"];

    networking.networkmanager.enable = true;
  };
}
