import QtQuick
import Quickshell

import qs
import qs.components

Rectangle {
  color: Config.colors.bg1
  implicitHeight: content.height
  implicitWidth: 28

  Column {
    id: content

    anchors.centerIn: parent
    spacing: 2

    SystemClock {
      id: sysClock

      precision: SystemClock.Minutes
    }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: Qt.formatDateTime(sysClock.date, "HH")
    }

    Item {
      anchors.horizontalCenter: parent.horizontalCenter
      height: 1
      width: 1

      Text {
        anchors.centerIn: parent
        rotation: 90
        text: "⁚"
      }
    }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: Qt.formatDateTime(sysClock.date, "mm")
    }
  }
}
