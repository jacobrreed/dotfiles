import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: root

    // Properties
    property var screen: null

    // Bind to the current screen's workspaces
    property var workspaces: Hyprland.workspaces

    // Filter workspaces to only show those on the current screen
    function getScreenWorkspaces() {
        if (!screen)
            return [];

        return workspaces.filter(function (workspace) {
            return workspace.monitor === screen.name;
        });
    }

    RowLayout {
        anchors.fill: parent
        spacing: 8

        Text {
            text: "getScreenWorkspaces: " + getScreenWorkspaces().length
        }
        Text {
            text: "workspaces: " + (workspaces ? workspaces.length : "null")
        }
        Text {
            text: "Hyprland: " + (Hyprland ? 'defined' : 'undefined')
        }
        // Use Repeater to create workspace indicators
        Repeater {
            model: getScreenWorkspaces()

            delegate: RowLayout {
                spacing: 4

                // Workspace number/ID indicator
                Rectangle {
                    width: 24
                    height: 24
                    radius: 5
                    color: modelData.id === Hyprland.activeWorkspace.id ? "#5294e2" : "#3b4252"

                    Text {
                        anchors.centerIn: parent
                        text: modelData.id.toString()
                        font.pixelSize: 12
                        color: "white"
                    }
                }

                //     // App icons for this workspace
                //     Repeater {
                //         model: Hyprland.clients.filter(function (client) {
                //             return client.workspace === modelData.id && client.monitor === screen.name;
                //         })
                //
                //         delegate: Item {
                //             Layout.preferredWidth: 22
                //             Layout.preferredHeight: 22
                //         }
                //     }
            }
        }
    }

    // Update when Hyprland state changes
    Connections {
        target: Hyprland

        function onWorkspacesChanged() {
            // Force update when workspaces change
            root.workspaces = Hyprland.workspaces;
        }

        function onClientsChanged() {
            // Force update when client state changes
            root.workspaces = Hyprland.workspaces;
        }
    }
}
