{
  systemd.network.networks."0-wan" = {
    matchConfig.Name = "ens18";
    networkConfig = {
      Address = "10.77.40.65/26";
      Gateway = "10.77.40.64";
    };
  };
}
