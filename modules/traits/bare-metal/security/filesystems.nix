{config, ...}: let
  inherit (config.ids) gids;
  inherit (config.users) groups;
in {
  boot.specialFileSystems = {
    "/dev/shm".options = ["noexec"];

    "/run".options = ["noexec"];

    "/dev".options = ["noexec"];

    # hide processes from other users except root, may cause breakage
    "/proc" = {
      device = "proc";
      options = ["gid=${groups.proc.gid}" "hidepid=2"];
    };
  };

  # add "proc" group to whitelist /proc access and allow systemd-logind and all
  # user session services to view /proc
  users.groups.proc.gid = gids.proc;
  systemd.services = {
    systemd-logind.serviceConfig.SupplementaryGroups = ["proc"];
    "user@".serviceConfig.SupplementaryGroups = ["proc"];
  };
}
