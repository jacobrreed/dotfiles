import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.Commons
import qs.Services
import qs.Widgets

// Simple notification popup - displays multiple notifications
Variants {
  // If no notification display activated in settings, then show them all
  model: Quickshell.screens.filter(screen => (Settings.data.notifications.monitors.includes(screen.name) || (Settings.data.notifications.monitors.length === 0)))

  delegate: Loader {
    id: root

    required property ShellScreen modelData
    property real scaling: ScalingService.getScreenScale(modelData)

    // Access the notification model from the service
    property ListModel notificationModel: NotificationService.activeList

    // Loader is active when there are notifications
    active: notificationModel.count > 0 || delayTimer.running

    // Keep loader active briefly after last notification to allow animations to complete
    Timer {
      id: delayTimer
      interval: Style.animationSlow + 200 // Animation duration + buffer
      repeat: false
    }

    // Start delay timer when last notification is removed
    Connections {
      target: notificationModel
      function onCountChanged() {
        if (notificationModel.count === 0 && root.active) {
          delayTimer.restart()
        }
      }
    }

    Connections {
      target: ScalingService
      function onScaleChanged(screenName, scale) {
        if (root.modelData && screenName === root.modelData.name) {
          root.scaling = scale
        }
      }
    }

    sourceComponent: PanelWindow {
      screen: modelData

      WlrLayershell.namespace: "noctalia-notifications"
      WlrLayershell.layer: (Settings.data.notifications && Settings.data.notifications.alwaysOnTop) ? WlrLayer.Overlay : WlrLayer.Top

      color: Color.transparent

      readonly property string location: (Settings.data.notifications && Settings.data.notifications.location) ? Settings.data.notifications.location : "top_right"
      readonly property bool isTop: (location === "top") || (location.length >= 3 && location.substring(0, 3) === "top")
      readonly property bool isBottom: (location === "bottom") || (location.length >= 6 && location.substring(0, 6) === "bottom")
      readonly property bool isLeft: location.indexOf("_left") >= 0
      readonly property bool isRight: location.indexOf("_right") >= 0
      readonly property bool isCentered: (location === "top" || location === "bottom")

      // Store connection for cleanup
      property var animateConnection: null

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

      implicitWidth: 360 * scaling
      implicitHeight: notificationStack.implicitHeight
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      // Connect to animation signal from service
      Component.onCompleted: {
        animateConnection = NotificationService.animateAndRemove.connect(function (notificationId) {
          // Find the delegate by notification ID
          var delegate = null
          if (notificationStack && notificationStack.children && notificationStack.children.length > 0) {
            for (var i = 0; i < notificationStack.children.length; i++) {
              var child = notificationStack.children[i]
              if (child && child.notificationId === notificationId) {
                delegate = child
                break
              }
            }
          }

          if (delegate && delegate.animateOut) {
            delegate.animateOut()
          } else {
            // Force removal without animation as fallback
            NotificationService.dismissActiveNotification(notificationId)
          }
        })
      }

      // Disconnect when destroyed to prevent memory leaks
      Component.onDestruction: {
        if (animateConnection) {
          NotificationService.animateAndRemove.disconnect(animateConnection)
          animateConnection = null
        }
      }

      // Main notification container
      ColumnLayout {
        id: notificationStack
        // Anchor the stack inside the window based on chosen location
        anchors.top: parent.isTop ? parent.top : undefined
        anchors.bottom: parent.isBottom ? parent.bottom : undefined
        anchors.left: parent.isLeft ? parent.left : undefined
        anchors.right: parent.isRight ? parent.right : undefined
        anchors.horizontalCenter: parent.isCentered ? parent.horizontalCenter : undefined
        spacing: Style.marginS * scaling
        width: 360 * scaling
        visible: true

        // Multiple notifications display
        Repeater {
          model: notificationModel
          delegate: Rectangle {
            id: card

            // Store the notification ID and data for reference
            property string notificationId: model.id
            property var notificationData: model
            property real cardScaling: root.scaling

            Layout.preferredWidth: 360 * cardScaling
            Layout.preferredHeight: notificationLayout.implicitHeight + (Style.marginL * 2 * cardScaling)
            Layout.maximumHeight: Layout.preferredHeight

            radius: Style.radiusL * cardScaling
            border.color: Color.mOutline
            border.width: Math.max(1, Style.borderS * cardScaling)
            color: Color.mSurface

            // Optimized progress bar container
            Rectangle {
              id: progressBarContainer
              anchors.top: parent.top
              anchors.left: parent.left
              anchors.right: parent.right
              height: 2 * cardScaling
              color: Color.transparent

              // Pre-calculate available width for the progress bar
              readonly property real availableWidth: parent.width - (2 * parent.radius)

              // Actual progress bar - centered and symmetric
              Rectangle {
                id: progressBar
                height: parent.height

                // Center the bar and make it shrink symmetrically
                x: parent.parent.radius + (parent.availableWidth * (1 - model.progress)) / 2
                width: parent.availableWidth * model.progress

                color: {
                  if (model.urgency === NotificationUrgency.Critical || model.urgency === 2)
                    return Color.mError
                  else if (model.urgency === NotificationUrgency.Low || model.urgency === 0)
                    return Color.mOnSurface
                  else
                    return Color.mPrimary
                }

                antialiasing: true

                // Smooth progress animation
                Behavior on width {
                  enabled: !card.isRemoving // Disable during removal animation
                  NumberAnimation {
                    duration: 100 // Quick but smooth
                    easing.type: Easing.Linear
                  }
                }

                Behavior on x {
                  enabled: !card.isRemoving
                  NumberAnimation {
                    duration: 100
                    easing.type: Easing.Linear
                  }
                }
              }
            }

            // Animation properties
            property real scaleValue: 0.8
            property real opacityValue: 0.0
            property bool isRemoving: false

            // Right-click to dismiss
            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.RightButton
              onClicked: {
                if (mouse.button === Qt.RightButton) {
                  animateOut()
                }
              }
            }

            // Scale and fade-in animation
            scale: scaleValue
            opacity: opacityValue

            // Animate in when the item is created
            Component.onCompleted: {
              scaleValue = 1.0
              opacityValue = 1.0
            }

            // Animate out when being removed
            function animateOut() {
              if (isRemoving)
                return
              // Prevent multiple animations
              isRemoving = true
              scaleValue = 0.8
              opacityValue = 0.0
            }

            // Timer for delayed removal after animation
            Timer {
              id: removalTimer
              interval: Style.animationSlow
              repeat: false
              onTriggered: {
                NotificationService.dismissActiveNotification(notificationId)
              }
            }

            // Check if this notification is being removed
            onIsRemovingChanged: {
              if (isRemoving) {
                removalTimer.start()
              }
            }

            // Animation behaviors
            Behavior on scale {
              NumberAnimation {
                duration: Style.animationNormal
                easing.type: Easing.OutExpo
              }
            }

            Behavior on opacity {
              NumberAnimation {
                duration: Style.animationNormal
                easing.type: Easing.OutQuad
              }
            }

            ColumnLayout {
              id: notificationLayout
              anchors.fill: parent
              anchors.margins: Style.marginM * cardScaling
              anchors.rightMargin: (Style.marginM + 32) * cardScaling // Leave space for close button
              spacing: Style.marginM * cardScaling

              // Main content section
              RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginM * cardScaling

                ColumnLayout {
                  // For real-time notification always show the original image
                  // as the cached version is most likely still processing.
                  NImageCircled {
                    Layout.preferredWidth: 40 * cardScaling
                    Layout.preferredHeight: 40 * cardScaling
                    Layout.alignment: Qt.AlignTop
                    Layout.topMargin: 30 * cardScaling
                    imagePath: model.originalImage || ""
                    borderColor: Color.transparent
                    borderWidth: 0
                    fallbackIcon: "bell"
                    fallbackIconSize: 24 * cardScaling
                  }
                  Item {
                    Layout.fillHeight: true
                  }
                }

                // Text content
                ColumnLayout {
                  Layout.fillWidth: true
                  spacing: Style.marginS * cardScaling

                  // Header section with app name and timestamp
                  RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.marginS * cardScaling

                    Rectangle {
                      Layout.preferredWidth: 6 * cardScaling
                      Layout.preferredHeight: 6 * cardScaling
                      radius: Style.radiusXS * cardScaling
                      color: {
                        if (model.urgency === NotificationUrgency.Critical || model.urgency === 2)
                          return Color.mError
                        else if (model.urgency === NotificationUrgency.Low || model.urgency === 0)
                          return Color.mOnSurface
                        else
                          return Color.mPrimary
                      }
                      Layout.alignment: Qt.AlignVCenter
                    }

                    NText {
                      text: `${model.appName || I18n.tr("system.unknown-app")} · ${Time.formatRelativeTime(model.timestamp)}`
                      color: Color.mSecondary
                      pointSize: Style.fontSizeXS * cardScaling
                    }

                    Item {
                      Layout.fillWidth: true
                    }
                  }

                  NText {
                    text: model.summary || I18n.tr("general.no-summary")
                    pointSize: Style.fontSizeL * cardScaling
                    font.weight: Style.fontWeightMedium
                    color: Color.mOnSurface
                    textFormat: Text.PlainText
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    Layout.fillWidth: true
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    visible: text.length > 0
                  }

                  NText {
                    text: model.body || ""
                    pointSize: Style.fontSizeM * cardScaling
                    color: Color.mOnSurface
                    textFormat: Text.PlainText
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    Layout.fillWidth: true
                    maximumLineCount: 5
                    elide: Text.ElideRight
                    visible: text.length > 0
                  }

                  // Notification actions
                  Flow {
                    Layout.fillWidth: true
                    spacing: Style.marginS * cardScaling
                    Layout.topMargin: Style.marginM * cardScaling

                    flow: Flow.LeftToRight
                    layoutDirection: Qt.LeftToRight

                    // Store the notification ID for access in button delegates
                    property string parentNotificationId: notificationId

                    // Parse actions from JSON string
                    property var parsedActions: {
                      try {
                        return model.actionsJson ? JSON.parse(model.actionsJson) : []
                      } catch (e) {
                        return []
                      }
                    }
                    visible: parsedActions.length > 0

                    Repeater {
                      model: parent.parsedActions

                      delegate: NButton {
                        property var actionData: modelData

                        text: {
                          var actionText = actionData.text || "Open"
                          // If text contains comma, take the part after the comma (the display text)
                          if (actionText.includes(",")) {
                            return actionText.split(",")[1] || actionText
                          }
                          return actionText
                        }
                        fontSize: Style.fontSizeS * cardScaling
                        backgroundColor: Color.mPrimary
                        textColor: hovered ? Color.mOnTertiary : Color.mOnPrimary
                        hoverColor: Color.mTertiary
                        outlined: false
                        implicitHeight: 24 * cardScaling
                        onClicked: {
                          NotificationService.invokeAction(parent.parentNotificationId, actionData.identifier)
                        }
                      }
                    }
                  }
                }
              }
            }

            // Close button positioned absolutely
            NIconButton {
              icon: "close"
              tooltipText: I18n.tr("tooltips.close")
              baseSize: Style.baseWidgetSize * 0.6
              anchors.top: parent.top
              anchors.topMargin: Style.marginM * cardScaling
              anchors.right: parent.right
              anchors.rightMargin: Style.marginM * cardScaling

              onClicked: {
                animateOut()
              }
            }
          }
        }
      }
    }
  }
}
