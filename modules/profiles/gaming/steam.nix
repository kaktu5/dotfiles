{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.kkts.profiles.gaming.steam) games;
  inherit (lib.lists) elem flatten optional;
  inherit (lib.modules) mkIf;
  inherit (pkgs) proton-ge-bin;
in
  mkIf (gaming.enable && gaming.steam.enable) {
    persistence.users.${userName}.directories = flatten [
      {
        target = ".local/share/Steam";
        mountOptions = ["exec"];
      }

      (optional (games |> elem "factorio") ".factorio")
    ];

    programs.steam = {
      enable = true;

      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = [proton-ge-bin];
    };
  }
