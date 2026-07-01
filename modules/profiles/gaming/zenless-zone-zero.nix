{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.aagl-gtk-on-nix.packages.${system}) sleepy-launcher;
  inherit (lib.modules) mkIf;

  cfg = config.kkts.profiles.gaming.steam;
in
  mkIf cfg.enable {
    preservation.preserveAt."/persist".users.${userName} = {
      directories = [
        {
          directory = "games";
          mountOptions = ["exec"];
        }
        "${xdg.cache.directory}/sleepy-launcher"
        "${xdg.data.directory}/sleepy-launcher"
      ];
    };

    users.users.${userName}.packages = [sleepy-launcher];
  }
