{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.hardware.monitors) monitors;
  inherit (lib) mkOption;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.modules) mkIf;
  inherit (lib.types) attrsOf float int str submodule;
  inherit (lib.types.ints) positive;
in {
  options.kkts.hardware.monitors = {
    main = mkOption {type = str;};
    monitors = mkOption {
      type = attrsOf (submodule {
        options = {
          resolution = mkOption {
            type = submodule {
              options = {
                w = mkOption {type = positive;};
                h = mkOption {type = positive;};
              };
            };
          };
          refreshRate = mkOption {type = positive;};
          position = mkOption {
            type = submodule {
              options = {
                x = mkOption {type = int;};
                y = mkOption {type = int;};
              };
            };
          };
          scale = mkOption {type = float;};
        };
      });
      default = {};
    };
  };
  config = mkIf (monitors != {}) {
    boot.kernelParams =
      mapAttrsToList (
        name: monitor: let
          w = toString monitor.resolution.w;
          h = toString monitor.resolution.h;
          r = toString monitor.refreshRate;
        in "video=${name}:${w}x${h}@${r}"
      )
      monitors;
  };
}
