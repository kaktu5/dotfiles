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
      # nix
      inherit
        (pkgs)
        alejandra
        dix
        nh
        nixd
        npins
        ;

      # qml
      inherit (pkgs.kdePackages) qtdeclarative;
    };
  }
