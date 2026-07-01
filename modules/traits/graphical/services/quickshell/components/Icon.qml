import QtQuick
import qs

Text {
  id: root

  property bool filled: false
  property int grade: 0
  property string name: ""
  property real size: 24
  property int weight: 400

  color: Config.colors.fg0
  horizontalAlignment: Text.AlignHCenter
  text: name
  verticalAlignment: Text.AlignVCenter

  font {
    family: "Material Symbols Sharp"
    pixelSize: root.size
    variableAxes: ({
                     "FILL": root.filled ? 1 : 0,
                     "GRAD": root.grade,
                     "opsz": Math.max(20, Math.min(48, root.size)),
                     "wght": root.weight
                   })
  }
}
