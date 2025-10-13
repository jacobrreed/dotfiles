import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

// Unified OSD component
// Loader activates only when showing OSD, deactivates when hidden to save resources
Variants {
  model: Quickshell.screens.filter(screen => (Settings.data.osd.monitors.includes(screen.name) || (Settings.data.osd.monitors.length === 0)) && Settings.data.osd.enabled)

  delegate: Loader {
    id: root

    required property ShellScreen modelData
    property real scaling: ScalingService.getScreenScale(modelData)

    // Access the notification model from the service
    property ListModel notificationModel: NotificationService.activeList

    // Loader is only active when actually showing something
    active: false

    // Current OSD display state
    property string currentOSDType: "" // "volume", "inputVolume", "brightness", or ""

    // Volume properties
    readonly property real currentVolume: AudioService.volume
    readonly property bool isMuted: AudioService.muted
    property bool volumeInitialized: false
    property bool muteInitialized: false

    // Input volume properties
    readonly property real currentInputVolume: AudioService.inputVolume
    readonly property bool isInputMuted: AudioService.inputMuted
    property bool inputVolumeInitialized: false
    property bool inputMuteInitialized: false

    // Brightness properties
    property bool brightnessInitialized: false
    property int brightnessChangeCount: 0
    readonly property real currentBrightness: {
      if (BrightnessService.monitors.length > 0) {
        return BrightnessService.monitors[0].brightness || 0
      }
      return 0
    }

    // Get appropriate icon based on current OSD type
    function getIcon() {
      if (currentOSDType === "volume") {
        if (AudioService.muted) {
          return "volume-mute"
        }
        return (AudioService.volume <= Number.EPSILON) ? "volume-zero" : (AudioService.volume <= 0.5) ? "volume-low" : "volume-high"
      } else if (currentOSDType === "inputVolume") {
        if (AudioService.inputMuted) {
          return "microphone-off"
        }
        return "microphone"
      } else if (currentOSDType === "brightness") {
        return currentBrightness <= 0.5 ? "brightness-low" : "brightness-high"
      }
      return ""
    }

    // Get current value (0-1 range)
    function getCurrentValue() {
      if (currentOSDType === "volume") {
        return isMuted ? 0 : currentVolume
      } else if (currentOSDType === "inputVolume") {
        return isInputMuted ? 0 : currentInputVolume
      } else if (currentOSDType === "brightness") {
        return currentBrightness
      }
      return 0
    }

    // Get display percentage
    function getDisplayPercentage() {
      if (currentOSDType === "volume") {
        if (isMuted)
          return "0%"
        const pct = Math.round(Math.min(1.0, currentVolume) * 100)
        return pct + "%"
      } else if (currentOSDType === "inputVolume") {
        if (isInputMuted)
          return "0%"
        const pct = Math.round(Math.min(1.0, currentInputVolume) * 100)
        return pct + "%"
      } else if (currentOSDType === "brightness") {
        const pct = Math.round(Math.min(1.0, currentBrightness) * 100)
        return pct + "%"
      }
      return ""
    }

    // Get progress bar color
    function getProgressColor() {
      if (currentOSDType === "volume") {
        if (isMuted)
          return Color.mError
        return Color.mPrimary
      } else if (currentOSDType === "inputVolume") {
        if (isInputMuted)
          return Color.mError
        return Color.mPrimary
      }
      return Color.mPrimary
    }

    // Get icon color
    function getIconColor() {
      if ((currentOSDType === "volume" && isMuted) || (currentOSDType === "inputVolume" && isInputMuted)) {
        return Color.mError
      }
      return Color.mOnSurface
    }

    sourceComponent: PanelWindow {
      id: panel
      screen: modelData

      // PanelWindow scaling
      property real scaling: ScalingService.getScreenScale(screen)

      readonly property string location: (Settings.data.osd && Settings.data.osd.location) ? Settings.data.osd.location : "top_right"
      readonly property bool isTop: (location === "top") || (location.length >= 3 && location.substring(0, 3) === "top")
      readonly property bool isBottom: (location === "bottom") || (location.length >= 6 && location.substring(0, 6) === "bottom")
      readonly property bool isLeft: (location.indexOf("_left") >= 0) || (location === "left")
      readonly property bool isRight: (location.indexOf("_right") >= 0) || (location === "right")
      readonly property bool isCentered: (location === "top" || location === "bottom")
      readonly property bool verticalMode: (location === "left" || location === "right")
      readonly property int hWidth: Math.round(320 * scaling)
      readonly property int hHeight: Math.round(64 * scaling)
      readonly property int vHeight: Math.round(320 * scaling) // Vertical OSD height (matches horizontal width)
      // Ensure an even width to keep the vertical bar perfectly centered
      readonly property int barThickness: (function () {
        const base = Math.max(8, Math.round(8 * scaling))
        return (base % 2 === 0) ? base : base + 1
      })()

      Component.onCompleted: {
        connectBrightnessMonitors()
      }

      Connections {
        target: ScalingService
        function onScaleChanged(screenName, scale) {
          if ((screen !== null) && (screenName === screen.name)) {
            scaling = scale
          }
        }
      }

      Component.onDestruction: {
        disconnectBrightnessMonitors()
      }

      // Anchor selection based on location (window edges)
      anchors.top: isTop
      anchors.bottom: isBottom
      anchors.left: isLeft
      anchors.right: isRight

      // Margins depending on bar position and chosen location
      margins.top: {
        if (!(anchors.top))
          return 0
        var base = Style.marginM * scaling
        if (Settings.data.bar.position === "top") {
          var floatExtraV = Settings.data.bar.floating ? Settings.data.bar.marginVertical * Style.marginXL * scaling : 0
          return (Style.barHeight * scaling) + base + floatExtraV
        }
        return base
      }

      margins.bottom: {
        if (!(anchors.bottom))
          return 0
        var base = Style.marginM * scaling
        if (Settings.data.bar.position === "bottom") {
          var floatExtraV = Settings.data.bar.floating ? Settings.data.bar.marginVertical * Style.marginXL * scaling : 0
          return (Style.barHeight * scaling) + base + floatExtraV
        }
        return base
      }

      margins.left: {
        if (!(anchors.left))
          return 0
        var base = Style.marginM * scaling
        if (Settings.data.bar.position === "left") {
          var floatExtraH = Settings.data.bar.floating ? Settings.data.bar.marginHorizontal * Style.marginXL * scaling : 0
          return (Style.barHeight * scaling) + base + floatExtraH
        }
        return base
      }

      margins.right: {
        if (!(anchors.right))
          return 0
        var base = Style.marginM * scaling
        if (Settings.data.bar.position === "right") {
          var floatExtraH = Settings.data.bar.floating ? Settings.data.bar.marginHorizontal * Style.marginXL * scaling : 0
          return (Style.barHeight * scaling) + base + floatExtraH
        }
        return base
      }

      implicitWidth: verticalMode ? hHeight : hWidth
      implicitHeight: osdItem.height

      color: Color.transparent

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.layer: (Settings.data.osd && Settings.data.osd.alwaysOnTop) ? WlrLayer.Overlay : WlrLayer.Top
      exclusionMode: PanelWindow.ExclusionMode.Ignore

      Rectangle {
        id: osdItem

        width: parent.width
        height: panel.verticalMode ? panel.vHeight : Math.round(64 * scaling)
        radius: Style.radiusL * scaling
        color: Color.mSurface
        border.color: Color.mOutline
        border.width: (function () {
          const bw = Math.max(2, Math.round(Style.borderM * scaling))
          return (bw % 2 === 0) ? bw : bw + 1
        })()
        visible: false
        opacity: 0
        scale: 0.85

        anchors.horizontalCenter: verticalMode ? undefined : parent.horizontalCenter
        anchors.verticalCenter: verticalMode ? parent.verticalCenter : undefined

        Behavior on opacity {
          NumberAnimation {
            id: opacityAnimation
            duration: Style.animationNormal
            easing.type: Easing.InOutQuad
          }
        }

        Behavior on scale {
          NumberAnimation {
            id: scaleAnimation
            duration: Style.animationNormal
            easing.type: Easing.InOutQuad
          }
        }

        Timer {
          id: hideTimer
          interval: Settings.data.osd.autoHideMs
          onTriggered: osdItem.hide()
        }

        // Timer to handle visibility after animations complete
        Timer {
          id: visibilityTimer
          interval: Style.animationNormal + 50 // Add small buffer
          onTriggered: {
            osdItem.visible = false
            root.currentOSDType = ""
            // Deactivate the loader when done
            root.active = false
          }
        }

        Loader {
          id: contentLoader
          anchors.fill: parent
          active: true
          sourceComponent: verticalMode ? verticalContent : horizontalContent
        }

        Component {
          id: horizontalContent
          Item {
            anchors.fill: parent

            RowLayout {
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              anchors.margins: Style.marginM * root.scaling
              spacing: Style.marginM * root.scaling

              NIcon {
                icon: root.getIcon()
                color: root.getIconColor()
                pointSize: Style.fontSizeXL * scaling
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                  ColorAnimation {
                    duration: Style.animationNormal
                    easing.type: Easing.InOutQuad
                  }
                }
              }

              // Progress bar with calculated width
              Rectangle {
                Layout.preferredWidth: Math.round(220 * root.scaling)
                height: panel.barThickness
                radius: Math.round(panel.barThickness / 2)
                color: Color.mSurfaceVariant
                Layout.alignment: Qt.AlignVCenter

                Rectangle {
                  anchors.left: parent.left
                  anchors.top: parent.top
                  anchors.bottom: parent.bottom
                  width: parent.width * Math.min(1.0, root.getCurrentValue())
                  radius: parent.radius
                  color: root.getProgressColor()

                  Behavior on width {
                    NumberAnimation {
                      duration: Style.animationNormal
                      easing.type: Easing.InOutQuad
                    }
                  }
                  Behavior on color {
                    ColorAnimation {
                      duration: Style.animationNormal
                      easing.type: Easing.InOutQuad
                    }
                  }
                }
              }

              // Percentage text
              NText {
                text: root.getDisplayPercentage()
                color: Color.mOnSurface
                pointSize: Style.fontSizeS * scaling
                family: Settings.data.ui.fontFixed
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.preferredWidth: Math.round(50 * root.scaling)
              }
            }
          }
        }

        Component {
          id: verticalContent
          ColumnLayout {
            // Ensure inner padding respects the rounded corners; avoid clipping the icon/text
            property int vMargin: (function () {
              const styleMargin = Math.round(Style.marginL * scaling)
              const cornerGuard = Math.round(osdItem.radius)
              return Math.max(styleMargin, cornerGuard)
            })()
            property int vMarginTop: Math.max(Math.round(osdItem.radius), Math.round(Style.marginS * scaling))
            property int balanceDelta: Math.round(Style.marginS * scaling)
            anchors.fill: parent
            anchors.topMargin: vMargin
            anchors.leftMargin: vMargin
            anchors.rightMargin: vMargin
            anchors.bottomMargin: vMargin
            spacing: Math.round(Style.marginS * scaling)

            // Percentage text at top
            Item {
              Layout.fillWidth: true
              Layout.preferredHeight: percentText.implicitHeight
              NText {
                id: percentText
                text: root.getDisplayPercentage()
                color: Color.mOnSurface
                pointSize: Style.fontSizeS * scaling
                family: Settings.data.ui.fontFixed
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }

            // Progress bar
            Item {
              Layout.fillWidth: true
              Layout.fillHeight: true // Fill remaining space between text and icon
              Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: panel.barThickness
                radius: Math.round(panel.barThickness / 2)
                color: Color.mSurfaceVariant

                Rectangle {
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.bottom: parent.bottom
                  height: parent.height * Math.min(1.0, root.getCurrentValue())
                  radius: parent.radius
                  color: root.getProgressColor()

                  Behavior on height {
                    NumberAnimation {
                      duration: Style.animationNormal
                      easing.type: Easing.InOutQuad
                    }
                  }
                  Behavior on color {
                    ColorAnimation {
                      duration: Style.animationNormal
                      easing.type: Easing.InOutQuad
                    }
                  }
                }
              }
            }

            // Icon at bottom
            NIcon {
              icon: root.getIcon()
              color: root.getIconColor()
              pointSize: Style.fontSizeXL * scaling
              Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
              Behavior on color {
                ColorAnimation {
                  duration: Style.animationNormal
                  easing.type: Easing.InOutQuad
                }
              }
            }
          }
        }

        function show() {
          // Cancel any pending hide operations
          hideTimer.stop()
          visibilityTimer.stop()

          // Make visible and animate in
          osdItem.visible = true
          // Use Qt.callLater to ensure the visible change is processed before animation
          Qt.callLater(() => {
                         osdItem.opacity = 1
                         osdItem.scale = 1.0
                       })

          // Start the auto-hide timer
          hideTimer.start()
        }

        function hide() {
          hideTimer.stop()
          visibilityTimer.stop()

          // Start fade out animation
          osdItem.opacity = 0
          osdItem.scale = 0.85 // Less dramatic scale change for smoother effect

          // Delay hiding the element until after animation completes
          visibilityTimer.start()
        }

        function hideImmediately() {
          hideTimer.stop()
          visibilityTimer.stop()
          osdItem.opacity = 0
          osdItem.scale = 0.85
          osdItem.visible = false
          root.currentOSDType = ""
          root.active = false
        }
      }

      function showOSD() {
        osdItem.show()
      }
    }

    // Volume change monitoring
    Connections {
      target: AudioService

      function onVolumeChanged() {
        if (volumeInitialized) {
          showOSD("volume")
        }
      }

      function onMutedChanged() {
        if (muteInitialized) {
          showOSD("volume")
        }
      }

      function onInputVolumeChanged() {
        if (inputVolumeInitialized) {
          showOSD("inputVolume")
        }
      }

      function onInputMutedChanged() {
        if (inputMuteInitialized) {
          showOSD("inputVolume")
        }
      }
    }

    // Timer to initialize volume/mute flags after services are ready
    Timer {
      id: initTimer
      interval: 500
      running: true
      onTriggered: {
        volumeInitialized = true
        muteInitialized = true
        inputVolumeInitialized = true
        inputMuteInitialized = true
        // Don't initialize brightness here - let it initialize on first change like volume
        connectBrightnessMonitors()
      }
    }

    // Brightness change monitoring
    Connections {
      target: BrightnessService

      function onMonitorsChanged() {
        connectBrightnessMonitors()
      }
    }

    function disconnectBrightnessMonitors() {
      for (var i = 0; i < BrightnessService.monitors.length; i++) {
        let monitor = BrightnessService.monitors[i]
        monitor.brightnessUpdated.disconnect(onBrightnessChanged)
      }
    }

    function connectBrightnessMonitors() {
      brightnessChangeCount = 0 // Reset change count when reconnecting
      for (var i = 0; i < BrightnessService.monitors.length; i++) {
        let monitor = BrightnessService.monitors[i]
        // Disconnect first to avoid duplicate connections
        monitor.brightnessUpdated.disconnect(onBrightnessChanged)
        monitor.brightnessUpdated.connect(onBrightnessChanged)
      }
    }

    function onBrightnessChanged(newBrightness) {
      brightnessChangeCount++

      if (brightnessChangeCount <= BrightnessService.monitors.length) {
        // This is likely the initial brightness value(s), don't show OSD
        brightnessInitialized = true
      } else {
        showOSD("brightness")
      }
    }

    function showOSD(type) {
      // Update the current OSD type
      currentOSDType = type

      // Activate the loader if not already active
      if (!root.active) {
        root.active = true
      }

      // Show the OSD (may need to wait for loader to create the item)
      if (root.item) {
        root.item.showOSD()
      } else {
        // If item not ready yet, wait for it
        Qt.callLater(() => {
                       if (root.item) {
                         root.item.showOSD()
                       }
                     })
      }
    }

    function hideOSD() {
      if (root.item && root.item.osdItem) {
        root.item.osdItem.hideImmediately()
      } else if (root.active) {
        // If loader is active but item isn't ready, just deactivate
        root.active = false
      }
    }
  }
}
