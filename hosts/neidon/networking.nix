{
  systemd.network.networks."0-lan" = {
    matchConfig.Name = "enp1s0f0";
    networkConfig = {
      Address = "10.0.0.2/24";
      Gateway = "10.0.0.1";
    };
  };
}
