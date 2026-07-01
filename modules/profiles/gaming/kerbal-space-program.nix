{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toJSON;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkIf;
  inherit (pkgs) ckan;
in
  mkIf (gaming.enable && gaming.kerbalSpaceProgram.enable) {
    persistence.users.${userName} = {
      directories = [".local/share/CKAN/downloads" ".local/share/CKAN/repos"];
      files = [".local/share/CKAN/builds-ksp.json"];
    };

    users.users.${userName}.packages = [ckan];

    hjem.users.${userName}.xdg.data.files."CKAN/config.json" = {
      generator = toJSON {};
      value = {
        AutoStartInstance = "ksp";
        Language = "en-US";
        GameInstances = singleton {
          Name = "ksp";
          Path = "${home}/games/kerbal-space-program/game";
          Game = "KSP";
        };
        AuthTokens = {};
        GlobalInstallFiltersByGame = {};
        PreferredHosts = [];
      };
      type = "copy";
      permissions = "644";
    };
  }
