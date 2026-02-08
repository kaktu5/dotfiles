{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (pkgs.lixPackageSets.latest) lix;
  inherit (pkgs.writers) writeJSON;
in {
  nix = {
    package = lix;

    nixPath = ["nixpkgs=${nixpkgs}"];

    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        "coerce-integers"
        "flakes"
        "nix-command"
        "pipe-operator"
      ];

      auto-allocate-uids = true;
      use-cgroups = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      accept-flake-config = false;

      keep-outputs = true;
      warn-dirty = false;

      flake-registry = writeJSON "flake-registry-empty.json" {
        flakes = [];
        version = 2;
      };
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = ["Fri *-*-* 03:00"];
      randomizedDelaySec = "15min";
    };

    optimise = {
      automatic = true;
      dates = ["Fri *-*-* 04:00"];
      randomizedDelaySec = "15min";
    };
  };
}
