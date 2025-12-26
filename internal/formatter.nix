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
    };
    text = ''
      fd "$@" -t f -e md -X mdformat --wrap 120 '{}'
      fd "$@" -t f -e nix -E npins/ -X alejandra --quiet '{}'
    '';
  }
