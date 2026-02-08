{config, ...}: let
  inherit (config.systemd.network) networks;

  device = "enp1s0f0";
  address = "10.0.0.2";
  gateway = "10.0.0.1";
in {
  boot.initrd = {
    kernelModules = ["r8169"];

    systemd.network.networks."00-${device}" = networks."00-${device}";
  };

  systemd.network.networks."00-${device}" = {
    matchConfig.Name = device;
    networkConfig = {
      Address = "${address}/24";
      Gateway = gateway;
    };
  };
}
