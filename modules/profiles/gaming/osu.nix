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
  inherit (lib.lists) singleton;
in
  mkIf (gaming.enable && gaming.osu.enable) {
    users.users.${userName}.packages = [osu-lazer-bin];
    persistence.users.${userName} = {
      # TODO: fix after `https://github.com/manic-systems/nixos-core/issues/62`
      # directories = [".local/share/osu"];

      # files = singleton {
      #   target = ".local/share/osu/AuthNative.so";
      #   mountOptions = ["exec"];
      # };

      directories = singleton {
        target = ".local/share/osu";
        mountOptions = ["exec"];
      };
    };
  }
