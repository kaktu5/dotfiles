_: {
  environment.persistence."/persist/root".directories = [
    "/etc/NetworkManager/system-connections"
  ];
  boot.initrd.systemd.network.wait-online.enable = false;
  networking.networkmanager.enable = true;
}
