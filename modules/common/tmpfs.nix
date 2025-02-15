_: {
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    # broken
    environment.TMPDIR = "/var/tmp";
  };
  # environment.sessionVariables.TMPDIR = "/var/tmp";
}
