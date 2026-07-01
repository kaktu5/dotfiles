{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (inputs) nixpkgs;
  inherit (lib.modules) mkDefault;
  inherit (pkgs.lixPackageSets.latest) lix;
  inherit (pkgs.writers) writeJSON;
in {
  preservation.preserveAt."/persist" = {
    directories = ["/var/cache/nix"];

    users.${userName}.directories = ["${xdg.cache.directory}/nix"];
  };

  nix = {
    package = lix;

    channel.enable = false;

    nixPath = ["nixpkgs=${nixpkgs}"];

    settings = {
      experimental-features = ["auto-allocate-uids" "cgroups" "coerce-integers" "flakes" "nix-command" "pipe-operator"];

      auto-allocate-uids = true;
      use-cgroups = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      accept-flake-config = false;

      keep-derivations = mkDefault false;
      use-xdg-base-directories = true;

      warn-dirty = false;
      warn-import-from-derivation = true;

      log-format = "multiline-with-logs";
      log-lines = 64;

      flake-registry = writeJSON "flake-registry-empty.json" {
        flakes = [];
        version = 2;
      };
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = ["Sat *-*-* 03:00"];
      randomizedDelaySec = "15min";
    };

    optimise.automatic = true;
  };

  systemd = {
    timers.nix-optimise.enable = false;

    services.nix-gc = {
      wants = ["nix-optimise.service"];
      before = ["nix-optimise.service"];
    };
  };

  # nukes persistent `nix profile` on boot
  # must be writable so the nix daemon can create internal dirs
  fileSystems."/nix/var/nix/profiles/per-user" = {
    device = "none";
    fsType = "tmpfs";
    options = ["X-mount.mkdir" "mode=755" "size=4k"];
  };
}
