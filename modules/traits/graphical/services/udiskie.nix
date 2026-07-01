{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.meta) getExe;
  inherit (pkgs) udiskie;
  inherit (pkgs.writers) writeNuBin writeYAML;

  udiskieEventHandler = writeNuBin "udiskie-event-handler" ''
    def main [event: string, mount_path?: string] {
      if ($event != "device_mounted") or ($mount_path | is-empty) {
        return
      }
      let svi = ($mount_path | path join "System Volume Information")
      if ($svi | path exists) {
        rm --permanent --recursive --force $svi
      }
    }
  '';

  configFile = writeYAML "udiskie-config.yml" {
    program_options = {
      automount = true;
      event_hook = [(getExe udiskieEventHandler) "{event}" "{mount_path}"];
    };
  };
in {
  hjem.users.${userName}.systemd.services.udiskie = mkGraphicalTargetService {
    serviceConfig.ExecStart = "${getExe udiskie} --config ${configFile}";
  };
}
