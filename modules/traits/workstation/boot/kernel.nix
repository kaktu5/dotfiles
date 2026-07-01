{pkgs, ...}: let
  inherit (pkgs) linuxPackages_xanmod_latest;
  inherit (pkgs.scx) rustscheds;

  scheduler = "scx_lavd";
  package = rustscheds.overrideAttrs (old: {
    pname = scheduler;

    cargoBuildFlags = (old.cargoBuildFlags or []) ++ ["--package" scheduler];

    postInstall = "";

    passthru = (old.passthru or {}) // {schedulers = [scheduler];};
  });
in {
  boot.kernelPackages = linuxPackages_xanmod_latest;

  services.scx = {
    enable = true;

    inherit package scheduler;
  };
}
