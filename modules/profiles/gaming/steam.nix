{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (lib.modules) mkIf;
  inherit (pkgs) proton-ge-bin;

  cfg = config.kkts.profiles.gaming.steam;
in
  mkIf cfg.enable {
    preservation.preserveAt."/persist".users.${userName}.directories = [
      {
        directory = "${xdg.data.directory}/Steam";
        mountOptions = ["exec"];
      }
      ".steam"
    ];

    programs.steam = {
      enable = true;

      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = [proton-ge-bin];
    };
  }
