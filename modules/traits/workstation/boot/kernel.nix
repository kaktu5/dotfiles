{inputs', ...}: let
  inherit (inputs'.nixpkgs-xanmod.legacyPackages) linuxPackages_xanmod_latest;
in {
  boot.kernelPackages = linuxPackages_xanmod_latest;
}
