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
        package = pkgs.fira-code;
        name = "Fira Code";
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
