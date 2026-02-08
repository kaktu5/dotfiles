{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };

    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
    };

    "/persist" = {
      device = "rpool/persist";
      fsType = "zfs";
    };
  };

  kkts.zramSwap = {
    enable = true;
    size = 4 * 1024 * 1024 * 1024;
    writeback.device = "/dev/disk/by-partuuid/d9eb2e78-4ac3-4d08-9b65-07c05a119d04";
  };
}
