{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (inputs'.aagl-gtk-on-nix.packages) sleepy-launcher;
  inherit (lib.modules) mkIf;
in
  mkIf (gaming.enable && gaming.zenlessZoneZero.enable) {
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
