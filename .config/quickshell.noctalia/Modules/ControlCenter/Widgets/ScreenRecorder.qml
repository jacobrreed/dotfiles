import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NQuickSetting {
  property ShellScreen screen
  property real scaling: 1.0

  enabled: ProgramCheckerService.gpuScreenRecorderAvailable
  icon: "camera-video"
  text: ScreenRecorderService.isRecording ? I18n.tr("quickSettings.screenRecorder.label.recording") : I18n.tr("quickSettings.screenRecorder.label.stopped")
  hot: ScreenRecorderService.isRecording
  tooltipText: I18n.tr("quickSettings.screenRecorder.tooltip.action")
  style: Settings.data.controlCenter.quickSettingsStyle || "modern"

  // Force hover state when recording to get hover colors
  property bool originalHovered: hovered
  hovered: ScreenRecorderService.isRecording || originalHovered

  onClicked: {
    ScreenRecorderService.toggleRecording()
    if (!ScreenRecorderService.isRecording) {
      var panel = PanelService.getPanel("controlCenterPanel")
      panel?.close()
    }
  }
}
