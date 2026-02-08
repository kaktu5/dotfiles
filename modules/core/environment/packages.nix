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
        file
        gnutar
        lsof
        procps
        ripgrep
        util-linux
        uutils-coreutils-noprefix
        uutils-diffutils
        uutils-findutils
        xz
        zstd
        ;
    };

    corePackages = mkForce [];
    defaultPackages = mkForce [];
  };
}
