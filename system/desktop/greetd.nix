{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (lib) getExe;
in {
  environment.persistence."/persist/root".directories = ["/var/cache/tuigreet"];
  systemd.tmpfiles.rules = ["d /var/cache/tuigreet 0755 ${username} users - -"];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${getExe pkgs.greetd.tuigreet} -w 48 -t -r";
      };
    };
  };
}
