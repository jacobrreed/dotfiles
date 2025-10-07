import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Repeater {
    screen: modelData
    property HyprlandWorkspace hyprlandWorkspace: hyprlandMonitor.activeWorkspace
    property HyprlandMonitor hyprlandMonitor: Hyprland.monitorFor(screen)
    model: Hyprland.workspaces
    Text {
        text: hyprlandMonitor
    }
}
