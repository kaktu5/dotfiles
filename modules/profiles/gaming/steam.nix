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
  inherit (pkgs) proton-ge-bin steamWithMillennium;
in
  mkIf (gaming.enable && gaming.steam.enable) {
    persistence.users.${userName}.directories = flatten [
      {
        target = ".local/share/Steam";
        mountOptions = ["exec"];
      }
      ".config/millennium" # TODO: generate using hjem
      ".local/share/millennium"

      (optional (games |> elem "factorio") ".factorio")
    ];

    programs.steam = {
      enable = true;
      package = steamWithMillennium;

      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = [proton-ge-bin];
    };
  }
