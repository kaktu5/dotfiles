{lib, ...}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrsOf enum float int nullOr str submodule;
  inherit (lib.types.ints) positive;
in {
  options.kkts.hardware.monitors = {
    primaryMonitor = mkOption {
      type = nullOr str;
      default = null;
    };

    monitors = mkOption {
      type = attrsOf (submodule {
        options = {
          resolution = {
            w = mkOption {type = positive;};
            h = mkOption {type = positive;};
          };

          scale = mkOption {
            type = float;
            default = 1.0;
          };

          refreshRate = mkOption {type = positive;};

          position = {
            x = mkOption {
              type = int;
              default = 0;
            };
            y = mkOption {
              type = int;
              default = 0;
            };
          };

          rotation = mkOption {
            type = enum [0 90 180 270];
            default = 0;
          };

          variableRefreshRate = mkEnableOption "variable refresh rate support";
        };
      });
      default = {};
    };
  };
}
