import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  enabled: ProgramCheckerService.wlsunsetAvailable
  text: I18n.tr("quickSettings.nightLight.label.enabled")
  icon: Settings.data.nightLight.enabled ? (Settings.data.nightLight.forced ? "nightlight-forced" : "nightlight-on") : "nightlight-off"
  hot: !Settings.data.nightLight.enabled || Settings.data.nightLight.forced
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"
  tooltipText: I18n.tr("quickSettings.nightLight.tooltip.action")

  onClicked: {
    if (!Settings.data.nightLight.enabled) {
      Settings.data.nightLight.enabled = true
      Settings.data.nightLight.forced = false
    } else if (Settings.data.nightLight.enabled && !Settings.data.nightLight.forced) {
      Settings.data.nightLight.forced = true
    } else {
      Settings.data.nightLight.enabled = false
      Settings.data.nightLight.forced = false
    }
  }

  onRightClicked: {
    var settingsPanel = PanelService.getPanel("settingsPanel")
    settingsPanel.requestedTab = SettingsPanel.Tab.Display
    settingsPanel.open()
  }
}
