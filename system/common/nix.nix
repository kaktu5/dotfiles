{
  config,
  pkgs,
  ...
}: let
  inherit (config.home) directory;
in {
  nix = {
    package = pkgs.lix;
    settings = {
      allowed-users = ["@builders" "@wheel"];
      trusted-users = ["root" "@wheel"];
      experimental-features = ["flakes" "nix-command"];
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
    "L /etc/nixos/flake.nix - - - - ${directory}/dotfiles/flake.nix"
  ];
}
