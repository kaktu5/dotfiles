{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (lib.modules) mkIf;
  inherit (pkgs) osu-lazer-bin;
in
  mkIf (gaming.enable && gaming.osu.enable) {
    persistence.users.${userName}.directories = [".local/share/osu"];

    users.users.${userName}.packages = [osu-lazer-bin];
  }
