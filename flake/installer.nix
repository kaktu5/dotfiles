{
  modulesPath,
  nixpkgs,
  ...
}: let
  pkgs = nixpkgs.legacyPackages;
in {
  imports = ["${modulesPath}/installer/cd-dvd/iso-image.nix"];
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    settings.experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };
  users = {
    mutableUsers = false;
    users = {
      root = {
        initialPassword = "nixos";
        hashedPassword = null;
      };
      nixos = {
        initialPassword = "nixos";
        hashedPassword = null;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    btop
    disko
    neovim
  ];
  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."10-wired" = {
      matchConfig.Name = "enp*";
      networkConfig.DHCP = "no";
      address = ["192.168.1.254/24"];
      routes = [{Gateway = "192.168.1.1";}];
    };
  };
}
