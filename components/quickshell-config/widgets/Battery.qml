import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs
import qs.components

ColumnLayout {
  id: root

  // handle PendingCharge and FullyCharged
  readonly property bool charging: device.state === UPowerDeviceState.Charging
  readonly property var device: UPower.displayDevice
  readonly property real fraction: device.percentage
  // readonly property real fraction: 1.0
  readonly property bool full: fraction >= 0.95
  readonly property string iconName: {
    const t = [[0.95, "full"], [0.80, "80"], [0.60, "60"], [0.50, "50"], [0.30, "30"]];
    const suffix = t.find(([f]) => fraction >= f)?.[1] ?? "20";
    return charging ? "battery_charging_" + suffix + "_2" : "battery_" + suffix;
  }
  readonly property color tint: fraction <= 0.15 && !charging ? Config.colors.red : Config.colors.fg0

  spacing: 4
  visible: device.isPresent

  Icon {
    Layout.alignment: Qt.AlignHCenter
    color: root.tint
    filled: root.full
    name: root.iconName
    rotation: root.charging ? 0 : 90
  }

  Text {
    Layout.alignment: Qt.AlignHCenter
    color: root.tint
    font.pixelSize: 14
    text: Math.round(root.fraction * 100) + "%"
  }
}
