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
      inherit (pkgs) alejandra deno fd;
      inherit (pkgs.kdePackages) qtdeclarative;
    };
    text = ''
      fd "$@" -t f -e md -X deno fmt '{}'
      fd "$@" -t f -e nix -X alejandra --quiet '{}'
      fd "$@" -t f -e qml -x qmlformat --inplace '{}'
    '';
  }
