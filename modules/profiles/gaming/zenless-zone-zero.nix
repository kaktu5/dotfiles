{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (inputs'.aagl-gtk-on-nix.packages) sleepy-launcher;
  inherit (lib.modules) mkIf;

  cfg = config.kkts.profiles.gaming.zenless-zone-zero;
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
