/*
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) mkForce;
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.stdenv) mkDerivation;
  dmMono = mkDerivation {
    name = "dm-mono";
    src = fetchFromGitHub {
      owner = "googlefonts";
      repo = "dm-mono";
      rev = "57fadabfb200a77de2812540026c249dc3013077";
      sha256 = "sha256-Xj6UmvH7tqW6xdobBxuafqc7TB1nrTFwHWv4DaZmwx8=";
    };
    installPhase = ''
      install -Dm644 $src/exports/*.ttf -t $out/share/fonts
    '';
  };
  cfg = config.fonts.fontconfig.defaultFonts;
in {
  environment.systemPackages = config.fonts.packages;

  fonts = {
    packages = with pkgs; [
      dmMono
      fira-code
      nerd-fonts.symbols-only
      sarasa-gothic
      twitter-color-emoji
    ];
    fontconfig = {
      enable = true;
      hinting.enable = false;
      defaultFonts = {
        serif = mkForce ["DM Mono"];
        sansSerif = mkForce cfg.serif;
        monospace = mkForce ["Fira Code"];
        emoji = mkForce ["Twitter Color Emoji"];
      };
    };
  };
  homeManager.gtk.font.name = mkForce (toString cfg.sansSerif);
  environment.sessionVariables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };
}
*/
{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (pkgs.stdenv) mkDerivation;
  inherit (pkgs) fetchFromGitHub;
  dmMono = mkDerivation {
    name = "dm-mono";
    src = fetchFromGitHub {
      owner = "googlefonts";
      repo = "dm-mono";
      rev = "57fadabfb200a77de2812540026c249dc3013077";
      sha256 = "sha256-Xj6UmvH7tqW6xdobBxuafqc7TB1nrTFwHWv4DaZmwx8=";
    };
    installPhase = ''
      install -Dm644 $src/exports/*.ttf -t $out/share/fonts
    '';
  };
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [sarasa-gothic nerd-fonts.symbols-only];
    stylix.fonts = {
      serif = config.stylix.fonts.sansSerif;
      sansSerif = {
        package = dmMono;
        name = "DM Mono";
      };
      monospace = {
        # package = pkgs.fira-code;
        # name = "Fira Code";
        package = pkgs.lilex;
        name = "Lilex";
      };
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
  };
  fonts.fontconfig.hinting.enable = false;
  environment.sessionVariables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };
}
