import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.Commons
import qs.Services
import qs.Widgets

// Performance
NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0
  readonly property bool hasPP: PowerProfileService.available

  enabled: hasPP
  text: hasPP ? PowerProfileService.getName() : I18n.tr("quickSettings.powerProfile.label.unavailable")
  icon: PowerProfileService.getIcon()
  hot: !PowerProfileService.isDefault()
  tooltipText: I18n.tr("quickSettings.powerProfile.tooltip.action")
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"

  onClicked: {
    PowerProfileService.cycleProfile()
  }
}
