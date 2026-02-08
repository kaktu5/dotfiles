{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.hardware.monitors) monitors;
  inherit (lib.attrsets) mapAttrs;
in {
  kkts.programs.hyprland.monitors =
    monitors
    |> mapAttrs (_: m: {
      mode = "${m.resolution.w}x${m.resolution.h}@${m.refreshRate}";
      position = "${m.position.x}x${m.position.y}";
      inherit (m) scale;
      transform =
        {
          "0" = 0;
          "90" = 1;
          "180" = 2;
          "270" = 3;
        }."${m.rotation}";
    });
}
