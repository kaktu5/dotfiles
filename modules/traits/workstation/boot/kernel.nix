{pkgs, ...}: let
  inherit (pkgs) linuxPackages_xanmod_latest;
  inherit (pkgs.scx) rustscheds;

  schedulerName = "scx_lavd";
  schedulerPackage = rustscheds.overrideAttrs (old: {
    pname = schedulerName;

    cargoBuildFlags = (old.cargoBuildFlags or []) ++ ["--package" schedulerName];

    postInstall = "";

    passthru = (old.passthru or {}) // {schedulers = [schedulerName];};
  });
in {
  boot.kernelPackages = linuxPackages_xanmod_latest;

  services.scx-loader = {
    enable = true;

    schedsPackages = [schedulerPackage];

    config.default_sched = schedulerName;
  };
}
