import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  text: Settings.data.notifications.doNotDisturb ? I18n.tr("quickSettings.notifications.label.disabled") : I18n.tr("quickSettings.notifications.label.enabled")
  icon: Settings.data.notifications.doNotDisturb ? "bell-off" : "bell"
  hot: Settings.data.notifications.doNotDisturb
  tooltipText: I18n.tr("quickSettings.notifications.tooltip.action")
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"

  onClicked: PanelService.getPanel("notificationHistoryPanel")?.toggle(this)
  onRightClicked: Settings.data.notifications.doNotDisturb = !Settings.data.notifications.doNotDisturb
}
