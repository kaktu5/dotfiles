{
  config,
  inputs,
  ...
}: let
  inherit (config.kkts.system) username;
in {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      allowed-users = ["@builders" "@wheel"];
      trusted-users = ["root" "@wheel"];
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "60min";
      options = "--delete-older-than 14d";
    };
  };
  systemd.tmpfiles.rules = [
    "L /etc/nixos/flake.nix - - - - /home/${username}/dotfiles/flake.nix"
  ];
}
