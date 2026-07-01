{
  inputs,
  lib,
  pkgs,
  system,
}: let
  inherit (inputs.nix-secrets.packages.${system}) nix-secrets;
  inherit (inputs.tack.packages.${system}) tack;
  inherit (lib.attrsets) attrValues;
  inherit (lib.meta) getExe;
  inherit (pkgs) mkShellNoCC;
  inherit (pkgs.lixPackageSets.latest) lix;
in
  mkShellNoCC {
    name = "dotfiles-devshell";

    env = {
      NH_FLAKE = "/var/home/dotfiles";
      NH_NO_CHECKS = "1"; # I know what I'm doing
      NIX_SECRETS_NIX_EVAL_COMMAND = "${getExe lix} eval --raw --read-only";
      NIX_SECRETS_STORAGE_PATH = "/var/home/dotfiles/secrets";
      TACK_NIX_CONF_TOKENS = "1";
    };

    packages = attrValues {
      # nix
      inherit nix-secrets tack;
      inherit (pkgs) alejandra dix nh nixd;

      # qml
      inherit (pkgs) quickshell;
      inherit (pkgs.qt6) qtdeclarative;
    };
  }
