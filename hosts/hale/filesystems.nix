{lib, ...}: let
  inherit (lib.lists) singleton;
in {
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["mode=755" "nodev" "noexec" "nosuid" "size=128M"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/315C-0224";
      fsType = "vfat";
      options = ["nodev" "noexec" "nosuid" "umask=077"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/32566e0f-59a9-4bf0-8aa2-73a575ca7f03";
      fsType = "xfs";
      options = ["noatime" "nodev" "nosuid"];
    };

    "/nix/persist" = {
      device = "/nix/persist";
      fsType = "none";
      options = ["bind" "nodev" "noexec" "nosuid" "relatime"];
      neededForBoot = true;
    };
  };

  kkts.persistence.store = "/nix/persist";

  swapDevices = singleton {
    device = "/dev/disk/by-partuuid/7f455d6e-560b-4d1b-ab97-6b336fa43378";
    discardPolicy = "once";
    randomEncryption = {
      enable = true;
      cipher = "aes-xts-plain64";
      keySize = 512;
      sectorSize = 4096;
      allowDiscards = true;
    };
  };
}
