{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (inputs'.aagl-gtk-on-nix.packages) sleepy-launcher;
  inherit (lib.lists) elem;
  inherit (lib.modules) mkIf;
in
  mkIf (gaming.enable && elem "zenless-zone-zero" gaming.games) {
    persistence.users.${userName}.directories = [".local/cache/sleepy-launcher" ".local/share/sleepy-launcher"];

    users.users.${userName}.packages = [sleepy-launcher];
  }
