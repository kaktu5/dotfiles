{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (lib.modules) mkIf;
  inherit (pkgs) ckan;
in
  mkIf (gaming.enable && gaming.kerbalSpaceProgram.enable) {
    persistence.users.${userName}.directories = [".local/share/CKAN"];

    users.users.${userName}.packages = [ckan];
  }
