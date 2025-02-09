{inputs, ...}: {
  users.users.kkts.initialPassword = "nix";
  kkts = {
    system.hostname = "desktop";
    rootfs = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64DNL0T802589T";
      root = "/dev/mapper/nix_pool-root";
      swapSize = 32;
    };
    hardware = {
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };
      bluetooth.enable = true;
      filesystems = {
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
  # todo: make a universal overlay function that overwrites package
  # with version from nixos-unstable-small
  nixpkgs.overlays = [
    (_: prev: {
      inherit (import inputs.nixpkgs-small {inherit (prev) system;}) python311Packages;
      inherit (import inputs.nixpkgs-small {inherit (prev) system;}) python312Packages;
    })
  ];
}
