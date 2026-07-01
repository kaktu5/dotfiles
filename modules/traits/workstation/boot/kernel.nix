{
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.nixpkgs-xanmod.legacyPackages.${system}) linuxPackages_xanmod_latest;
in {
  boot.kernelPackages = linuxPackages_xanmod_latest;
}
