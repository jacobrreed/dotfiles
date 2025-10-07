import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  spacing: Style.marginL * scaling

  // Helper functions to update arrays immutably
  function addMonitor(list, name) {
    const arr = (list || []).slice()
    if (!arr.includes(name))
      arr.push(name)
    return arr
  }
  function removeMonitor(list, name) {
    return (list || []).filter(function (n) {
      return n !== name
    })
  }

  NHeader {
    label: I18n.tr("settings.dock.appearance.section.label")
    description: I18n.tr("settings.dock.appearance.section.description")
  }

  ColumnLayout {
    spacing: Style.marginXXS * scaling
    Layout.fillWidth: true
    NLabel {
      label: I18n.tr("settings.dock.appearance.display.label")
      description: I18n.tr("settings.dock.appearance.display.description")
    }
    NComboBox {
      Layout.fillWidth: true
      model: [{
          "key": "always_visible",
          "name": I18n.tr("settings.dock.appearance.display.always-visible")
        }, {
          "key": "auto_hide",
          "name": I18n.tr("settings.dock.appearance.display.auto-hide")
        }, {
          "key": "exclusive",
          "name": I18n.tr("settings.dock.appearance.display.exclusive")
        }]
      currentKey: Settings.data.dock.displayMode
      onSelected: key => {
                    Settings.data.dock.displayMode = key
                  }
    }
  }

  ColumnLayout {
    spacing: Style.marginXXS * scaling
    Layout.fillWidth: true
    NLabel {
      label: I18n.tr("settings.dock.appearance.background-opacity.label")
      description: I18n.tr("settings.dock.appearance.background-opacity.description")
    }
    NValueSlider {
      Layout.fillWidth: true
      from: 0
      to: 1
      stepSize: 0.01
      value: Settings.data.dock.backgroundOpacity
      onMoved: value => Settings.data.dock.backgroundOpacity = value
      text: Math.floor(Settings.data.dock.backgroundOpacity * 100) + "%"
    }
  }

  ColumnLayout {
    spacing: Style.marginXXS * scaling
    Layout.fillWidth: true

    NLabel {
      label: I18n.tr("settings.dock.appearance.floating-distance.label")
      description: I18n.tr("settings.dock.appearance.floating-distance.description")
    }

    NValueSlider {
      Layout.fillWidth: true
      from: 0
      to: 4
      stepSize: 0.01
      value: Settings.data.dock.floatingRatio
      onMoved: value => Settings.data.dock.floatingRatio = value
      text: Math.floor(Settings.data.dock.floatingRatio * 100) + "%"
    }
  }

  NDivider {
    Layout.fillWidth: true
    Layout.topMargin: Style.marginXL * scaling
    Layout.bottomMargin: Style.marginXL * scaling
  }

  // Monitor Configuration
  ColumnLayout {
    spacing: Style.marginM * scaling
    Layout.fillWidth: true

    NHeader {
      label: I18n.tr("settings.dock.monitors.section.label")
      description: I18n.tr("settings.dock.monitors.section.description")
    }

    Repeater {
      model: Quickshell.screens || []
      delegate: NCheckbox {
        Layout.fillWidth: true
        label: modelData.name || "Unknown"
        description: I18n.tr("system.monitor-description", {
                               "model": modelData.model,
                               "width": modelData.width,
                               "height": modelData.height
                             })
        checked: (Settings.data.dock.monitors || []).indexOf(modelData.name) !== -1
        onToggled: checked => {
                     if (checked) {
                       Settings.data.dock.monitors = addMonitor(Settings.data.dock.monitors, modelData.name)
                     } else {
                       Settings.data.dock.monitors = removeMonitor(Settings.data.dock.monitors, modelData.name)
                     }
                   }
      }
    }
  }

  NToggle {
    label: I18n.tr("settings.dock.monitors.only-same-output.label")
    description: I18n.tr("settings.dock.monitors.only-same-output.description")
    checked: Settings.data.dock.onlySameOutput
    onToggled: checked => Settings.data.dock.onlySameOutput = checked
  }

  NDivider {
    Layout.fillWidth: true
    Layout.topMargin: Style.marginXL * scaling
    Layout.bottomMargin: Style.marginXL * scaling
  }
}
