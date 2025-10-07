import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

Variants {
  model: Quickshell.screens

  delegate: Loader {
    required property ShellScreen modelData
    property string wallpaper: ""

    active: CompositorService.isNiri && Settings.data.wallpaper.enabled && modelData

    sourceComponent: PanelWindow {
      id: panelWindow

      Component.onCompleted: {
        if (modelData) {
          Logger.log("Overview", "Loading Overview component for Niri on", modelData.name)
        }
        setWallpaperInitial()
      }

      // External state management
      Connections {
        target: WallpaperService
        function onWallpaperChanged(screenName, path) {
          if (screenName === modelData.name) {
            wallpaper = path
          }
        }
      }

      function setWallpaperInitial() {
        if (!WallpaperService || !WallpaperService.isInitialized) {
          Qt.callLater(setWallpaperInitial)
          return
        }
        const wallpaperPath = WallpaperService.getWallpaper(modelData.name)
        if (wallpaperPath && wallpaperPath !== wallpaper) {
          wallpaper = wallpaperPath
        }
      }

      color: Color.transparent
      screen: modelData
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "quickshell-overview"

      anchors {
        top: true
        bottom: true
        right: true
        left: true
      }

      Image {
        id: bgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: wallpaper
        smooth: true
        mipmap: false
        cache: false
        asynchronous: true
        // Image is heavily blurred, so might as well save a lot of memory here.
        sourceSize: Qt.size(1280, 720)
      }

      MultiEffect {
        anchors.fill: parent
        source: bgImage
        autoPaddingEnabled: false
        blurEnabled: true
        blur: 0.48
        blurMax: 128
        colorization: Style.opacityMedium
        colorizationColor: Settings.data.colorSchemes.darkMode ? Color.mSurface : Color.mOnSurface
      }
    }
  }
}
