{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.kkts.profiles.gaming.steam) games;
  inherit (inputs) millennium;
  inherit (lib.lists) elem flatten optional;
  inherit (lib.modules) mkIf;
  inherit (pkgs) callPackage proton-ge-bin;

  # TODO: https://github.com/NixOS/nixpkgs/pull/538226
  package = callPackage "${millennium}/packages/nix/steam.nix" {
    millennium = callPackage "${millennium}/packages/nix/millennium.nix" {
      millennium-src = millennium;

      libXi = pkgs.libxi;
      libXtst = pkgs.libxtst;
    };
  };
in
  mkIf (gaming.enable && gaming.steam.enable) {
    persistence.users.${userName}.directories = flatten [
      {
        target = ".local/share/Steam";
        mountOptions = ["exec"];
      }
      ".config/millennium" # TODO: generate using hjem
      ".local/share/millennium"

      (optional (games |> elem "factorio") ".factorio")
    ];

    programs.steam = {
      enable = true;
      inherit package;

      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = [proton-ge-bin];
    };
  }
