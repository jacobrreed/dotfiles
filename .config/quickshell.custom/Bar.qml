import Quickshell
import QtQuick
import QtQuick.Layouts

Variants {
    model: Quickshell.screens

    PanelWindow {
        color: "transparent"
        required property var modelData
        screen: modelData

        margins {
            top: 5
            bottom: 0
            left: 5
            right: 5
        }

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 30

        Item {
            anchors.fill: parent
            clip: true

            Rectangle {
                id: bar

                anchors.fill: parent
                color: "#2b2b2b"
                radius: 10
            }

            Loader {
                anchors.fill: parent
                sourceComponent: horizontalBarComponent
            }

            Component {
                id: horizontalBarComponent
                Item {
                    anchors.fill: parent

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        // Left section
                        Item {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            RowLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    id: leftBar
                                    width: 80
                                    height: parent.height
                                    color: "transparent"
                                    Workspaces {}
                                }
                            }
                        }

                        // Center section
                        Item {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                            RowLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    id: centerBar
                                    width: 80
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        text: "center"
                                        anchors.centerIn: parent
                                        color: "#37f499"
                                    }
                                }
                            }
                        }

                        // Right section
                        Item {
                            Layout.preferredWidth: 100 // or whatever width you want
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            RowLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    id: rightBar
                                    width: 80
                                    height: parent.height
                                    color: "transparent"
                                    ClockWidget {
                                        color: "#37f499"
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
