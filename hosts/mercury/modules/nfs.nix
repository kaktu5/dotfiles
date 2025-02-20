_: {
  fileSystems = {
    "/mnt/data" = {
      device = "/dev/disk/by-id/ata-ST500LT012-1DG142_S3P8SKZ7-part1";
      options = ["compress=zstd:9" "noatime" "nofail"];
    };
    "/export/kkts" = {
      device = "/mnt/data";
      options = ["bind"];
    };
  };
  networking.firewall.allowedTCPPorts = [2049];
  services.nfs.server = {
    enable = true;
    exports = ''
      /export      192.168.1.100(rw,fsid=0,no_subtree_check)
      /export/kkts 192.168.1.100(rw,nohide,insecure,no_subtree_check)
    '';
  };
}
