{
  inputs,
  lib,
  pkgs,
  self,
  system,
}: let
  inherit (inputs.tack.packages.${system}) tack;
  inherit (lib.attrsets) attrValues;
  inherit (pkgs) mkShellNoCC writeShellScriptBin;

  vaultix' = self.vaultix.app.${system};

  vaultix-edit = vaultix'.edit.overrideAttrs (_: {
    name = "vaultix-edit";
    destination = "/bin/vaultix-edit";
    meta.mainProgram = "vaultix-edit";
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
      inherit tack;
      inherit (pkgs) alejandra dix nh nixd;

      # qml
      inherit (pkgs) quickshell;
      inherit (pkgs.qt6) qtdeclarative;

      # vaultix
      inherit vaultix-edit vaultix-renc;
      inherit (pkgs) age;
    };
  }
