import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "dankHooks"

    StyledText {
        text: "System Event Hooks"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        text: "Execute custom scripts when system events occur. Scripts receive two arguments: hook name (e.g., 'onBatteryLevelChanged') and event value."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        width: parent.width
        wrapMode: Text.WordWrap
    }

    StyledRect {
        width: parent.width
        height: 1
        color: Theme.surfaceVariant
    }

    StyledText {
        text: "Appearance & Theme"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.DemiBold
        color: Theme.surfaceText
    }

        StringSetting {
            settingKey: "wallpaperPath"
            label: "Wallpaper Changed"
            description: "Hook: onWallpaperChanged | Value: wallpaper file path"
            placeholder: "/path/to/wallpaper-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "lightMode"
            label: "Light/Dark Mode Changed"
            description: "Hook: onLightModeChanged | Value: 'light' or 'dark'"
            placeholder: "/path/to/mode-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "theme"
            label: "Theme Changed"
            description: "Hook: onThemeChanged | Value: theme name (e.g., 'blue', 'red', 'dynamic')"
            placeholder: "/path/to/theme-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "nightMode"
            label: "Night Mode Changed"
            description: "Hook: onNightModeChanged | Value: 'enabled' or 'disabled'"
            placeholder: "/path/to/nightmode-hook.sh"
            defaultValue: ""
        }

        StyledRect {
            width: parent.width
            height: 1
            color: Theme.surfaceVariant
        }

        StyledText {
            text: "Power & Battery"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
            color: Theme.surfaceText
        }

        StringSetting {
            settingKey: "batteryLevel"
            label: "Battery Level Changed"
            description: "Hook: onBatteryLevelChanged | Value: percentage (0-100)"
            placeholder: "/path/to/battery-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "batteryCharging"
            label: "Battery Charging State Changed"
            description: "Hook: onBatteryChargingChanged | Value: 'charging' or 'not-charging'"
            placeholder: "/path/to/charging-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "batteryPluggedIn"
            label: "Power Adapter Changed"
            description: "Hook: onBatteryPluggedInChanged | Value: 'plugged-in' or 'on-battery'"
            placeholder: "/path/to/power-hook.sh"
            defaultValue: ""
        }

        StyledRect {
            width: parent.width
            height: 1
            color: Theme.surfaceVariant
        }

        StyledText {
            text: "Network"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
            color: Theme.surfaceText
        }

        StringSetting {
            settingKey: "wifiConnected"
            label: "WiFi Connection Changed"
            description: "Hook: onWifiConnectedChanged | Value: 'connected' or 'disconnected'"
            placeholder: "/path/to/wifi-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "wifiSSID"
            label: "WiFi Network Changed"
            description: "Hook: onWifiSSIDChanged | Value: SSID name or 'none'"
            placeholder: "/path/to/ssid-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "ethernetConnected"
            label: "Ethernet Connection Changed"
            description: "Hook: onEthernetConnectedChanged | Value: 'connected' or 'disconnected'"
            placeholder: "/path/to/ethernet-hook.sh"
            defaultValue: ""
        }

        StyledRect {
            width: parent.width
            height: 1
            color: Theme.surfaceVariant
        }

        StyledText {
            text: "Audio"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
            color: Theme.surfaceText
        }

        StringSetting {
            settingKey: "audioVolume"
            label: "Audio Volume Changed"
            description: "Hook: onAudioVolumeChanged | Value: percentage (0-100)"
            placeholder: "/path/to/volume-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "audioMute"
            label: "Audio Mute Changed"
            description: "Hook: onAudioMuteChanged | Value: 'muted' or 'unmuted'"
            placeholder: "/path/to/mute-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "micMute"
            label: "Microphone Mute Changed"
            description: "Hook: onMicMuteChanged | Value: 'muted' or 'unmuted'"
            placeholder: "/path/to/mic-hook.sh"
            defaultValue: ""
        }

        StyledRect {
            width: parent.width
            height: 1
            color: Theme.surfaceVariant
        }

        StyledText {
            text: "Display & Media"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
            color: Theme.surfaceText
        }

        StringSetting {
            settingKey: "brightness"
            label: "Brightness Changed"
            description: "Hook: onBrightnessChanged | Value: percentage (0-100)"
            placeholder: "/path/to/brightness-hook.sh"
            defaultValue: ""
        }

        StringSetting {
            settingKey: "mediaPlaying"
            label: "Media Playback Changed"
            description: "Hook: onMediaPlayingChanged | Value: 'playing' or 'paused'"
            placeholder: "/path/to/media-hook.sh"
            defaultValue: ""
        }

        StyledRect {
            width: parent.width
            height: 1
            color: Theme.surfaceVariant
        }

        StyledText {
            text: "System"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.DemiBold
            color: Theme.surfaceText
        }

        StringSetting {
            settingKey: "doNotDisturb"
            label: "Do Not Disturb Changed"
            description: "Hook: onDoNotDisturbChanged | Value: 'enabled' or 'disabled'"
            placeholder: "/path/to/dnd-hook.sh"
            defaultValue: ""
        }

        StyledRect {
            width: parent.width
            height: 1
            color: Theme.surfaceVariant
        }

    StyledText {
        text: "Hook Script Examples"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.DemiBold
        color: Theme.surfaceText
    }

    StyledText {
        text: "Example hook script:"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
    }

    StyledRect {
        width: parent.width
        height: exampleCode.height + 16
        color: Theme.surface
        radius: Theme.cornerRadius

        StyledText {
            id: exampleCode
            anchors.centerIn: parent
            anchors.margins: 8
            width: parent.width - 16
            text: '#!/bin/bash\n# Save as ~/.config/scripts/hook.sh\n# Make executable: chmod +x ~/.config/scripts/hook.sh\n\nHOOK_NAME="$1"  # e.g., "onWallpaperChanged"\nHOOK_VALUE="$2" # e.g., "/path/to/wallpaper.jpg"\n\necho "Hook: $HOOK_NAME, Value: $HOOK_VALUE"\nnotify-send "$HOOK_NAME" "$HOOK_VALUE"'
            font.pixelSize: Theme.fontSizeSmall
            font.family: "monospace"
            color: Theme.surfaceText
            wrapMode: Text.WordWrap
        }
    }

    StyledText {
        text: "All hooks pass two arguments: $1 = hook name (e.g., 'onBatteryLevelChanged'), $2 = event value. See descriptions above for each hook's values."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        width: parent.width
        wrapMode: Text.WordWrap
    }
}
