{
  lib,
  ...
}: let
  inherit (lib.generators) toKeyValue;

  timeoutConfig = {
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutAbortSec = "10s";
    DefaultDeviceTimeoutSec = "10s";
  };
in {
  boot.initrd.systemd.settings.Manager = timeoutConfig;

  systemd = {
    enableEmergencyMode = false;

    settings.Manager = timeoutConfig;
    user.extraConfig = toKeyValue {} {
      inherit (timeoutConfig) DefaultTimeoutStartSec DefaultTimeoutStopSec DefaultTimeoutAbortSec;
    };

    services = {
      "autovt@".enable = false;
      "getty@".enable = false;
    };
  };
}
