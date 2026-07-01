{
  config,
  pkgs,
}: let
  withResolved = config.services.resolved.enable || config.boot.initrd.services.resolved.enable;
  withTimesyncd = config.services.timesyncd.enable;
in
  (pkgs.systemd.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./dont-check-usr-populated.patch ./remove-tmpfiles-d-home-conf.patch];
    postInstall = (old.postInstall or "") + "rm $out/bin/{halt,init,poweroff,reboot,shutdown}";
  })).override {
    withCoredump = false;
    withHomed = false;
    withHostnamed = false;
    withImportd = false;
    withLocaled = false;
    withPasswordQuality = false;
    withPortabled = false;
    withRemote = false;
    inherit withResolved;
    withSysupdate = false;
    withTimedated = false;
    inherit withTimesyncd;
    withUserDb = false;
    withNss = withResolved;
    withKexectools = false;
  }
