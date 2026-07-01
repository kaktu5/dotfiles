import QtQuick
import Quickshell.Services.UPower

import qs
import qs.components

Rectangle {
  color: Config.colors.bg1
  implicitHeight: label.height
  implicitWidth: 28

  Text {
    id: label

    anchors.centerIn: parent
    text: Math.round(UPower.displayDevice.percentage * 100)
  }
}
