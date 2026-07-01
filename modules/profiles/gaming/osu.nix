{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (lib.lists) elem singleton;
  inherit (lib.modules) mkIf;
  inherit (pkgs.ktu5) osu-lazer-bin;
in
  mkIf (gaming.enable && elem "osu" gaming.games) {
    persistence.users.${userName} = {
      directories = [".local/share/osu"];

      files = singleton {
        target = ".local/share/osu/AuthNative.so";
        mountOptions = ["exec"];
      };
    };

    users.users.${userName}.packages = [
      (osu-lazer-bin.override {releaseStream = "tachyon";})
    ];
  }
