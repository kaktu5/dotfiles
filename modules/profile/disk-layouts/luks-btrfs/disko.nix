{
  config,
  lib,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) mkIf;
  cfg = config.kkts.hardware.rootFileSystem;
in {
  disko.devices = {
    disk.root = {
      inherit (cfg) device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077" "noatime"];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "nix_crypted";
              settings = {
                keyFile = "/tmp/nix_pool.key";
                allowDiscards = true;
              };
              content = {
                type = "lvm_pv";
                vg = "nix_pool";
              };
            };
          };
        };
      };
    };
    lvm_vg.nix_pool = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = ["compress=zstd" "noatime"];
              };
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
        swap = mkIf (cfg.swapSize != null) {
          size = "${toString cfg.swapSize}G";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };
      };
    };
  };
}
