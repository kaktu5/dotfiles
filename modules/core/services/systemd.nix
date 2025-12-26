let
  timeoutConfig = {
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutAbortSec = "10s";
    DefaultDeviceTimeoutSec = "10s";
  };
in {
  boot.initrd.systemd = {
    enable = true;
    settings.Manager = timeoutConfig;
  };

  systemd = {
    enableEmergencyMode = false;

    settings.Manager = timeoutConfig;
    user.extraConfig = ''
      DefaultTimeoutStartSec=10s
      DefaultTimeoutStopSec=10s
      DefaultTimeoutAbortSec=10s
    '';

    network.wait-online.enable = false;

    services = {
      "autovt@".enable = false;
      "getty@".enable = false;
    };
  };
}
