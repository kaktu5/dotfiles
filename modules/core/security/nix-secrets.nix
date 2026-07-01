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
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;
  inherit (pkgs) age;
in {
  imports = [nix-secrets.nixosModules.default];

  preservation.preserveAt."/persist".files = singleton {
    file = "/etc/nix-secrets/key";
    mode = "400";
  };

  security.nix-secrets = {
    enable = true;

    installPackage = false;
    extraPackages = [age];

    nixEvalCommand = "${getExe nix.package} eval --raw --read-only";

    identityPaths = ["/etc/nix-secrets/key"];
    defaultRecipients = [hostName];

    storage = flake + /secrets;
  };
}
