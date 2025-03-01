{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.kkts) mkWrapper;
  inherit (pkgs.stdenv) mkDerivation;
  btopConfig = mkDerivation {
    name = "btop-config";
    buildCommand = ''
      mkdir -p $out/btop
      cp ${./btop.conf} $out/btop/btop.conf
    '';
  };
  btop' = mkWrapper "btop" [pkgs.btop] [
    "--set XDG_CONFIG_HOME ${btopConfig}"
  ];
in {home.packages = [btop'];}
