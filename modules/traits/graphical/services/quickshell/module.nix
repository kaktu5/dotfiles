{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.hardware.monitors) primaryMonitor;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.colors) hex';
  inherit (config.kkts.theme.fonts.sizes) pt;
  inherit (lib.fileset) toSource unions;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.meta) getExe;
  inherit (pkgs) quickshell symlinkJoin writeTextDir;

  srcDir = toSource {
    root = ./.;
    fileset = unions [
      ./Bar.qml
      ./components
      ./shell.qml
      ./widgets
    ];
  };

  configFile = writeTextDir "Config.qml" ''
    pragma Singleton

    import QtQuick

    QtObject {
      final readonly property string monitor: "${primaryMonitor}"

      final readonly property QtObject colors: QtObject {
        final readonly property color bg0: "${hex'.bg0}"
        final readonly property color bg1: "${hex'.bg1}"
        final readonly property color bg2: "${hex'.bg2}"
        final readonly property color bg3: "${hex'.bg3}"

        final readonly property color fg0: "${hex'.fg0}"
        final readonly property color fg1: "${hex'.fg1}"

        final readonly property color red: "${hex'.red}"
        final readonly property color green: "${hex'.green}"
        final readonly property color yellow: "${hex'.yellow}"
        final readonly property color blue: "${hex'.blue}"
        final readonly property color purple: "${hex'.purple}"
        final readonly property color cyan: "${hex'.cyan}"
      }

      final readonly property QtObject fonts: QtObject {
        final readonly property int large: ${pt.large}
        final readonly property int medium: ${pt.medium}
        final readonly property int small: ${pt.small}
      }
    }
  '';

  configDir = symlinkJoin {
    name = "kkts-shell-config-dir";
    paths = [srcDir configFile];
  };
in {
  persistence.users.${userName}.directories = [".local/cache/quickshell"];

  hjem.users.${userName}.systemd.services.kkts-shell = mkGraphicalTargetService {
    environment = {
      QS_CONFIG_PATH = configDir;
      QS_DISABLE_FILE_WATCHER = "1";
      QS_NO_RELOAD_POPUP = "1";
    };

    serviceConfig = {
      ExecStart = getExe quickshell;
      Slice = "graphical.slice";
    };
  };
}
