{
  lib,
  pkgs,
}: let
  inherit (lib.attrsets) attrValues;
  inherit (pkgs) writeShellApplication;
in
  writeShellApplication {
    name = "dotfiles-nix3-fmt-wrapper";
    runtimeInputs = attrValues {
      inherit (pkgs) alejandra fd mdformat;
      inherit (pkgs.kdePackages) qtdeclarative;
    };
    text = ''
      fd "$@" -t f -e md -X mdformat '{}'
      fd "$@" -t f -e nix -X alejandra --quiet '{}'
      fd "$@" -t f -e qml -x qmlformat --inplace '{}'
    '';
  }
