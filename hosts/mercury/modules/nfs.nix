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
  networking.firewall.allowedTCPPorts = [2049];
  services.nfs.server = {
    enable = true;
    exports = ''
      /var/lib/nfs/kkts 192.168.1.0/24(insecure,root_squash,rw)
    '';
  };
}
