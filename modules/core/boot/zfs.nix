{
  boot.zfs = {
    devNodes = "/dev/disk/by-partuuid";
    forceImportRoot = false; # remove after 26.11 releases
  };
}
