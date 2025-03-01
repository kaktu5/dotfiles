{lib, ...}: {
  networking = {
    useDHCP = false;
    networkmanager.enable = lib.mkForce false; # tmp
  };
  systemd.network = {
    enable = true;
    networks."10-wired" = {
      matchConfig.Name = "enp1s0f0";
      networkConfig.DHCP = "no";
      address = ["192.168.1.69/24"];
      routes = [{Gateway = "192.168.1.1";}];
    };
  };
}
