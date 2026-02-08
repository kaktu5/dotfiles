{
  imports = [
    ./systemd.nix

    ./dbus.nix
    ./dnscrypt-proxy.nix
    ./greetd.nix
    ./nix.nix
    ./openntpd.nix
    ./openssh.nix
    ./userborn.nix
  ];

  services.speechd.enable = false;
}
