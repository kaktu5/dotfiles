{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (inputs'.aagl-gtk-on-nix.packages) sleepy-launcher;
  inherit (lib.modules) mkIf;
in
  mkIf (gaming.enable && gaming.zenlessZoneZero.enable) {
    persistence.users.${userName} = {
      directories = [
        {
          # TODO: move to gaming/config.nix
          target = "games";
          mountOptions = ["exec"];
        }
        ".local/cache/sleepy-launcher"
        ".local/share/sleepy-launcher"
      ];
    };

    users.users.${userName}.packages = [sleepy-launcher];
  }
