{
  config,
  flake,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config) nix;
  inherit (config.networking) hostName;
  inherit (inputs) nix-secrets;
  inherit (lib.meta) getExe;
  inherit (pkgs) age;
in {
  imports = [nix-secrets.nixosModules.default];

  security.nix-secrets = {
    enable = true;

    installPackage = false;
    extraPackages = [age];

    nixEvalCommand = "${getExe nix.package} eval --raw --read-only";

    identityPaths = ["/etc/age/keys"];
    defaultRecipients = [hostName];

    storage = flake + /secrets;
  };
}
