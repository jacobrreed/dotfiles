import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  text: I18n.tr("quickSettings.keepAwake.label.enabled")
  icon: IdleInhibitorService.isInhibited ? "keep-awake-on" : "keep-awake-off"
  hot: IdleInhibitorService.isInhibited
  tooltipText: I18n.tr("quickSettings.keepAwake.tooltip.action")
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"

  onClicked: IdleInhibitorService.manualToggle()
}
