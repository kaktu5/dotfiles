{
  boot = {
    zfs.devNodes = "/dev/disk/by-partuuid";

    extraModprobeConfig = ''
      options zfs zfs_arc_max=${1 * 1024 * 1024 * 1024}
      options zfs zfs_arc_shrinker_seeks=1
      options zfs zfs_arc_sys_free=${1 * 1024 * 1024 * 1024}
    '';
  };
}
