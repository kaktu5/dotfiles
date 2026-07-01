{pkgs, ...}: let
  inherit (pkgs) linuxPackages_latest;
in {
  boot.kernelPackages = linuxPackages_latest;
}
