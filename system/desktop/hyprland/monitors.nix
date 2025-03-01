{
  config,
  lib,
}: let
  inherit (config.kkts.hardware.monitors) monitors;
  inherit (lib) concatStringsSep mapAttrsToList pipe;
  inherit (lib.kkts) match;
in
  pipe monitors [
    (mapAttrsToList (name: monitor: let
      x = toString monitor.position.x;
      y = toString monitor.position.y;
      rr = toString monitor.refreshRate;
      w = toString monitor.resolution.w;
      h = toString monitor.resolution.h;
      ro = match (toString monitor.rotation) [
        {"0" = "0";}
        {"90" = "1";}
        {"180" = "2";}
        {"270" = "3";}
      ];
      s = toString monitor.scale;
    in "monitor = ${name}, ${w}x${h}@${rr}, ${x}x${y}, ${s}, transform, ${ro}"))
    (xs: xs ++ ["monitor = , preferred, auto, auto"])
    (concatStringsSep "\n")
  ]
