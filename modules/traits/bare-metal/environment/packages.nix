{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit
      (pkgs)
      bash
      inetutils
      iproute2
      lsof
      procps
      util-linux
      uutils-coreutils-noprefix
      uutils-diffutils
      uutils-findutils
      ;
  };
}
