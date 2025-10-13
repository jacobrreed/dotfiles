import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Modules.Settings
import qs.Modules.ControlCenter
import qs.Modules.ControlCenter.Extras
import qs.Commons
import qs.Services
import qs.Widgets

// Header card with avatar, user and quick actions
NBox {
  id: root

  property string uptimeText: "--"
  property real spacing: Style.marginS * scaling

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Style.marginM * scaling

    // Profile, Uptime, Settings, SessionMenu, Close
    RowLayout {
      id: content

      spacing: root.spacing
      Layout.alignment: Qt.AlignVCenter

      NImageCircled {
        width: Style.baseWidgetSize * 1.25 * scaling
        height: width
        imagePath: Settings.data.general.avatarImage
        fallbackIcon: "person"
        borderColor: Color.mPrimary
        borderWidth: Math.max(1, Style.borderM * scaling)
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: Style.marginXS * scaling
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginXXS * scaling
        NText {
          text: Quickshell.env("USER") || "user"
          font.weight: Style.fontWeightBold
          font.capitalization: Font.Capitalize
        }
        NText {
          text: I18n.tr("system.uptime", {
                          "uptime": uptimeText
                        })
          pointSize: Style.fontSizeXS * scaling
          color: Color.mOnSurfaceVariant
        }
      }

      Item {
        Layout.fillWidth: true
      }

      RowLayout {
        spacing: root.spacing
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

        NIconButton {
          baseSize: Style.baseWidgetSize * 0.9
          icon: "settings"
          tooltipText: I18n.tr("tooltips.open-settings")
          onClicked: {
            settingsPanel.requestedTab = SettingsPanel.Tab.General
            settingsPanel.open()
          }
        }

        NIconButton {
          baseSize: Style.baseWidgetSize * 0.9
          icon: "power"
          tooltipText: I18n.tr("tooltips.session-menu")
          onClicked: {
            sessionMenuPanel.open()
            controlCenterPanel.close()
          }
        }

        NIconButton {
          baseSize: Style.baseWidgetSize * 0.9
          icon: "close"
          tooltipText: I18n.tr("tooltips.close")
          onClicked: {
            controlCenterPanel.close()
          }
        }
      }
    }

    NDivider {
      Layout.fillWidth: true
      Layout.topMargin: Style.marginS * scaling
      Layout.bottomMargin: Style.marginS * scaling
    }

    GridLayout {
      id: grid
      Layout.fillWidth: true
      columns: (Settings.data.controlCenter.quickSettingsStyle === "compact") ? 4 : 3
      columnSpacing: Style.marginS * scaling
      rowSpacing: Style.marginS * scaling

      Repeater {
        model: Settings.data.controlCenter.widgets.quickSettings
        delegate: ControlCenterWidgetLoader {
          Layout.fillWidth: true
          widgetId: (modelData.id !== undefined ? modelData.id : "")
          widgetProps: {
            "screen": root.modelData || null,
            "scaling": ScalingService.getScreenScale(screen),
            "widgetId": modelData.id,
            "section": "quickSettings",
            "sectionWidgetIndex": index,
            "sectionWidgetsCount": Settings.data.controlCenter.widgets.quickSettings.length
          }
          Layout.alignment: Qt.AlignVCenter
        }
      }
    }
  }

  // ----------------------------------
  // Uptime
  Timer {
    interval: 60000
    repeat: true
    running: true
    onTriggered: uptimeProcess.running = true
  }

  Process {
    id: uptimeProcess
    command: ["cat", "/proc/uptime"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var uptimeSeconds = parseFloat(this.text.trim().split(' ')[0])
        uptimeText = Time.formatVagueHumanReadableDuration(uptimeSeconds)
        uptimeProcess.running = false
      }
    }
  }

  function updateSystemInfo() {
    uptimeProcess.running = true
  }
}
