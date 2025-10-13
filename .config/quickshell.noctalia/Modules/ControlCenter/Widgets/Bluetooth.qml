import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  text: I18n.tr("quickSettings.bluetooth.label.enabled")
  icon: BluetoothService.enabled ? "bluetooth" : "bluetooth-off"
  tooltipText: I18n.tr("quickSettings.bluetooth.tooltip.action")
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"
  onClicked: PanelService.getPanel("bluetoothPanel")?.toggle(this)
}
