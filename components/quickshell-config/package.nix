{
  lib,
  symlinkJoin,
  writeTextDir,
  monitors,
  theme,
}: let
  inherit (lib.fileset) toSource unions;
  inherit (monitors) primaryMonitor;
  inherit (theme.colors) hex';
  inherit (theme.fonts.sizes) pt;

  srcDir = toSource {
    root = ./.;
    fileset = unions [
      ./Bar.qml
      ./Osd.qml
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
in
  symlinkJoin {
    name = "quickshell-config";
    paths = [srcDir configFile];
  }
