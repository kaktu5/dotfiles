{config, ...}: let
  inherit (builtins) toString;
  inherit (config.kkts.hardware.rootFileSystem) device swapSize;
  swapSize' = "${toString swapSize}G";
in {
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["mode=755" "size=4G"];
    };
    disk.root = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            priority = 1;
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077" "noatime"];
            };
          };
          root = {
            priority = 2;
            end = "-${swapSize'}";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = ["compress=zstd" "noatime"];
                };
              };
            };
          };
          swap = {
            priority = 3;
            size = swapSize';
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
