{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.hardware.monitors) monitors;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.kkts) match;
in {
  homeManager.wayland.windowManager.hyprland.settings.monitor =
    mapAttrsToList (
      name: monitor: let
        x = toString monitor.position.x;
        y = toString monitor.position.y;
        rr = toString monitor.refreshRate;
        w = toString monitor.resolution.w;
        h = toString monitor.resolution.h;
        ro =
          match [
            {"0" = "0";}
            {"90" = "1";}
            {"180" = "2";}
            {"270" = "3";}
          ]
          (toString monitor.rotation);
        s = toString monitor.scale;
      in "${name}, ${w}x${h}@${rr}, ${x}x${y}, ${s}, transform, ${ro}"
    )
    monitors
    ++ [", preferred, auto, auto"];
}
