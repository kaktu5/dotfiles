{
  modulesPath,
  pkgs,
  ...
}: {
  imports = ["${modulesPath}/installer/cd-dvd/iso-image.nix"];
  nix = {
    package = pkgs.lix;
    settings.experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };
  users = {
    mutableUsers = false;
    users = rec {
      root = {
        initialPassword = "nixos";
        hashedPassword = null;
      };
      nixos = root;
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
