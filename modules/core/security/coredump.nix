{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe';
  inherit (pkgs) uutils-coreutils-noprefix;
in {
  boot.kernel.sysctl = {
    "fs.suid_dumpable" = 0;
    "kernel.core_pattern" = "|${getExe' uutils-coreutils-noprefix "false"}";
  };

  security.pam.loginLimits = singleton {
    domain = "*";
    item = "core";
    type = "hard";
    value = 0;
  };

  systemd.coredump.enable = false;
}
