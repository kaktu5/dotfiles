import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.components
import qs.widgets

PanelWindow {
  readonly property var hlMonitor: Hyprland.monitorFor(monitor)
  readonly property var monitor: Quickshell.screens.find(s => s.name === Config.monitor)

  color: Config.colors.bg0
  implicitWidth: 32

  anchors {
    bottom: true
    left: true
    top: true
  }

  BarLayout {
    middleSection: []

    bottomSection: [
      Clock {
      }
    ]
    topSection: [
      Workspaces {
      }
    ]
  }
}
