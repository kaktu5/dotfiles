{
  config,
  lib,
}: let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.kkts.colors) rgb rgbToHex rgbToHex';
  inherit (lib.options) mkOption;
  inherit (lib.types) ints str submodule;

  cfg = config.kkts.theme.colors;

  mkRgbColorOption = default:
    mkOption {
      type = submodule {
        options = let
          t = mkOption {type = ints.between 0 255;};
        in {
          r = t;
          g = t;
          b = t;
        };
      };
      inherit default;
    };

  mkHexColorOption = default:
    mkOption {
      type = str;
      inherit default;
      readOnly = true;
    };

  mkAnsiOption = default:
    mkOption {
      type = ints.between 0 15;
      inherit default;
      readOnly = true;
    };
in {
  rgb = mapAttrs (_: mkRgbColorOption) {
    bg0 = rgb 0 0 0; # oklab 0 0 0
    bg1 = rgb 2 2 2; # oklab 0.08 0 0
    bg2 = rgb 13 13 13; # oklab 0.16 0 0
    bg3 = rgb 31 31 31; # oklab 0.24 0 0

    fg0 = rgb 217 223 225; # oklab 0.9 -0.005 -0.005
    fg1 = rgb 201 207 209; # oklab 0.85 -0.005 -0.005
    fg2 = rgb 185 191 193; # oklab 0.8 -0.005 -0.005
    fg3 = rgb 169 175 177; # oklab 0.75 -0.005 -0.005

    red = rgb 0 0 0;
    green = rgb 0 0 0;
    yellow = rgb 0 0 0;
    orange = rgb 0 0 0;
    blue = rgb 0 0 0;
    purple = rgb 0 0 0;
    cyan = rgb 0 0 0;

    termBg = cfg.rgb.bg0;
    term0 = cfg.rgb.bg3;
    term1 = cfg.rgb.red;
    term2 = cfg.rgb.green;
    term3 = cfg.rgb.yellow;
    term4 = cfg.rgb.blue;
    term5 = cfg.rgb.purple;
    term6 = cfg.rgb.cyan;
    term7 = cfg.rgb.fg0;
  };

  hex = mapAttrs (_: color: mkHexColorOption <| rgbToHex color) cfg.rgb;
  hex' = mapAttrs (_: color: mkHexColorOption <| rgbToHex' color) cfg.rgb;

  ansi = mapAttrs (_: mkAnsiOption) {
    bg = 0;
    fg = 7;
    red = 1;
    green = 2;
    yellow = 3;
    blue = 4;
    purple = 5;
    cyan = 6;
  };
}
