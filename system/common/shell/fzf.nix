{
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (lib.kkts) mkWrapper;
  inherit (lib) concatStringsSep;
  inherit (theme.colors) bg0 bg3 fg0 lightPurple purple;
  colors' = concatStringsSep "," [
    "bg:#${bg0}"
    "bg+:#${bg0}"
    "border:#${bg3}"
    "fg:#${fg0}"
    "fg+:#${purple}"
    "header:#${fg0}"
    "hl:#${purple}"
    "hl+:#${lightPurple}"
    "info:#${fg0}"
    "label:#${purple}"
    "marker:#${purple}"
    "pointer:#${purple}"
    "prompt:#${purple}"
    "query:#${fg0}"
    "spinner:#${purple}"
  ];
  fzf' = mkWrapper "fzf" [pkgs.fzf] [
    ''--add-flags "--style minimal"''
    ''--add-flags "--border none"''
    ''--add-flags "--prompt ' '"''
    ''--add-flags "--color ${colors'}"''
  ];
in {home.packages = [fzf'];}
