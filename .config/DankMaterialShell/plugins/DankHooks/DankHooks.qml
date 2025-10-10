import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Modules.Plugins

PluginComponent {
    id: root

    property string hookWallpaperPath: pluginData.wallpaperPath || ""
    property string hookLightMode: pluginData.lightMode || ""
    property string hookTheme: pluginData.theme || ""
    property string hookBatteryLevel: pluginData.batteryLevel || ""
    property string hookBatteryCharging: pluginData.batteryCharging || ""
    property string hookBatteryPluggedIn: pluginData.batteryPluggedIn || ""
    property string hookWifiConnected: pluginData.wifiConnected || ""
    property string hookWifiSSID: pluginData.wifiSSID || ""
    property string hookEthernetConnected: pluginData.ethernetConnected || ""
    property string hookAudioVolume: pluginData.audioVolume || ""
    property string hookAudioMute: pluginData.audioMute || ""
    property string hookMicMute: pluginData.micMute || ""
    property string hookBrightness: pluginData.brightness || ""
    property string hookNightMode: pluginData.nightMode || ""
    property string hookDoNotDisturb: pluginData.doNotDisturb || ""
    property string hookMediaPlaying: pluginData.mediaPlaying || ""
    property string hookIdleStateActive: pluginData.idleStateActive || ""

    Connections {
        target: SessionData
        function onWallpaperPathChanged() {
            if (hookWallpaperPath) {
                executeHook(hookWallpaperPath, "onWallpaperChanged", SessionData.wallpaperPath)
            }
        }

        function onIsLightModeChanged() {
            if (hookLightMode) {
                executeHook(hookLightMode, "onLightModeChanged", SessionData.isLightMode ? "light" : "dark")
            }
        }

        function onNightModeEnabledChanged() {
            if (hookNightMode) {
                executeHook(hookNightMode, "onNightModeChanged", SessionData.nightModeEnabled ? "enabled" : "disabled")
            }
        }

        function onDoNotDisturbChanged() {
            if (hookDoNotDisturb) {
                executeHook(hookDoNotDisturb, "onDoNotDisturbChanged", SessionData.doNotDisturb ? "enabled" : "disabled")
            }
        }
    }

    Connections {
        target: typeof Theme !== "undefined" ? Theme : null
        function onCurrentThemeChanged() {
            if (hookTheme) {
                executeHook(hookTheme, "onThemeChanged", Theme.currentTheme)
            }
        }
    }

    Connections {
        target: BatteryService.batteryAvailable ? BatteryService : null
        function onBatteryLevelChanged() {
            if (hookBatteryLevel) {
                executeHook(hookBatteryLevel, "onBatteryLevelChanged", String(BatteryService.batteryLevel))
            }
        }

        function onIsChargingChanged() {
            if (hookBatteryCharging) {
                executeHook(hookBatteryCharging, "onBatteryChargingChanged", BatteryService.isCharging ? "charging" : "not-charging")
            }
        }

        function onIsPluggedInChanged() {
            if (hookBatteryPluggedIn) {
                executeHook(hookBatteryPluggedIn, "onBatteryPluggedInChanged", BatteryService.isPluggedIn ? "plugged-in" : "on-battery")
            }
        }
    }

    Connections {
        target: NetworkService
        function onWifiConnectedChanged() {
            if (hookWifiConnected) {
                executeHook(hookWifiConnected, "onWifiConnectedChanged", NetworkService.wifiConnected ? "connected" : "disconnected")
            }
        }

        function onCurrentWifiSSIDChanged() {
            if (hookWifiSSID) {
                executeHook(hookWifiSSID, "onWifiSSIDChanged", NetworkService.currentWifiSSID || "none")
            }
        }

        function onEthernetConnectedChanged() {
            if (hookEthernetConnected) {
                executeHook(hookEthernetConnected, "onEthernetConnectedChanged", NetworkService.ethernetConnected ? "connected" : "disconnected")
            }
        }
    }

    Connections {
        target: AudioService.sink && AudioService.sink.audio ? AudioService.sink.audio : null

        function onVolumeChanged() {
            if (hookAudioVolume && AudioService.sink && AudioService.sink.audio) {
                executeHook(hookAudioVolume, "onAudioVolumeChanged", String(Math.round(AudioService.sink.audio.volume * 100)))
            }
        }

        function onMutedChanged() {
            if (hookAudioMute && AudioService.sink && AudioService.sink.audio) {
                executeHook(hookAudioMute, "onAudioMuteChanged", AudioService.sink.audio.muted ? "muted" : "unmuted")
            }
        }
    }

    Connections {
        target: AudioService.source && AudioService.source.audio ? AudioService.source.audio : null

        function onMutedChanged() {
            if (hookMicMute && AudioService.source && AudioService.source.audio) {
                executeHook(hookMicMute, "onMicMuteChanged", AudioService.source.audio.muted ? "muted" : "unmuted")
            }
        }
    }

    Connections {
        target: DisplayService

        function onBrightnessLevelChanged() {
            if (hookBrightness && DisplayService.brightnessAvailable) {
                executeHook(hookBrightness, "onBrightnessChanged", String(DisplayService.brightnessLevel))
            }
        }
    }

    Connections {
        target: MprisController.activePlayer

        function onIsPlayingChanged() {
            if (hookMediaPlaying && MprisController.activePlayer) {
                executeHook(hookMediaPlaying, "onMediaPlayingChanged", MprisController.activePlayer.isPlaying ? "playing" : "paused")
            }
        }
    }

    function executeHook(scriptPath, hookName, hookValue) {
        if (!scriptPath || scriptPath.trim() === "") {
            return
        }

        const process = hookProcessComponent.createObject(root, {
            hookScript: scriptPath,
            hookName: hookName,
            hookValue: hookValue
        })

        if (!process) {
            console.error("DankHooks: Failed to create process object")
            return
        }

        process.running = true
    }

    Component {
        id: hookProcessComponent

        Process {
            property string hookScript: ""
            property string hookName: ""
            property string hookValue: ""

            command: [hookScript, hookName, hookValue]

            stdout: StdioCollector {
                onStreamFinished: {
                    if (text.trim()) {
                        console.log("DankHooks output:", text.trim())
                    }
                }
            }

            stderr: StdioCollector {
                onStreamFinished: {
                    if (text.trim()) {
                        ToastService.showError("Hook Script Error", text.trim())
                    }
                }
            }

            onExited: (exitCode) => {
                if (exitCode !== 0) {
                    ToastService.showError("Hook Script Error", `Script '${hookScript}' exited with code: ${exitCode}`)
                }
                destroy()
            }
        }
    }

    Component.onDestruction: {
        console.log("DankHooks: Stopped monitoring system events")
    }
}
