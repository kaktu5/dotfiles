{pkgs, ...}: let
  inherit (pkgs) linuxPackages_xanmod_latest zfs;
in {
  boot = {
    kernelPackages = linuxPackages_xanmod_latest;

    zfs.package = zfs;
  };
}
