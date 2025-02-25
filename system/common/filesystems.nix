/*
{lib, ...}: let
  inherit (lib) mkDefault;
in {
  fileSystems = {
    "/boot".options = ["nodev" "noexec" "nosuid"];
    "/etc" = {
      device = mkDefault "/etc";
      options = ["bind" "nodev" "nosuid"];
    };
    "/home" = {
      device = mkDefault "/home";
      options = ["bind" "nodev" "nosuid"];
    };
    "/root" = {
      device = mkDefault "/root";
      options = ["bind" "nodev" "noexec" "nosuid"];
    };
    "/srv" = {
      device = mkDefault "/srv";
      options = ["bind" "nodev" "noexec" "nosuid"];
    };
    "/tmp" = {
      device = mkDefault "/tmp";
      options = ["bind" "nodev" "noexec" "nosuid"];
    };
    "/var" = {
      device = mkDefault "/var";
      options = ["bind" "nodev" "noexec" "nosuid"];
    };
    "/var/lib" = {
      device = mkDefault "/var/lib";
      options = ["bind" "exec"];
    };
  };
*/
_: {
  boot = {
    tmp.useTmpfs = true;
    specialFileSystems = {
      "/dev".options = ["noexec"];
      "/dev/shm".options = ["noexec"];
      "/run".options = ["noexec"];
    };
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
}
