{
  config,
  pkgs,
  ...
}: let
  package = pkgs.systemd.override (let
    withCoredump = config.systemd.coredump.enable;
    withResolved = config.services.resolved.enable || config.boot.initrd.services.resolved.enable;
    withTimesyncd = config.services.timesyncd.enable;
  in {
    inherit withCoredump;
    withHomed = false;
    withHostnamed = false;
    withImportd = false;
    withLocaled = false;
    withPasswordQuality = false;
    withPortabled = false;
    withRemote = false;
    inherit withResolved;
    withSysupdate = false;
    withTimedated = false;
    inherit withTimesyncd;
    withUserDb = false;
    withNss = withResolved;
    withKexectools = false;
  });

  commonConfig = {
    CtrlAltDelBurstAction = "none";
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutAbortSec = "10s";
    DefaultDeviceTimeoutSec = "10s";
  };
in {
  boot.initrd.systemd = {
    emergencyAccess = false;

    settings.Manager = commonConfig;

    services.debug-shell.enable = false;

    suppressedUnits = ["ctrl-alt-del.target"];
  };

  systemd = {
    inherit package;

    enableEmergencyMode = false;

    settings.Manager = commonConfig;
    user.settings.Manager = {
      inherit (commonConfig) DefaultTimeoutStartSec DefaultTimeoutStopSec DefaultTimeoutAbortSec;
    };

    services = {
      "autovt@".enable = false;
      "getty@".enable = false;
      debug-shell.enable = false;
    };

    targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
      noop.unitConfig.DefaultDependencies = false;
    };

    ctrlAltDelUnit = "noop.target";
  };
}
