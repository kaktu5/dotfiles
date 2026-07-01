pragma Singleton

import QtQuick

QtObject {
  // final readonly property string monitor: "HDMI-A-1"
  final readonly property string monitor: "eDP-1"

  final readonly property QtObject colors: QtObject {
    final readonly property color bg0: "#0a0a0a"
    final readonly property color bg1: "#0d0d0d"
    final readonly property color bg2: "#111111"
    final readonly property color bg3: "#181818"

    final readonly property color fg0: "#e9e4e4"
    final readonly property color fg1: "#404040"

    final readonly property color red: "#b86467"
    final readonly property color green: "#8d987e"
    final readonly property color yellow: "#dabd8d"
    final readonly property color blue: "#8ea5ba"
    final readonly property color purple: "#ab89b2"
    final readonly property color cyan: "#8ba8a4"
  }

  final readonly property QtObject fonts: QtObject {
    final readonly property int large: 16
    final readonly property int medium: 14
    final readonly property int small: 12
  }
}
