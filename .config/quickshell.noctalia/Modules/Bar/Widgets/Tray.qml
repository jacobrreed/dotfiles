import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services
import qs.Widgets

Rectangle {
  id: root

  property ShellScreen screen
  property real scaling: 1.0

  // Widget properties passed from Bar.qml for per-instance settings
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  property var widgetMetadata: BarWidgetRegistry.widgetMetadata[widgetId]
  property var widgetSettings: {
    if (section && sectionWidgetIndex >= 0) {
      var widgets = Settings.data.bar.widgets[section]
      if (widgets && sectionWidgetIndex < widgets.length) {
        return widgets[sectionWidgetIndex]
      }
    }
    return {}
  }

  readonly property string barPosition: Settings.data.bar.position
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"
  readonly property bool compact: (Settings.data.bar.density === "compact")
  property real itemSize: Math.round(Style.capsuleHeight * 0.65 * scaling)
  property list<string> blacklist: widgetSettings.blacklist || widgetMetadata.blacklist || [] // Read from settings
  property var filteredItems: []

  function wildCardMatch(str, rule) {
    if (!str || !rule) {
      return false
    }
    Logger.log("Tray", "wildCardMatch - Input str:", str, "rule:", rule)

    // Escape all special regex characters in the rule
    let escapedRule = rule.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
    // Convert '*' to '.*' for wildcard matching
    let pattern = escapedRule.replace(/\\\*/g, '.*')
    // Add ^ and $ to match the entire string
    pattern = '^' + pattern + '$'

    Logger.log("Tray", "wildCardMatch - Generated pattern:", pattern)

    try {
      const regex = new RegExp(pattern, 'i')
      // 'i' for case-insensitive
      Logger.log("Tray", "wildCardMatch - Regex test result:", regex.test(str))
      return regex.test(str)
    } catch (e) {
      Logger.warn("Tray", "Invalid regex pattern for wildcard match:", rule, e.message)
      return false // If regex is invalid, it won't match
    }
  }

  // Debounce timer for updateFilteredItems to prevent excessive calls
  // when multiple events (e.g., SystemTray changes, settings saves)
  // trigger it in rapid succession, reducing redundant processing.
  Timer {
    id: updateDebounceTimer
    interval: 100 // milliseconds
    running: false
    repeat: false
    onTriggered: _performFilteredItemsUpdate()
  }

  function _performFilteredItemsUpdate() {
    if (!root.blacklist || root.blacklist.length === 0) {
      if (SystemTray.items && SystemTray.items.values) {
        filteredItems = SystemTray.items.values
      } else {
        filteredItems = []
      }
      return
    }

    let newItems = []
    if (SystemTray.items && SystemTray.items.values) {
      const trayItems = SystemTray.items.values
      for (var i = 0; i < trayItems.length; i++) {
        const item = trayItems[i]
        if (!item) {
          continue
        }

        const title = item.tooltipTitle || item.name || item.id || ""

        let isBlacklisted = false
        for (var j = 0; j < root.blacklist.length; j++) {
          const rule = root.blacklist[j]
          if (wildCardMatch(title, rule)) {
            isBlacklisted = true
            break
          }
        }

        if (!isBlacklisted) {
          newItems.push(item)
        }
      }
    }
    filteredItems = newItems
  }

  function updateFilteredItems() {
    updateDebounceTimer.restart()
  }

  function onLoaded() {
    // When the widget is fully initialized with its props set the screen for the trayMenu
    if (trayMenu.item) {
      trayMenu.item.screen = screen
    }
  }

  Connections {
    target: SystemTray.items
    function onValuesChanged() {
      root.updateFilteredItems()
    }
  }

  Connections {
    target: Settings
    function onSettingsSaved() {
      root.updateFilteredItems()
    }
  }

  Component.onCompleted: {
    root.updateFilteredItems() // Initial update
  }

  visible: filteredItems.length > 0
  implicitWidth: isVertical ? Math.round(Style.capsuleHeight * scaling) : Math.round(trayFlow.implicitWidth + Style.marginM * 2 * scaling)
  implicitHeight: isVertical ? Math.round(trayFlow.implicitHeight + Style.marginM * 2 * scaling) : Math.round(Style.capsuleHeight * scaling)
  radius: Math.round(Style.radiusM * scaling)
  color: Settings.data.bar.showCapsule ? Color.mSurfaceVariant : Color.transparent

  Layout.alignment: Qt.AlignVCenter

  Flow {
    id: trayFlow
    anchors.centerIn: parent
    spacing: Style.marginM * scaling
    flow: isVertical ? Flow.TopToBottom : Flow.LeftToRight

    Repeater {
      id: repeater
      model: filteredItems

      delegate: Item {
        width: itemSize
        height: itemSize
        visible: modelData

        IconImage {
          id: trayIcon

          property ShellScreen screen: root.screen

          anchors.fill: parent
          asynchronous: true
          backer.fillMode: Image.PreserveAspectFit
          source: {
            let icon = modelData?.icon || ""
            if (!icon) {
              return ""
            }

            // Process icon path
            if (icon.includes("?path=")) {
              const chunks = icon.split("?path=")
              const name = chunks[0]
              const path = chunks[1]
              const fileName = name.substring(name.lastIndexOf("/") + 1)
              return `file://${path}/${fileName}`
            }
            return icon
          }
          opacity: status === Image.Ready ? 1 : 0

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: mouse => {
                         if (!modelData) {
                           return
                         }

                         if (mouse.button === Qt.LeftButton) {
                           // Close any open menu first
                           trayPanel.close()

                           if (!modelData.onlyMenu) {
                             modelData.activate()
                           }
                         } else if (mouse.button === Qt.MiddleButton) {
                           // Close any open menu first
                           trayPanel.close()

                           modelData.secondaryActivate && modelData.secondaryActivate()
                         } else if (mouse.button === Qt.RightButton) {
                           TooltipService.hideImmediately()

                           // Close the menu if it was visible
                           if (trayPanel && trayPanel.visible) {
                             trayPanel.close()
                             return
                           }

                           if (modelData.hasMenu && modelData.menu && trayMenu.item) {
                             trayPanel.open()

                             // Position menu based on bar position
                             let menuX, menuY
                             if (barPosition === "left") {
                               // For left bar: position menu to the right of the bar
                               menuX = width + Style.marginM * scaling
                               menuY = 0
                             } else if (barPosition === "right") {
                               // For right bar: position menu to the left of the bar
                               menuX = -trayMenu.item.width - Style.marginM * scaling
                               menuY = 0
                             } else {
                               // For horizontal bars: center horizontally and position below
                               menuX = (width / 2) - (trayMenu.item.width / 2)
                               menuY = Math.round(Style.barHeight * scaling)
                             }
                             trayMenu.item.menu = modelData.menu
                             trayMenu.item.showAt(parent, menuX, menuY)
                           } else {
                             Logger.log("Tray", "No menu available for", modelData.id, "or trayMenu not set")
                           }
                         }
                       }
            onEntered: {
              trayPanel.close()
              TooltipService.show(Screen, trayIcon, modelData.tooltipTitle || modelData.name || modelData.id || "Tray Item", BarService.getTooltipDirection())
            }
            onExited: TooltipService.hide()
          }
        }
      }
    }
  }

  PanelWindow {
    id: trayPanel
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    visible: false
    color: Color.transparent
    screen: screen

    function open() {
      visible = true
      PanelService.willOpenPanel(trayPanel)
    }

    function close() {
      visible = false
      if (trayMenu.item) {
        trayMenu.item.hideMenu()
      }
    }

    // Clicking outside of the rectangle to close
    MouseArea {
      anchors.fill: parent
      onClicked: trayPanel.close()
    }

    Loader {
      id: trayMenu
      source: "../Extras/TrayMenu.qml"
    }
  }
}
