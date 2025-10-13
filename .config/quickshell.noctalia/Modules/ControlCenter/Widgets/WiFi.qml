import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  icon: {
    try {
      if (NetworkService.ethernetConnected) {
        return "ethernet"
      }
      let connected = false
      let signalStrength = 0
      for (const net in NetworkService.networks) {
        if (NetworkService.networks[net].connected) {
          connected = true
          signalStrength = NetworkService.networks[net].signal
          break
        }
      }
      return connected ? NetworkService.signalIcon(signalStrength) : "wifi-off"
    } catch (error) {
      Logger.error("Wi-Fi", "Error getting icon:", error)
      return "signal_wifi_bad"
    }
  }

  text: {
    if (NetworkService.ethernetConnected) {
      return I18n.tr("quickSettings.wifi.label.ethernet")
    }
    let connected = false
    for (const net in NetworkService.networks) {
      if (NetworkService.networks[net].connected) {
        connected = true
        break
      }
    }
    return connected ? I18n.tr("quickSettings.wifi.label.wifi") : I18n.tr("quickSettings.wifi.label.disconnected")
  }

  style: Settings.data.controlCenter.quickSettingsStyle || "modern"
  tooltipText: I18n.tr("quickSettings.wifi.tooltip.action")
  onClicked: PanelService.getPanel("wifiPanel")?.toggle(this)
}
