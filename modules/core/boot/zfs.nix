{
  boot.zfs = {
    devNodes = "/dev/disk/by-partuuid";

    forceImportRoot = false; # TODO: remove after 26.11 releases
  };
}
