{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.xdg-utils-nu.packages.${system}) xdg-utils-nu-uutils;
  inherit (lib.lists) singleton;
in {
  nixpkgs.overlays = singleton (_: _: {
    xdg-utils = xdg-utils-nu-uutils;
  });
}
