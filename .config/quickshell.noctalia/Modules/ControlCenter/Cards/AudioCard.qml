import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

// Audio controls card: output and input volume controls
NBox {
  id: root

  property real scaling: 1.0
  property real localOutputVolume: AudioService.volume
  property real localInputVolume: AudioService.inputVolume

  // Timer to debounce volume changes (similar to AudioTab)
  Timer {
    interval: 100
    running: true
    repeat: true
    onTriggered: {
      if (Math.abs(localOutputVolume - AudioService.volume) >= 0.01) {
        AudioService.setVolume(localOutputVolume)
      }
    }
  }

  // Connections to update local volumes when AudioService changes
  Connections {
    target: AudioService.sink?.audio ? AudioService.sink?.audio : null
    function onVolumeChanged() {
      localOutputVolume = AudioService.volume
    }
  }

  Connections {
    target: AudioService.source?.audio ? AudioService.source?.audio : null
    function onVolumeChanged() {
      localInputVolume = AudioService.inputVolume
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Style.marginM * scaling
    spacing: 0

    // Output Volume Section
    ColumnLayout {
      spacing: Style.marginXXS * scaling
      Layout.fillWidth: true
      opacity: AudioService.sink ? 1.0 : 0.5
      enabled: AudioService.sink

      // Output Volume Header
      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginXS * scaling

        NIconButton {
          icon: AudioService.muted ? "volume-off" : "volume-high"
          baseSize: Style.baseWidgetSize * 0.5
          colorFg: AudioService.muted ? Color.mError : Color.mOnSurfaceVariant
          colorBg: Color.transparent
          colorBgHover: Color.mTertiary
          colorFgHover: Color.mOnTertiary
          onClicked: {
            if (AudioService.sink && AudioService.sink.audio) {
              AudioService.sink.audio.muted = !AudioService.muted
            }
          }
        }

        RowLayout {
          spacing: Style.marginXXS * scaling
          Layout.fillWidth: true

          NText {
            text: I18n.tr("settings.audio.volumes.output-volume.label")
            pointSize: Style.fontSizeXS * scaling
            color: Color.mOnSurface
            font.weight: Style.fontWeightMedium
          }

          NText {
            text: AudioService.sink ? AudioService.sink.description : "No output device"
            pointSize: Style.fontSizeXS * scaling
            color: Color.mOnSurfaceVariant
            font.weight: Style.fontWeightMedium
            elide: Text.ElideRight
            Layout.fillWidth: true
          }
        }
      }

      // Output Volume Slider
      NValueSlider {
        Layout.fillWidth: true
        from: 0
        to: Settings.data.audio.volumeOverdrive ? 1.5 : 1.0
        value: localOutputVolume || 0
        stepSize: 0.01
        text: Math.round((AudioService.volume || 0) * 100) + "%"
        textSize: Style.fontSizeXS * scaling
        customHeightRatio: 0.6
        onMoved: value => localOutputVolume = value
      }
    }

    // Input Volume Section
    ColumnLayout {
      spacing: Style.marginXXS * scaling
      Layout.fillWidth: true
      opacity: AudioService.source ? 1.0 : 0.5
      enabled: AudioService.source

      // Input Volume Header
      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginXS * scaling

        NIconButton {
          icon: AudioService.inputMuted ? "microphone-off" : "microphone"
          baseSize: Style.baseWidgetSize * 0.5
          colorFg: AudioService.inputMuted ? Color.mError : Color.mOnSurfaceVariant
          colorBg: Color.transparent
          colorBgHover: Color.mTertiary
          colorFgHover: Color.mOnTertiary
          onClicked: AudioService.setInputMuted(!AudioService.inputMuted)
        }

        RowLayout {
          spacing: Style.marginXXS * scaling
          Layout.fillWidth: true

          NText {
            text: I18n.tr("settings.audio.volumes.input-volume.label")
            pointSize: Style.fontSizeXS * scaling
            color: Color.mOnSurface
            font.weight: Style.fontWeightMedium
          }

          NText {
            text: AudioService.source ? AudioService.source.description : "No input device"
            pointSize: Style.fontSizeXS * scaling
            color: Color.mOnSurfaceVariant
            font.weight: Style.fontWeightMedium
            elide: Text.ElideRight
            Layout.fillWidth: true
          }
        }
      }

      // Input Volume Slider
      NValueSlider {
        Layout.fillWidth: true
        from: 0
        to: Settings.data.audio.volumeOverdrive ? 1.5 : 1.0
        value: AudioService.inputVolume || 0
        stepSize: 0.01
        text: Math.round((AudioService.inputVolume || 0) * 100) + "%"
        textSize: Style.fontSizeXS * scaling
        customHeightRatio: 0.6
        onMoved: value => AudioService.setInputVolume(value)
      }
    }
  }
}
