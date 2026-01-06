{lib, ...}: let
  inherit (lib.lists) singleton;
in {
  boot.kernel.sysctl = {
    "fs.suid_dumpable" = 0;
    "kernel.core_pattern" = "/dev/null";
  };

  security.pam.loginLimits = singleton {
    domain = "*";
    item = "core";
    type = "hard";
    value = 0;
  };

  systemd.coredump.extraConfig = ''
    ProcessSizeMax=0
    Storage=none
  '';
}
