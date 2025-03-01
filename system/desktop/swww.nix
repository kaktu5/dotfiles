{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.hardware.monitors) monitors primaryMonitor;
in {
  home.packages = [pkgs.swww];
  kkts.sessionVariables = {
    SWWW_TRANSITION = "wipe";
    SWWW_TRANSITION_ANGLE = 30;
    SWWW_TRANSITION_FPS = monitors.${primaryMonitor}.refreshRate;
    SWWW_TRANSITION_STEP = 100;
  };
}
