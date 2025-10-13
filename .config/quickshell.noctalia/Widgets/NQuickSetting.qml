import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import qs.Commons
import qs.Services

Rectangle {
  id: root

  // Public properties
  property string text: ""
  property string icon: ""
  property string tooltipText: ""
  property bool enabled: true
  property bool hot: false
  property string style: "modern" // "modern", "classic", or "compact"

  // Styling properties
  property real fontSize: (style === "classic") ? Style.fontSizeXS * scaling : Style.fontSizeS * scaling
  property int fontWeight: Style.fontWeightMedium
  property real iconSize: Style.fontSizeL * scaling
  property real cornerRadius: Style.radiusM * scaling

  // Internal properties
  property bool hovered: false
  property bool pressed: false

  // Colors - Style-dependent colors
  property color backgroundColor: {
    if (pressed) {
      return Color.mTertiary
    }
    if (hot) {
      return Color.mPrimary
    }
    if (style === "classic")
      return Color.mSurfaceVariant
    if (style === "compact")
      return Color.mSurface
    return Color.mSurface
  }
  property color textColor: {
    if (pressed) {
      return Color.mOnTertiary
    }
    if (hot) {
      return Color.mOnPrimary
    }
    return Color.mOnSurface
  }
  property color iconColor: {
    if (pressed) {
      return Color.mOnTertiary
    }
    if (hot) {
      return Color.mOnPrimary
    }
    if (style !== "compact")
      return Color.mPrimary
    return Color.mOnSurface
  }
  property color borderColor: Color.mOutline
  property color hoverColor: Color.mTertiary
  property color hoverTextColor: Color.mOnTertiary
  property color hoverIconColor: Color.mOnTertiary

  // Signals
  signal clicked
  signal rightClicked
  signal middleClicked

  // Dimensions - Style-dependent sizing
  implicitWidth: {
    if (style === "classic") {
      return Style.baseWidgetSize * scaling
    }
    if (style === "compact") {
      return Style.baseWidgetSize * 0.8 * scaling
    }
    return Math.max(120 * scaling, contentRow.implicitWidth + (Style.marginL * scaling))
  }
  implicitHeight: {
    if (style === "classic") {
      return Style.baseWidgetSize * scaling
    }
    if (style === "compact") {
      return Style.baseWidgetSize * 0.8 * scaling
    }
    return Math.max(48 * scaling, contentRow.implicitHeight + (Style.marginL * scaling))
  }

  // Appearance - Style-dependent styling
  radius: {
    if (style === "classic")
      return width * 0.5
    if (style === "compact")
      return Style.radiusS * scaling // Smaller radius for compact
    return cornerRadius
  }
  color: {
    if (!enabled)
      return Qt.lighter(Color.mSurface, 1.1)
    if (hovered)
      return hoverColor
    return backgroundColor
  }

  border.width: {
    if (style === "classic")
      return Math.max(1, Style.borderS * scaling)
    if (style === "compact")
      return 0
    return 0
  }
  border.color: {
    if (style === "classic")
      return borderColor
    return "transparent"
  }

  opacity: enabled ? (style === "classic" ? Style.opacityFull : 1.0) : (style === "classic" ? Style.opacityMedium : 0.6)

  Behavior on color {
    ColorAnimation {
      duration: Style.animationFast
      easing.type: style === "classic" ? Easing.InOutQuad : Easing.OutCubic
    }
  }

  Behavior on border.color {
    ColorAnimation {
      duration: Style.animationFast
      easing.type: style === "classic" ? Easing.InOutQuad : Easing.OutCubic
    }
  }

  Behavior on scale {
    NumberAnimation {
      duration: Style.animationFast
      easing.type: Easing.OutCubic
    }
  }

  // Modern style - icon above text
  ColumnLayout {
    id: contentRow
    anchors.centerIn: parent
    spacing: Style.marginXXS * scaling
    visible: root.style !== "classic" && root.style !== "compact"

    // Icon
    NIcon {
      Layout.alignment: Qt.AlignHCenter
      visible: root.icon !== ""
      icon: root.icon
      pointSize: root.iconSize
      color: {
        if (!root.enabled)
          return Color.mOnSurfaceVariant
        if (root.hovered)
          return root.hoverIconColor
        return root.iconColor
      }

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
          easing.type: Easing.OutCubic
        }
      }
    }

    // Modern - Text content
    NText {
      Layout.alignment: Qt.AlignHCenter
      visible: root.text !== ""
      text: root.text
      pointSize: root.fontSize
      font.weight: root.fontWeight
      color: {
        if (!root.enabled)
          return Color.mOnSurfaceVariant
        if (root.hovered)
          return root.hoverTextColor
        return root.textColor
      }
      elide: Text.ElideRight

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
          easing.type: Easing.OutCubic
        }
      }
    }
  }

  // Compact style - icon only, small square button
  NIcon {
    id: compactIcon
    anchors.centerIn: parent
    visible: root.style === "compact" && root.icon !== ""
    icon: root.icon
    pointSize: Style.fontSizeM * scaling // Smaller icon for compact
    color: {
      if (!root.enabled)
        return Color.mOnSurfaceVariant
      if (root.hovered)
        return root.hoverIconColor
      return root.iconColor
    }

    Behavior on color {
      ColorAnimation {
        duration: Style.animationFast
        easing.type: Easing.OutCubic
      }
    }
  }

  // Classic style - EXACTLY like NIconButton (icon + text)
  RowLayout {
    anchors.centerIn: parent
    visible: root.style === "classic"
    spacing: Style.marginXS * scaling

    NIcon {
      visible: root.icon !== ""
      icon: root.icon
      pointSize: Style.fontSizeM * scaling
      color: {
        if (!root.enabled)
          return Color.mOnSurfaceVariant
        if (root.hovered)
          return root.hoverIconColor
        return root.iconColor
      }

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
          easing.type: Easing.OutCubic
        }
      }
    }

    // Classic - Text content
    NText {
      visible: root.text !== ""
      text: root.text
      pointSize: root.fontSize
      font.weight: root.fontWeight
      color: {
        if (!root.enabled)
          return Color.mOnSurfaceVariant
        if (root.hovered)
          return root.hoverTextColor
        return root.textColor
      }

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
          easing.type: Easing.OutCubic
        }
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    enabled: root.enabled
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

    onEntered: {
      root.hovered = true
      if (tooltipText) {
        TooltipService.show(Screen, root, root.tooltipText)
      }
    }

    onExited: {
      root.hovered = false
      if (tooltipText) {
        TooltipService.hide()
      }
    }

    onPressed: mouse => {
                 root.pressed = true
                 root.scale = 0.92
                 if (tooltipText) {
                   TooltipService.hide()
                 }
               }

    onReleased: mouse => {
                  root.scale = 1.0
                  root.pressed = false

                  // Only trigger actions if released while hovering
                  if (root.hovered) {
                    if (mouse.button === Qt.LeftButton) {
                      root.clicked()
                    } else if (mouse.button === Qt.RightButton) {
                      root.rightClicked()
                    } else if (mouse.button === Qt.MiddleButton) {
                      root.middleClicked()
                    }
                  }
                }

    onCanceled: {
      root.hovered = false
      root.pressed = false
      root.scale = 1.0
      if (tooltipText) {
        TooltipService.hide()
      }
    }
  }
}
