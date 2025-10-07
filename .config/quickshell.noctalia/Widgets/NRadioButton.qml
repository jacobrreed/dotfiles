import QtQuick
import QtQuick.Controls
import qs.Commons
import qs.Services
import qs.Widgets

RadioButton {
  id: root

  indicator: Rectangle {
    id: outerCircle

    implicitWidth: Style.baseWidgetSize * 0.625 * scaling
    implicitHeight: Style.baseWidgetSize * 0.625 * scaling
    radius: width * 0.5
    color: Color.transparent
    border.color: root.checked ? Color.mPrimary : Color.mOnSurface
    border.width: Math.max(1, Style.borderM * scaling)
    anchors.verticalCenter: parent.verticalCenter

    Rectangle {
      anchors.fill: parent
      anchors.margins: parent.width * 0.3

      radius: width * 0.5
      color: Qt.alpha(Color.mPrimary, root.checked ? 1 : 0)

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
        }
      }
    }

    Behavior on border.color {
      ColorAnimation {
        duration: Style.animationFast
      }
    }
  }

  contentItem: NText {
    text: root.text
    pointSize: Style.fontSizeM * scaling
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: outerCircle.right
    anchors.right: parent.right
    anchors.leftMargin: Style.marginS * scaling
  }
}
