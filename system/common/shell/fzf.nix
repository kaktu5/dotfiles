{
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (lib) concatStringsSep;
  inherit (pkgs) fzf makeWrapper symlinkJoin;
  inherit (theme) colors;
  colors' = concatStringsSep "," (with colors; [
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
  ]);
  fzf' = symlinkJoin rec {
    name = "fzf";
    paths = [fzf];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${name} \
        --add-flags "--style minimal" \
        --add-flags "--border none" \
        --add-flags "--prompt ' '" \
        --add-flags "--color ${colors'}"
    '';
  };
in {user.packages = [fzf'];}
