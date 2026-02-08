{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.hardware.monitors) monitors;
  inherit (lib.attrsets) mapAttrsToList;
in {
  boot.kernelParams =
    monitors
    |> mapAttrsToList (n: m: "video=${n}:${m.resolution.w}x${m.resolution.h}@${m.refreshRate},rotate=${m.rotation}");
}
