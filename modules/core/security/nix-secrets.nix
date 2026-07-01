{
  config,
  flake,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (inputs) nix-secrets;
  inherit (pkgs) age;
in {
  imports = [nix-secrets.nixosModules.default];

  security.nix-secrets = {
    enable = true;

    installPackage = false;
    extraPackages = [age];

    identityPaths = ["/persist/etc/nix-secrets/key"];
    defaultRecipients = [hostName];

    storage = flake + /secrets;
  };
}
