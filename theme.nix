{
  inputs,
  pkgs,
}: let
  inherit (pkgs.stdenv) mkDerivation;
  dm-mono = mkDerivation {
    name = "dm-mono";
    src = inputs.dm-mono;
    installPhase = ''
      install -Dm644 $src/exports/*.ttf -t $out/share/fonts
    '';
  };
in {
  colors = rec {
    bg0 = "000000"; # ----
    bg1 = "0d0e14"; # ---
    bg2 = "1b1c28"; # --
    bg3 = "292b3d"; # -
    fg0 = "c0caf5"; # ++++
    fg1 = "afb8e0"; # +++
    fg2 = "9fa7cc"; # ++
    fg3 = "8f96b7"; # +

    red = "ee6d85";
    orange = "f6955b";
    yellow = "d7a65f";
    green = "95c561";
    blue = "7199ee";
    lightBlue = "9fbbf3";
    purple = "a485dd";
    lightPurple = "bc99ff";

    termBg = bg0;
    term0 = bg3;
    term1 = red;
    term2 = green;
    term3 = yellow;
    term4 = blue;
    term5 = purple;
    term6 = lightBlue;
    term7 = fg0;
  };

  fonts = rec {
    serif = sansSerif;
    sansSerif = {
      name = "DM Mono";
      package = dm-mono;
    };
    monospace = {
      name = "Lilex";
      package = pkgs.lilex;
    };
    emoji = {
      name = "Twitter Color Emoji";
      package = pkgs.twitter-color-emoji;
    };
    packages = [
      pkgs.nerd-fonts.symbols-only
      pkgs.sarasa-gothic
      sansSerif.package
      monospace.package
      emoji.package
    ];
  };

  windowManager = {
    borderSize = 3;
    gapsSize = 4;
  };
}
