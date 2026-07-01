{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.kkts.profiles.gaming.steam) games;
  inherit (lib.lists) elem flatten optional;
  inherit (lib.modules) mkIf;
  inherit (pkgs) proton-ge-bin;
in
  mkIf (gaming.enable && gaming.steam.enable) {
    preservation.preserveAt."/persist".users.${userName}.directories = flatten [
      {
        directory = "${xdg.data.directory}/Steam";
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
