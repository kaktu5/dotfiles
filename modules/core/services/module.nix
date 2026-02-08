{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  imports = [
    ./systemd.nix

    ./dbus.nix
    ./greetd.nix
    ./nix.nix
    ./userborn.nix
  ];

  services.speechd.enable = mkForce false;
}
