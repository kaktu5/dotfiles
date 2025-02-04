{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (config.kkts.hardware.monitors) monitors;
  inherit (lib.attrsets) mapAttrsToList;
in {
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings.monitor =
      mapAttrsToList (
        name: monitor: let
          w = toString monitor.resolution.w;
          h = toString monitor.resolution.h;
          r = toString monitor.refreshRate;
          x = toString monitor.position.x;
          y = toString monitor.position.y;
          s = toString monitor.scale;
        in "${name}, ${w}x${h}@${r}, ${x}x${y}, ${s}"
      )
      monitors
      ++ [", preferred, auto, auto"];
  };
}
