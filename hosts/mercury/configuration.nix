_: {
  imports = [../../modules/profile/disk-layouts/tmpfs.nix];
  users.users.kkts.initialPassword = "nix";
  kkts.hardware = {
    amd.cpu.enable = true;
    bootloader.enable = true;
    fileSystems = {
      trim.enable = true;
      scrub.btrfs.enable = true;
    };
    rootFileSystem = {
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HAHQ-000L7_S41GNX1M102698";
      swapSize = 16;
    };
  };
}
