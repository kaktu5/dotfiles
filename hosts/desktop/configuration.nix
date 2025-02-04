_: {
  kkts = {
    system.hostname = "desktop";
    impermanence.root = "/dev/mapper/nix_pool-root";
    hardware = {
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
      bluetooth.enable = true;
      fstrim = {
        enable = true;
        btrfs.enable = true;
      };
      monitors = {
        main = "HDMI-A-1";
        monitors = {
          "HDMI-A-1" = {
            resolution = {
              w = 1920;
              h = 1080;
            };
            refreshRate = 75;
            position = {
              x = 0;
              y = 0;
            };
            scale = 1.0;
          };
        };
      };
    };
  };
}
