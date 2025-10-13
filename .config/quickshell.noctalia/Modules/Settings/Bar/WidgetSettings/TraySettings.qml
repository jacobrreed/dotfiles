import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  // Properties to receive data from parent
  property var widgetData: ({}) // Expected by BarWidgetSettingsDialog
  property var widgetMetadata: ({}) // Expected by BarWidgetSettingsDialog

  // Local state for the blacklist
  property var localBlacklist: widgetData.blacklist || []

  ListModel {
    id: blacklistModel
  }

  Component.onCompleted: {
    // Populate the ListModel from localBlacklist
    for (var i = 0; i < localBlacklist.length; i++) {
      blacklistModel.append({
                              "rule": localBlacklist[i]
                            })
    }
  }

  spacing: Style.marginM * scaling

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS * scaling

    NLabel {
      label: I18n.tr("settings.bar.tray.blacklist.label")
      description: I18n.tr("settings.bar.tray.blacklist.description")
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginS * scaling

      NTextInput {
        id: newRuleInput
        Layout.fillWidth: true
        placeholderText: I18n.tr("settings.bar.tray.blacklist.placeholder")
      }

      NIconButton {
        Layout.alignment: Qt.AlignVCenter
        icon: "add"
        baseSize: Style.baseWidgetSize * 0.8 * scaling
        onClicked: {
          if (newRuleInput.text.length > 0) {
            var newRule = newRuleInput.text.trim()
            var exists = false
            for (var i = 0; i < blacklistModel.count; i++) {
              if (blacklistModel.get(i).rule === newRule) {
                exists = true
                break
              }
            }
            if (!exists) {
              blacklistModel.append({
                                      "rule": newRule
                                    })
              newRuleInput.text = ""
            }
          }
        }
        enabled: newRuleInput.text.length > 0
      }
    }
  }

  // List of current blacklist items
  ListView {
    Layout.fillWidth: true
    Layout.preferredHeight: 150 * scaling
    Layout.topMargin: Style.marginL * scaling // Increased top margin
    clip: true
    model: blacklistModel
    delegate: Item {
      width: ListView.width
      height: 40 * scaling

      Rectangle {
        id: itemBackground
        anchors.fill: parent
        anchors.margins: Style.marginXS * scaling
        color: Color.transparent // Make background transparent
        border.color: Color.mOutline
        border.width: Math.max(1, Style.borderS * scaling)
        radius: Style.radiusS * scaling
        visible: model.rule !== undefined && model.rule !== "" // Only visible if rule exists
      }

      Row {
        anchors.fill: parent
        anchors.leftMargin: Style.marginS * scaling
        anchors.rightMargin: Style.marginS * scaling
        spacing: Style.marginS * scaling

        NText {
          text: model.rule
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
          Layout.fillWidth: true
        }

        NIconButton {
          width: 16 * scaling
          height: 16 * scaling
          icon: "close"
          baseSize: 8 * scaling
          colorBg: Color.mSurfaceVariant
          colorFg: Color.mOnSurface
          colorBgHover: Color.mError
          colorFgHover: Color.mOnError
          onClicked: {
            blacklistModel.remove(index)
          }
        }
      }
    }
  }

  // This function will be called by the dialog to get the new settings
  function saveSettings() {
    var newBlacklist = []
    for (var i = 0; i < blacklistModel.count; i++) {
      newBlacklist.push(blacklistModel.get(i).rule)
    }

    // Return the updated settings for this widget instance
    var settings = Object.assign({}, widgetData || {})
    settings.blacklist = newBlacklist
    return settings
  }
}
