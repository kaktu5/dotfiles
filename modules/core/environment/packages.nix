{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.modules) mkForce;
in {
  environment = {
    systemPackages = attrValues {
      inherit
        (pkgs)
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

    corePackages = mkForce [];
    defaultPackages = mkForce [];
  };
}
