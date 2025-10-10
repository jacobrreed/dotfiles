# Dank Hooks Plugin

## Available Hooks

### Appearance & Theme

| Hook | Trigger | Hook Name | Value |
|------|---------|-----------|-------|
| **Wallpaper Changed** | When wallpaper changes | `onWallpaperChanged` | Wallpaper file path |
| **Light/Dark Mode Changed** | When switching between modes | `onLightModeChanged` | `light` or `dark` |
| **Theme Changed** | When color theme changes | `onThemeChanged` | Theme name (e.g., `blue`, `red`, `dynamic`) |
| **Night Mode Changed** | When night mode toggles | `onNightModeChanged` | `enabled` or `disabled` |

### Power & Battery

| Hook | Trigger | Hook Name | Value |
|------|---------|-----------|-------|
| **Battery Level Changed** | When battery percentage changes | `onBatteryLevelChanged` | Battery percentage (0-100) |
| **Battery Charging State Changed** | When charging state changes | `onBatteryChargingChanged` | `charging` or `not-charging` |
| **Power Adapter Changed** | When power adapter connects/disconnects | `onBatteryPluggedInChanged` | `plugged-in` or `on-battery` |

### Network

| Hook | Trigger | Hook Name | Value |
|------|---------|-----------|-------|
| **WiFi Connection Changed** | When WiFi connects/disconnects | `onWifiConnectedChanged` | `connected` or `disconnected` |
| **WiFi Network Changed** | When connected WiFi network changes | `onWifiSSIDChanged` | SSID name or `none` |
| **Ethernet Connection Changed** | When Ethernet connects/disconnects | `onEthernetConnectedChanged` | `connected` or `disconnected` |

### Audio

| Hook | Trigger | Hook Name | Value |
|------|---------|-----------|-------|
| **Audio Volume Changed** | When speaker volume changes | `onAudioVolumeChanged` | Volume percentage (0-100) |
| **Audio Mute Changed** | When speakers mute/unmute | `onAudioMuteChanged` | `muted` or `unmuted` |
| **Microphone Mute Changed** | When microphone mutes/unmutes | `onMicMuteChanged` | `muted` or `unmuted` |

### Display & Media

| Hook | Trigger | Hook Name | Value |
|------|---------|-----------|-------|
| **Brightness Changed** | When screen brightness changes | `onBrightnessChanged` | Brightness percentage (0-100) |
| **Media Playback Changed** | When media starts/stops playing | `onMediaPlayingChanged` | `playing` or `paused` |

### System

| Hook | Trigger | Hook Name | Value |
|------|---------|-----------|-------|
| **Do Not Disturb Changed** | When DND mode toggles | `onDoNotDisturbChanged` | `enabled` or `disabled` |
