{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
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

  kkts.zramSwap = {
    enable = true;
    size = 4 * 1024 * 1024 * 1024;
    writeback.device = "/dev/disk/by-partuuid/3354094e-09b3-4904-b813-63c84a467e96";
  };
}
