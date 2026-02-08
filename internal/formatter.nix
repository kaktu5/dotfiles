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
      inherit (pkgs) alejandra fd mdformat taplo;
      inherit (pkgs.kdePackages) qtdeclarative;
    };
    runtimeEnv.RUST_LOG = "warn";
    text = ''
      fd "$@" -t f -e md -X mdformat '{}'
      fd "$@" -t f -e nix -E .tack/default.nix -X alejandra --quiet '{}'
      fd "$@" -t f -e qml -x qmlformat --inplace '{}'
      fd "$@" -t f -e toml -X taplo format '{}'
    '';
  }
