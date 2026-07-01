import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs
import qs.components

Scope {
  id: root

  property string currentKey: ""
  property string message: ""
  property var queue: []
  property bool shown: false

  function advance() {
    const next = queue.shift();
    if (!next) {
      shown = false;
      currentKey = "";
      return;
    }
    message = next.text;
    currentKey = next.key;
    shown = true;
    hideTimer.restart();
  }

  function push(key, text) {
    if (shown && currentKey === key) {
      message = text;
      hideTimer.restart();
      return;
    }

    const pending = queue.find(e => e.key === key);
    if (pending) {
      pending.text = text;
      return;
    }
    queue.push({
                 key: key,
                 text: text
               });
    if (!shown)
      advance();
  }

  IpcHandler {
    function show(key: string, text: string): void {
      root.push(key, text);
    }

    target: "osd"
  }

  Timer {
    id: hideTimer

    interval: 2000

    onTriggered: root.advance()
  }

  PanelWindow {
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "osd"
    anchors.bottom: true
    color: "transparent"
    exclusiveZone: 0
    implicitHeight: card.height
    implicitWidth: card.width
    margins.bottom: 120
    visible: card.opacity > 0

    mask: Region {
    }

    Rectangle {
      id: card

      border.color: Config.colors.bg2
      color: Config.colors.bg0
      height: label.implicitHeight + 24
      opacity: root.shown ? 1 : 0
      width: label.implicitWidth + 24

      Behavior on opacity {
        NumberAnimation {
          duration: 150
        }
      }

      Text {
        id: label

        anchors.centerIn: parent
        text: root.message
      }
    }
  }
}
