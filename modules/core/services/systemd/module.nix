{
  config,
  pkgs,
  ...
}: let
  package = import ./package.nix {inherit config pkgs;};

  timeout = "10s";

  timeouts = {
    DefaultTimeoutAbortSec = timeout;
    DefaultTimeoutStartSec = timeout;
    DefaultTimeoutStopSec = timeout;
  };

  manager =
    timeouts
    // {
      CtrlAltDelBurstAction = "none";
      DefaultDeviceTimeoutSec = timeout;
    };
in {
  persistence = {
    directories = ["/var/lib/systemd/rfkill" "/var/lib/systemd/timers"];
    files = ["/var/lib/systemd/random-seed"];
  };

  fileSystems."/var/lib/systemd/credential.secret" = {
    device = "/persist/var/lib/systemd/credential.secret";
    fsType = "none";
    options = ["bind"];
  };

  boot.initrd.systemd = {
    settings.Manager = manager;

    services.debug-shell.enable = false;
    targets.ctrl-alt-del.enable = false;
  };

  systemd = {
    inherit package;

    settings.Manager = manager;
    user.settings.Manager = timeouts;

    enableEmergencyMode = false;
    ctrlAltDelUnit = "/dev/null";

    services = {
      "autovt@".enable = false;
      debug-shell.enable = false;
    };

    targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    slices.background.sliceConfig = {
      CPUWeight = "idle";
      IOWeight = 1;

      MemorySwapMax = "0";

      ManagedOOMMemoryPressure = "kill";
      ManagedOOMSwap = "kill";
    };
  };
}
