_: {
  fileSystems = {
    "/mnt/data" = {
      device = "/dev/disk/by-uuid/82bf5108-efa6-4493-a286-6d8f9b45649b";
      options = ["compress=zstd:9" "noatime" "nofail"];
    };
    "/mnt/lexar" = {
      device = "/dev/disk/by-uuid/5e915111-3162-4d2d-be37-4e8b6e6e6a3f";
      options = ["compress=zstd" "noatime" "nofail"];
    };
    "/mnt/nas" = {
      device = "192.168.1.69:/kkts";
      fsType = "nfs";
      options = [
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=900"
      ];
    };
  };
}
