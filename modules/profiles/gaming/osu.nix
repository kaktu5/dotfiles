{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.nixpkgs.config) allowUnfree;
  inherit (inputs'.nixexprs.packages) osu-lazer-bin;
  inherit (lib.lists) elem singleton;
  inherit (lib.modules) mkIf;
in
  mkIf (gaming.enable && elem "osu" gaming.games) {
    persistence.users.${userName} = {
      directories = [".local/share/osu"];

      files = singleton {
        target = ".local/share/osu/AuthNative.so";
        mountOptions = ["exec"];
      };
    };

    users.users.${userName}.packages =
      singleton
      <| (osu-lazer-bin.overrideAttrs {
        # hack to allow an unfree package from a flake
        meta.unfree = !allowUnfree;
      }).override {
        releaseStream = "tachyon";
      };
  }
