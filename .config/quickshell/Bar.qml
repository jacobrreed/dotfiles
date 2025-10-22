import Quickshell
import QtQuick
import QtQuick.Layouts

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData
        color: "transparent"

        implicitHeight: 30

        anchors {
            top: true
            left: true
            right: true
        }

        margins {
            top: 5
            left: 8
            right: 8
        }

        Rectangle {
            width: parent.width
            height: parent.height
            radius: 5
            color: "#212337"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            // Left section
            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft

                // Workspace indicator component
                Workspace {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 300
                    screen: modelData
                }
            }

            // Center section
            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                // Center section components
                Text {
                    text: "Center Section"
                    color: "white"
                }
            }

            // Right section
            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight

                // Right section components
                Text {
                    text: "Right Section"
                    color: "white"
                }
            }
        }
    }
}
