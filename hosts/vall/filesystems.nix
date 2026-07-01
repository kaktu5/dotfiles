{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/14A1-CF45";
      fsType = "vfat";
    };

    "/nix" = {
      device = "nixos/nix";
      fsType = "zfs";
    };

    "/persist" = {
      device = "nixos/persist";
      fsType = "zfs";
    };
  };

  zramSwap.memoryMax = 8 * 1024 * 1024 * 1024;
}
