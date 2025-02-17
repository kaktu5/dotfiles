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
    "info:#${purple}"
    "label:#${purple}"
    "pointer:#${purple}"
    "prompt:#${purple}"
    "spinner:#${purple}"
  ]);
  fzf' = symlinkJoin rec {
    name = "fzf";
    paths = [fzf];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${name} \
        --add-flags "--style minimal" \
        --add-flags "--prompt ' '" \
        --add-flags "--color ${colors'}"
    '';
  };
in {user.packages = [fzf'];}
