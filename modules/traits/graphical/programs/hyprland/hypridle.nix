{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) systemd;
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.generators) toHyprlang;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.meta) getExe getExe';
  inherit (pkgs) hypridle swaylock;

  loginctl = getExe' systemd.package "loginctl";
  systemctl = getExe' systemd.package "systemctl";
in {
  hjem.users.${userName} = {
    systemd.services.hypridle = mkGraphicalTargetService {
      serviceConfig = {
        Slice = "background.slice";
        ExecStart = getExe hypridle;
      };
    };

    xdg.config.files."hypr/hypridle.conf" = {
      generator = toHyprlang {};
      value = {
        general = {
          lock_cmd = "${getExe swaylock} -c 000000";
          before_sleep_cmd = "${loginctl} lock-session";
        };

        listener = [
          {
            timeout = 5 * 60;
            on-timeout = "${loginctl} lock-session";
          }
          {
            timeout = 15 * 60;
            on-timeout = "${systemctl} suspend";
          }
        ];
      };
    };
  };
}
