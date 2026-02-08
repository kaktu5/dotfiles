import QtQuick

Item {
  id: root

  property alias bottomSection: bottomSection.data
  property int margin: 8
  property alias middleSection: middleSection.data
  property int spacing: 12
  property alias topSection: topSection.data

  anchors.fill: parent

  Column {
    id: topSection

    anchors {
      horizontalCenter: parent.horizontalCenter
      top: parent.top
      topMargin: root.margin
    }
  }

  Column {
    id: middleSection

    anchors.centerIn: parent
    spacing: root.spacing
  }

  Column {
    id: bottomSection

    spacing: root.spacing

    anchors {
      bottom: parent.bottom
      bottomMargin: root.margin
      horizontalCenter: parent.horizontalCenter
    }
  }
}
