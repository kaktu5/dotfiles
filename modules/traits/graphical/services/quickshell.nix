{
  config,
  flake,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.meta) getExe;
  inherit (pkgs) callPackage quickshell;

  quickshellConfig = callPackage (flake + /components/quickshell-config/package.nix) {
    inherit (config.kkts) theme;
    inherit (config.kkts.hardware) monitors;
  };
in {
  persistence.users.${userName}.directories = [".local/cache/quickshell"];

  hjem.users.${userName}.systemd.services.quickshell = mkGraphicalTargetService {
    environment = {
      QS_CONFIG_PATH = quickshellConfig;
      QS_DISABLE_FILE_WATCHER = "1";
      QS_NO_RELOAD_POPUP = "1";
    };

    serviceConfig = {
      ExecStart = getExe quickshell;
      Slice = "graphical.slice";
    };
  };
}
