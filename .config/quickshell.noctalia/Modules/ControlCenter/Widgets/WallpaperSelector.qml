import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  enabled: Settings.data.wallpaper.enabled
  icon: "wallpaper-selector"
  text: I18n.tr("quickSettings.wallpaperSelector.label")
  tooltipText: I18n.tr("quickSettings.wallpaperSelector.tooltip.action")
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"

  onClicked: PanelService.getPanel("wallpaperPanel")?.toggle(this)
  onRightClicked: WallpaperService.setRandomWallpaper()
}
