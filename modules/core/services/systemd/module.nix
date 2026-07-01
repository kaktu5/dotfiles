{
  config,
  pkgs,
  ...
}: let
  commonConfig = {
    CtrlAltDelBurstAction = "none";
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutAbortSec = "10s";
    DefaultDeviceTimeoutSec = "10s";
  };
in {
  boot.initrd.systemd = {
    settings.Manager = commonConfig;

    services.debug-shell.enable = false;

    suppressedUnits = ["ctrl-alt-del.target"];
  };

  systemd = {
    package = import ./package.nix {inherit config pkgs;};

    enableEmergencyMode = false;

    settings.Manager = commonConfig;
    user.settings.Manager = {
      inherit (commonConfig) DefaultTimeoutStartSec DefaultTimeoutStopSec DefaultTimeoutAbortSec;
    };

    ctrlAltDelUnit = "noop.target";

    slices.background.sliceConfig = {
      CPUWeight = "idle";
      IOWeight = 1;

      MemorySwapMax = "0";

      ManagedOOMMemoryPressure = "kill";
      ManagedOOMSwap = "kill";
    };

    services = {
      "autovt@".enable = false;
      # "getty@".enable = false; # TODO: disable tty
      debug-shell.enable = false;
    };

    targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
      noop.unitConfig.DefaultDependencies = false;
    };
  };
}
