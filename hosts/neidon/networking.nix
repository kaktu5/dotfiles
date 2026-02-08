{config, ...}: let
  inherit (config.networking) hostName;

  device = "enp1s0f0";
  address = "10.0.0.2";
  gateway = "10.0.0.1";
in {
  boot = {
    kernelParams = ["ip=${address}::${gateway}:255.255.255.0:${hostName}:${device}:none"];

    initrd.kernelModules = ["r8169"];
  };

  systemd.network.networks."0-${device}" = {
    matchConfig.Name = device;
    networkConfig = {
      Address = "${address}/24";
      Gateway = gateway;
    };
  };
}
