{
  config,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.kkts.options) mkSubmodule;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) float int str;
  inherit (lib.types.ints) positive;
  cfg = config.kkts.hardware.monitors;
in {
  options.kkts.hardware.monitors = {
    primaryMonitor = mkOption {type = str;};
    monitors = mkSubmodule {
      position = {
        x = mkOption {type = int;};
        y = mkOption {type = int;};
      };
      refreshRate = mkOption {type = positive;};
      resolution = {
        w = mkOption {type = positive;};
        h = mkOption {type = positive;};
      };
      rotation = mkOption {type = int;};
      scale = mkOption {type = float;};
    };
  };
  config = mkIf (cfg.monitors != {}) {
    boot.kernelParams =
      mapAttrsToList (
        name: monitor: let
          w = toString monitor.resolution.w;
          h = toString monitor.resolution.h;
          rr = toString monitor.refreshRate;
          ro = toString monitor.rotation;
        in "video=${name}:${w}x${h}@${rr},rotate=${ro}"
      )
      cfg.monitors;
  };
}
