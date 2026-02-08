{
  config,
  inputs,
  lib,
  pkgs,
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.nixexprs.legacyPackages.${system}) space-mono;
  inherit (lib) types;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) ceil;
  inherit (lib.types) str;
  inherit (lib.types.ints) positive;
  inherit (pkgs) _0xproto noto-fonts-monochrome-emoji;

  cfg = config.kkts.theme.fonts;

  mkFontOption = {
    name,
    package,
  }: {
    name = mkOption {
      type = str;
      default = name;
    };

    package = mkOption {
      type = types.package;
      default = package;
    };
  };

  mkFontSizeOption = default: (mkOption {
    type = positive;
    inherit default;
  });

  ptToPx = pt: ceil (pt * 4.0 / 3.0);
in {
  fonts = {
    emoji = mkFontOption {
      name = "Noto Emoji";
      package = noto-fonts-monochrome-emoji;
    };

    monospace = mkFontOption {
      name = "0xProto";
      package = _0xproto;
    };

    sansSerif = mkFontOption {
      name = "SpaceMono";
      package = space-mono;
    };

    serif = mkFontOption cfg.fonts.sansSerif;
  };

  sizes = {
    pt = {
      large = mkFontSizeOption 12;
      medium = mkFontSizeOption 10;
      small = mkFontSizeOption 8;
    };

    px = cfg.sizes.pt |> mapAttrs (_: pt: (mkFontSizeOption <| ptToPx pt) // {readOnly = true;});
  };
}
