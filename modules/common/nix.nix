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
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      trusted-users = ["root" "${username}"];
      auto-optimise-store = true;
      warn-dirty = false;
    };
  };
  systemd.tmpfiles.rules = [
    "L /etc/nixos/flake.nix - - - - /home/${username}/dotfiles/flake.nix"
  ];
}
