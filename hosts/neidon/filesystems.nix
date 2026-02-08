{lib, ...}: let
  inherit (lib.lists) singleton;
in {
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

  swapDevices = singleton {
    device = "/dev/disk/by-partuuid/d9eb2e78-4ac3-4d08-9b65-07c05a119d04";
    randomEncryption = {
      enable = true;
      allowDiscards = true;
      keySize = 512;
      sectorSize = 4096;
    };
    discardPolicy = "once";
  };
}
