{
  lib,
  pkgs,
  self,
  system,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.meta) getExe;
  inherit (pkgs) mkShellNoCC writeShellScriptBin;

  vaultix' = self.vaultix.app.${system};

  vaultix-edit = writeShellScriptBin "vaultix-edit" "${getExe vaultix'.edit} $@";
  vaultix-renc = writeShellScriptBin "vaultix-renc" (toString <| getExe vaultix'.renc);
in
  mkShellNoCC {
    name = "dotfiles-devshell";
    packages = attrValues {
      # nix
      inherit
        (pkgs)
        age
        alejandra
        dix
        nh
        nixd
        ;
      inherit vaultix-edit vaultix-renc;

      # qml
      inherit (pkgs.kdePackages) qtdeclarative;
    };
  }
