{
  config,
  lib,
}: let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.lists) elemAt;
  inherit (lib.options) mkOption;
  inherit (lib.strings) stringToCharacters;
  inherit (lib.trivial) mod;
  inherit (lib.types) ints str submodule;

  cfg = config.kkts.theme.colors;

  toHex = n: let
    digits = stringToCharacters "0123456789abcdef";
    high = elemAt digits (n / 16);
    low = elemAt digits (mod n 16);
  in
    high + low;

  rgb = r: g: b: {inherit r g b;};

  rgbToHex = {
    r,
    g,
    b,
  }:
    toHex r + toHex g + toHex b;

  rgbToHex' = rgb: "#" + rgbToHex rgb;

  mkRgbColorOption = default: (mkOption {
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
  });

  mkHexColorOption = default: (mkOption {
    type = str;
    inherit default;
    readOnly = true;
  });

  mkAnsiOption = default: (mkOption {
    type = ints.between 0 15;
    inherit default;
    readOnly = true;
  });
in {
  rgb = mapAttrs (_: mkRgbColorOption) {
    bg0 = rgb 5 8 8; # oklab 0.130 0.006 210
    bg1 = rgb 7 10 10; # oklab 0.140 0.006 210
    bg2 = rgb 11 15 16; # oklab 0.165 0.006 210
    bg3 = rgb 16 19 20; # oklab 0.185 0.006 210

    fg0 = rgb 217 223 225; # oklab 0.9 -0.005 -0.005
    fg1 = rgb 201 207 209; # oklab 0.85 -0.005 -0.005
    fg2 = rgb 185 191 193; # oklab 0.8 -0.005 -0.005
    fg3 = rgb 169 175 177; # oklab 0.75 -0.005 -0.005

    # colors based on https://github.com/vague-theme/vague.nvim
    red = rgb 224 131 152;
    green = rgb 153 183 130;
    yellow = rgb 245 203 150;
    blue = rgb 139 169 193;
    purple = rgb 174 174 209;
    cyan = rgb 155 180 188;

    # ANSI indices
    "0" = cfg.rgb.bg3;
    "1" = cfg.rgb.red;
    "2" = cfg.rgb.green;
    "3" = cfg.rgb.yellow;
    "4" = cfg.rgb.blue;
    "5" = cfg.rgb.purple;
    "6" = cfg.rgb.cyan;
    "7" = cfg.rgb.fg0;
    "8" = cfg.rgb.bg3;
    "9" = cfg.rgb.red;
    "10" = cfg.rgb.green;
    "11" = cfg.rgb.yellow;
    "12" = cfg.rgb.blue;
    "13" = cfg.rgb.purple;
    "14" = cfg.rgb.cyan;
    "15" = cfg.rgb.fg0;
  };

  hex = cfg.rgb |> mapAttrs (_: color: mkHexColorOption <| rgbToHex color);
  hex' = cfg.rgb |> mapAttrs (_: color: mkHexColorOption <| rgbToHex' color);

  # ANSI named aliases
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
