{
  lib,
  pkgs,
  self,
  system,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) replaceStrings;
  inherit (pkgs) mkShellNoCC writeShellScriptBin;

  vaultix' = self.vaultix.app.${system};

  vaultix-edit = vaultix'.edit.overrideAttrs (old: {
    name = "vaultix-edit";
    buildCommand = replaceStrings ["edit-secret"] ["vaultix-edit"] old.buildCommand;
  });
  vaultix-renc = writeShellScriptBin "vaultix-renc" ''
    cd "$(git rev-parse --show-toplevel)"
    nix run -Lv .#vaultix.app.${system}.renc
  '';
in
  mkShellNoCC {
    name = "dotfiles-devshell";
    packages = attrValues {
      # nix
      inherit (pkgs) alejandra dix nh nixd;

      # qml
      inherit (pkgs.kdePackages) qtdeclarative;

      # vaultix
      inherit (pkgs) age;
      inherit vaultix-edit vaultix-renc;
    };
  }
