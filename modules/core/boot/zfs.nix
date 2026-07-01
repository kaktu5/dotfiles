{
  boot = {
    zfs.devNodes = "/dev/disk/by-partuuid";

    extraModprobeConfig = "options zfs zfs_arc_sys_free=${2 * 1024 * 1024 * 1024}";
  };
}
