{
  lib,
  pkgs,
}: let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.meta) getExe;
  inherit (pkgs) callPackage;

  rootDir = ../.;
in
  mapAttrs (name: value: {
    type = "app";
    program = getExe value;
  }) {
    provision = callPackage /${rootDir}/components/provision/package.nix {};
  }
