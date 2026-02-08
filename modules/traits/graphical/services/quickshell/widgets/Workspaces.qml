import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs
import qs.components

Rectangle {
  readonly property real cellH: 16
  readonly property real cellW: 22
  readonly property real sx: cellW / hlMonitor.width
  readonly property real sy: cellH / hlMonitor.height

  color: Config.colors.bg1
  implicitHeight: content.height
  implicitWidth: 28

  Component.onCompleted: Hyprland.refreshToplevels()

  Column {
    id: content

    anchors.horizontalCenter: parent.horizontalCenter
    bottomPadding: 4
    spacing: 4
    topPadding: 4

    Repeater {
      model: 8

      delegate: Item {
        id: wsDelegate

        readonly property bool isActive: ws !== null && ws.monitor === hlMonitor && ws.active
        required property int modelData
        readonly property var ws: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
        readonly property int wsId: modelData + 1

        implicitHeight: cellH
        implicitWidth: cellW

        Rectangle {
          anchors.fill: parent
          color: wsDelegate.isActive ? Config.colors.bg2 : Config.colors.bg0
          radius: 1
        }

        Repeater {
          model: wsDelegate.ws ? wsDelegate.ws.toplevels : null

          delegate: Rectangle {
            readonly property var ipc: tl.lastIpcObject
            required property var modelData
            readonly property var tl: modelData

            color: (tl === Hyprland.activeToplevel && wsDelegate.isActive) ? Config.colors.cyan : (wsDelegate.isActive
                                                                                                   ? Config.colors.fg0 :
                                                                                                     Config.colors.fg1)
            height: Math.max(1, (ipc?.size?.[1] ?? hlMonitor.height) * sy - 0.8)
            width: Math.max(1, (ipc?.size?.[0] ?? hlMonitor.width) * sx - 0.8)
            x: Math.max(0, ((ipc?.at?.[0] ?? 0) - hlMonitor.x) * sx)
            y: Math.max(0, ((ipc?.at?.[1] ?? 0) - hlMonitor.y) * sy)

            Behavior on height {
              NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
              }
            }
            Behavior on width {
              NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
              }
            }
            Behavior on x {
              NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
              }
            }
            Behavior on y {
              NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
              }
            }
          }
        }

        MouseArea {
          anchors.fill: parent

          onClicked: Hyprland.dispatch("workspace " + wsDelegate.wsId)
        }
      }
    }
  }

  Connections {
    function onRawEvent(event) {
      const needsRefresh = ["openwindow", "closewindow", "movewindow", "resizewindow", "activeworkspace", "activewindow",
                            "movewindowv2"];
      if (needsRefresh.includes(event.name))
        Hyprland.refreshToplevels();
    }

    target: Hyprland
  }
}
