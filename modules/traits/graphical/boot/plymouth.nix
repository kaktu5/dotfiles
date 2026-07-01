{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.hardware.monitors) monitors primaryMonitor;
  inherit (config.kkts.theme.fonts.fonts) monospace;
  inherit (lib.generators) toINI;
  inherit (lib.trivial) floor;
in {
  boot = {
    kernelParams = ["quiet" "splash"];

    plymouth = {
      enable = true;

      font = "${monospace.package}/share/fonts/truetype/${monospace.name}-Regular.ttf";

      extraConfig = toINI {} {
        Daemon.DeviceScale = floor monitors.${primaryMonitor}.scale;
      };
    };
  };
}
