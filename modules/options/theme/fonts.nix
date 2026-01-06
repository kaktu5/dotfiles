{
  config,
  lib,
  pkgs,
}: let
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
  inherit (lib.types.ints) positive;
  inherit (pkgs) _0xproto noto-fonts-monochrome-emoji;
  inherit (pkgs.nerd-fonts) space-mono; # TODO: package Space Mono without nerd font patches

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

  mkFontSizeOption = default:
    mkOption {
      type = positive;
      inherit default;
    };
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
      name = "SpaceMono Nerd Font Mono";
      package = space-mono;
    };

    serif = mkFontOption cfg.fonts.sansSerif;
  };

  sizes = {
    large = mkFontSizeOption 12;
    medium = mkFontSizeOption 10;
    small = mkFontSizeOption 8;
  };
}
