import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Commons
import qs.Services
import qs.Widgets

PopupWindow {
  id: root

  property var toplevel: null
  property Item anchorItem: null
  property real scaling: 1.0
  property bool hovered: menuMouseArea.containsMouse
  property var onAppClosed: null // Callback function for when an app is closed

  // Track which menu item is hovered
  property int hoveredItem: -1 // -1: none, 0: focus, 1: pin, 2: close

  signal requestClose

  implicitWidth: 140 * scaling
  implicitHeight: contextMenuColumn.implicitHeight + (Style.marginM * scaling * 2)
  color: Color.transparent
  visible: false

  // Helper functions for pin/unpin functionality
  function isAppPinned(appId) {
    if (!appId)
      return false
    const pinnedApps = Settings.data.dock.pinnedApps || []
    return pinnedApps.includes(appId)
  }

  function toggleAppPin(appId) {
    if (!appId)
      return

    let pinnedApps = (Settings.data.dock.pinnedApps || []).slice() // Create a copy
    const isPinned = pinnedApps.includes(appId)

    if (isPinned) {
      // Unpin: remove from array
      pinnedApps = pinnedApps.filter(id => id !== appId)
    } else {
      // Pin: add to array
      pinnedApps.push(appId)
    }

    // Update the settings
    Settings.data.dock.pinnedApps = pinnedApps
  }

  anchor.item: anchorItem
  anchor.rect.x: anchorItem ? (anchorItem.width - implicitWidth) / 2 : 0
  anchor.rect.y: anchorItem ? -implicitHeight - (Style.marginM * scaling) : 0

  function show(item, toplevelData) {
    if (!item) {
      Logger.warn("DockMenu", "anchorItem is undefined, won't show menu.")
      return
    }

    anchorItem = item
    toplevel = toplevelData
    visible = true
  }

  function hide() {
    visible = false
  }

  // Helper function to determine which menu item is under the mouse
  function getHoveredItem(mouseY) {
    const itemHeight = 32 * scaling
    const startY = Style.marginM * scaling
    const relativeY = mouseY - startY

    if (relativeY < 0)
      return -1

    const itemIndex = Math.floor(relativeY / itemHeight)
    return itemIndex >= 0 && itemIndex < 3 ? itemIndex : -1
  }

  // Handle menu item clicks
  function handleItemClick(itemIndex) {
    switch (itemIndex) {
    case 0:
      // Focus
      if (root.toplevel?.activate) {
        root.toplevel.activate()
      }
      root.requestClose()
      break
    case 1:
      // Pin/Unpin
      if (root.toplevel?.appId) {
        root.toggleAppPin(root.toplevel.appId)
      }
      root.requestClose()
      break
    case 2:
      // Close
      // Check if toplevel is still valid before trying to close it
      const isValidToplevel = root.toplevel && ToplevelManager && ToplevelManager.toplevels.values.includes(root.toplevel)

      if (isValidToplevel && root.toplevel.close) {
        root.toplevel.close()
        // Trigger immediate dock update callback if provided
        if (root.onAppClosed && typeof root.onAppClosed === "function") {
          Qt.callLater(root.onAppClosed)
        }
      } else {
        Logger.warn("DockMenu", "Cannot close app - invalid toplevel reference")
      }
      root.hide()
      root.requestClose()
      break
    }
  }

  Timer {
    id: closeTimer
    interval: 500
    repeat: false
    running: false
    onTriggered: {
      root.hide()
    }
  }

  Rectangle {
    anchors.fill: parent
    color: Color.mSurfaceVariant
    radius: Style.radiusS * scaling
    border.color: Color.mOutline
    border.width: Math.max(1, Style.borderS * scaling)

    // Single MouseArea to handle both auto-close and menu interactions
    MouseArea {
      id: menuMouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: root.hoveredItem >= 0 ? Qt.PointingHandCursor : Qt.ArrowCursor

      onEntered: {
        closeTimer.stop()
      }

      onExited: {
        root.hoveredItem = -1
        closeTimer.start()
      }

      onPositionChanged: mouse => {
                           root.hoveredItem = root.getHoveredItem(mouse.y)
                         }

      onClicked: mouse => {
                   const clickedItem = root.getHoveredItem(mouse.y)
                   if (clickedItem >= 0) {
                     root.handleItemClick(clickedItem)
                   }
                 }
    }

    ColumnLayout {
      id: contextMenuColumn
      anchors.fill: parent
      anchors.margins: Style.marginM * scaling
      spacing: 0

      // Focus item
      Rectangle {
        Layout.fillWidth: true
        height: 32 * scaling
        color: root.hoveredItem === 0 ? Color.mTertiary : Color.transparent
        radius: Style.radiusXS * scaling

        RowLayout {
          anchors.left: parent.left
          anchors.leftMargin: Style.marginS * scaling
          anchors.verticalCenter: parent.verticalCenter
          spacing: Style.marginS * scaling

          NIcon {
            icon: "eye"
            pointSize: Style.fontSizeL * scaling
            color: root.hoveredItem === 0 ? Color.mOnTertiary : Color.mOnSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
          }

          NText {
            text: I18n.tr("dock.menu.focus")
            pointSize: Style.fontSizeS * scaling
            color: root.hoveredItem === 0 ? Color.mOnTertiary : Color.mOnSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
          }
        }
      }

      // Pin/Unpin item
      Rectangle {
        Layout.fillWidth: true
        height: 32 * scaling
        color: root.hoveredItem === 1 ? Color.mTertiary : Color.transparent
        radius: Style.radiusXS * scaling

        RowLayout {
          anchors.left: parent.left
          anchors.leftMargin: Style.marginS * scaling
          anchors.verticalCenter: parent.verticalCenter
          spacing: Style.marginS * scaling

          NIcon {
            icon: {
              if (!root.toplevel)
                return "pin"
              return root.isAppPinned(root.toplevel.appId) ? "unpin" : "pin"
            }
            pointSize: Style.fontSizeL * scaling
            color: root.hoveredItem === 1 ? Color.mOnTertiary : Color.mOnSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
          }

          NText {
            text: {
              if (!root.toplevel)
                return I18n.tr("dock.menu.pin")
              return root.isAppPinned(root.toplevel.appId) ? I18n.tr("dock.menu.unpin") : I18n.tr("dock.menu.pin")
            }
            pointSize: Style.fontSizeS * scaling
            color: root.hoveredItem === 1 ? Color.mOnTertiary : Color.mOnSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
          }
        }
      }

      // Close item
      Rectangle {
        Layout.fillWidth: true
        height: 32 * scaling
        color: root.hoveredItem === 2 ? Color.mTertiary : Color.transparent
        radius: Style.radiusXS * scaling

        RowLayout {
          anchors.left: parent.left
          anchors.leftMargin: Style.marginS * scaling
          anchors.verticalCenter: parent.verticalCenter
          spacing: Style.marginS * scaling

          NIcon {
            icon: "close"
            pointSize: Style.fontSizeL * scaling
            color: root.hoveredItem === 2 ? Color.mOnTertiary : Color.mOnSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
          }

          NText {
            text: I18n.tr("dock.menu.close")
            pointSize: Style.fontSizeS * scaling
            color: root.hoveredItem === 2 ? Color.mOnTertiary : Color.mOnSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
          }
        }
      }
    }
  }
}
