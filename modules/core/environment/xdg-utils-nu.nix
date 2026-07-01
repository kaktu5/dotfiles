{
  inputs',
  lib,
  ...
}: let
  inherit (inputs'.xdg-utils-nu.packages) xdg-utils-nu-uutils;
  inherit (lib.lists) singleton;
in {
  nixpkgs.overlays = singleton (_: _: {
    xdg-utils = xdg-utils-nu-uutils;
  });
}
