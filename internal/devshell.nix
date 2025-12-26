{
  lib,
  pkgs,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (pkgs) mkShellNoCC;
in
  mkShellNoCC {
    name = "dotfiles-devshell";
    packages = attrValues {
      inherit
        (pkgs)
        alejandra
        deadnix
        nixd
        npins
        statix
        ;
    };
  }
