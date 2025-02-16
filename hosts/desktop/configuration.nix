_: {
  imports = [../../modules/profile/disk-layouts/luks-btrfs];
  users.users.kkts.initialPassword = "nix";
  kkts = {
    hardware = {
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
      bluetooth.enable = true;
      bootloader.enable = true;
      fileSystems = {
        trim.enable = true;
        scrub.btrfs.enable = true;
      };
      rootFileSystem = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64DNL0T802589T";
        root = "/dev/mapper/nix_pool-root";
        swapSize = 32;
      };
      monitors = {
        primaryMonitor = "HDMI-A-1";
        monitors = {
          "HDMI-A-1" = {
            position = {x = 0;} // {y = 0;};
            refreshRate = 75;
            resolution = {w = 1920;} // {h = 1080;};
            rotation = 0;
            scale = 1.0;
          };
        };
      };
    };
  };
}
