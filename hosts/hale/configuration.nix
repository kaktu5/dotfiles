{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
in {
  security.nix-secrets.enable = lib.mkForce false;

  users.users.${userName}.initialPassword = "nix";

  kkts.boot.loader = "limine";

  system.stateVersion = "26.11";
}
