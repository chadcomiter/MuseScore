import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0

RadioDelegate {
    id: root

    property Component iconComponent: null
    property string title: ""
    property int titlePixelSize: ui.theme.font.pixelSize

    property int orientation: Qt.Vertical

    height: 48

    background: Item {
        anchors.fill: parent

        Rectangle {
            id: backgroundRect
            anchors.fill: parent

            color: ui.theme.backgroundPrimaryColor
            opacity: root.checked || root.pressed ? 0 : ui.theme.buttonOpacityNormal
            border.width: 0
            radius: 2
        }

        Item {
            id: backgroundGradientRect
            anchors.fill: parent

            property bool isVertical: orientation === Qt.Vertical
            visible: false

            LinearGradient {
                id: backgroundGradient
                anchors.fill: parent

                start: Qt.point(0, 0)
                end: backgroundGradientRect.isVertical ? Qt.point(0, root.width) : Qt.point(root.width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: Qt.rgba(ui.theme.accentColor.r,
                                                                 ui.theme.accentColor.g,
                                                                 ui.theme.accentColor.b,
                                                                 backgroundGradientRect.isVertical ? 0.2 : 0.1) }
                }
            }

            Rectangle {
                id: line
                color: ui.theme.accentColor

                states: [
                    State {
                        when: backgroundGradientRect.isVertical
                        AnchorChanges {
                            target: line
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                        }

                        PropertyChanges {
                            target: line
                            width: parent.width
                            height: 2
                        }
                    },
                    State {
                        when: !backgroundGradientRect.isVertical
                        AnchorChanges {
                            target: line
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                        }

                        PropertyChanges {
                            target: line
                            width: 2
                            height: parent.height
                        }
                    }
                ]
            }
        }
    }

    contentItem: RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: !Boolean(iconComponent) ? 10 : 0
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        spacing: 0

        Item {
            Layout.preferredWidth: 76
            Layout.fillHeight: true

            visible: Boolean(iconComponent)

            Loader {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                sourceComponent: iconComponent
            }
        }

        StyledTextLabel {
            id: textLabel
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: true

            horizontalAlignment: Text.AlignLeft
            font.pixelSize: titlePixelSize
            text: title
        }
    }

    indicator: Item {}

    states: [
        State {
            name: "PRESSED"
            when: root.pressed

            PropertyChanges {
                target: backgroundRect
                color: ui.theme.buttonColor
                opacity: ui.theme.accentOpacityHit
                border.width: 0
            }
        },

        State {
            name: "SELECTED"
            when: root.checked && !root.hovered

            PropertyChanges {
                target: backgroundRect
                visible: false
            }

            PropertyChanges {
                target: backgroundGradientRect
                visible: true
            }

            PropertyChanges {
                target: textLabel
                font.bold: true
            }
        },

        State {
            name: "HOVERED"
            when: root.hovered && !root.checked && !root.pressed

            PropertyChanges {
                target: backgroundRect
                color: ui.theme.buttonColor
                opacity: ui.theme.buttonOpacityHover
                border.color: ui.theme.strokeColor
                border.width: 1
            }
        },

        State {
            name: "SELECTED_HOVERED"
            when: root.hovered && root.checked

            PropertyChanges {
                target: backgroundRect
                opacity: ui.theme.accentOpacityHover
                border.width: 0
            }

            PropertyChanges {
                target: backgroundGradientRect
                visible: true
            }

            PropertyChanges {
                target: textLabel
                font.bold: true
            }
        }
    ]
}