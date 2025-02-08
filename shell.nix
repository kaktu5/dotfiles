{
  lib,
  pkgs,
}: let
  inherit (lib) getExe;
in
  pkgs.mkShell {
    shellHook = "${getExe pkgs.cloc} .";
    packages = with pkgs; [
      alejandra
      cloc
      deadnix
      statix
    ];
  }
