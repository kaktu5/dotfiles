{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs) nixpkgs;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault;
  inherit (pkgs.lixPackageSets.latest) lix;
in {
  persistence = {
    directories = ["/var/cache/nix"];

    users.${userName}.directories = [".local/cache/nix"];
  };

  nix = {
    package = lix;

    channel.enable = false;

    settings = {
      accept-flake-config = false;
      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        "coerce-integers"
        "flakes"
        "nix-command"
        "pipe-operator"
      ];
      flake-registry = null;
      nix-path = ["nixpkgs=${nixpkgs}"];

      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];

      auto-allocate-uids = true;
      use-cgroups = true;

      keep-derivations = mkDefault false;
      use-xdg-base-directories = true;

      log-format = "multiline-with-logs";
      log-lines = 32;
      warn-dirty = false;
      warn-import-from-derivation = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = ["Sat *-*-* 03:00"];
      randomizedDelaySec = "15min";
    };
  };

  systemd = {
    services.nix-gc = {
      unitConfig.ConditionACPower = true;

      serviceConfig = {
        ExecStartPost = "${getExe lix} store optimise";
        Slice = "background.slice";
      };
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
