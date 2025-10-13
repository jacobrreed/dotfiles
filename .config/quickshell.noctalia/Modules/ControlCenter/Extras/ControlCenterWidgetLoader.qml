import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  property string widgetId: ""
  property var widgetProps: ({})
  property string screenName: widgetProps && widgetProps.screen ? widgetProps.screen.name : ""
  property string section: widgetProps && widgetProps.section || ""
  property int sectionIndex: widgetProps && widgetProps.sectionWidgetIndex || 0

  // Don't reserve space unless the loaded widget is really visible
  implicitWidth: getImplicitSize(loader.item, "implicitWidth")
  implicitHeight: getImplicitSize(loader.item, "implicitHeight")

  Connections {
    target: ScalingService
    enabled: loader.item && (loader.item.screen !== undefined)
    function onScaleChanged(aScreenName, scale) {
      if (loader.item && loader.item.screen && aScreenName === screenName) {
        loader.item['scaling'] = scale
      }
    }
  }

  function getImplicitSize(item, prop) {
    return (item && item.visible) ? item[prop] : 0
  }

  Loader {
    id: loader
    anchors.fill: parent
    active: widgetId !== ""
    asynchronous: false
    sourceComponent: {
      if (!active) {
        return null
      }
      return ControlCenterWidgetRegistry.getWidget(widgetId)
    }

    onLoaded: {
      if (item && widgetProps) {
        // Apply properties to loaded widget
        for (var prop in widgetProps) {
          if (item.hasOwnProperty(prop)) {
            item[prop] = widgetProps[prop]
          }
        }
      }

      if (item.hasOwnProperty("onLoaded")) {
        item.onLoaded()
      }

      //Logger.log("ControlCenterWidgetLoader", "Loaded", widgetId, "on screen", item.screen.name)
    }

    Component.onDestruction: {
      // Explicitly clear references
      widgetProps = null
    }
  }

  // Error handling
  onWidgetIdChanged: {
    if (widgetId && !ControlCenterWidgetRegistry.hasWidget(widgetId)) {
      Logger.warn("ControlCenterWidgetLoader", "Widget not found in registry:", widgetId)
    }
  }
}
