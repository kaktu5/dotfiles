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

  timeoutConfig = {
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutAbortSec = "10s";
    DefaultDeviceTimeoutSec = "10s";
  };
in {
  boot.initrd.systemd.settings.Manager = timeoutConfig;

  systemd = {
    inherit package;

    enableEmergencyMode = false;

    settings.Manager = timeoutConfig;
    user.settings.Manager = {
      inherit (timeoutConfig) DefaultTimeoutStartSec DefaultTimeoutStopSec DefaultTimeoutAbortSec;
    };

    services = {
      "autovt@".enable = false;
      "getty@".enable = false;
    };
  };
}
