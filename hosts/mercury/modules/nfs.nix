_: {
  fileSystems = {
    "/mnt/data" = {
      device = "/dev/disk/by-id/ata-ST500LT012-1DG142_S3P8SKZ7-part1";
      options = ["compress=zstd:9" "noatime" "nofail"];
    };
    "/var/lib/nfs/kkts" = {
      device = "/mnt/data/kkts";
      options = ["bind"];
    };
  };
  services.nfs.server = {
    enable = true;
    exports = ''
      /var/lib/nfs/kkts 127.0.0.1(insecure,root_squash,rw)
    '';
  };
}
