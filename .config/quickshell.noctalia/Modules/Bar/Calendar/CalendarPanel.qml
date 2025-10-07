import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

NPanel {
  id: root

  preferredWidth: Settings.data.location.showWeekNumberInCalendar ? 340 : 320
  preferredHeight: 380

  panelContent: ColumnLayout {
    id: content
    anchors.fill: parent
    anchors.margins: Style.marginL * scaling
    spacing: Style.marginM * scaling

    readonly property int firstDayOfWeek: Qt.locale().firstDayOfWeek
    property bool isCurrentMonth: Time.date.getMonth() == grid.month

    Connections {
      target: Time
      function onDateChanged() {
        if (Time.date.getMonth() !== grid.month) {
          isCurrentMonth = Time.date.getMonth() == grid.month
        }
      }
    }

    // Current day
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 80 * scaling
      radius: Style.radiusL * scaling
      color: Color.mPrimary

      RowLayout {
        anchors.fill: parent
        anchors.margins: Style.marginL * scaling
        anchors.topMargin: 12 * scaling
        spacing: Style.marginM * scaling

        // Month, Year and Day
        RowLayout {
          Layout.alignment: Qt.AlignVCenter
          Layout.fillHeight: true
          spacing: Style.marginM * scaling

          // Big day of the month
          NText {
            text: Time.date.getDate()
            pointSize: Style.fontSizeXXXL * 1.5 * scaling
            font.weight: Style.fontWeightBold
            color: Color.mOnPrimary
            visible: isCurrentMonth
            Layout.preferredWidth: visible ? implicitWidth : 0
            Layout.fillHeight: true
          }

          // Month and Year
          ColumnLayout {
            spacing: 0

            NText {
              text: Qt.locale().monthName(grid.month, Locale.LongFormat).toUpperCase()
              pointSize: Style.fontSizeL * scaling
              font.weight: Style.fontWeightBold
              color: Color.mOnPrimary
            }

            NText {
              text: grid.year
              pointSize: Style.fontSizeM * scaling
              color: Qt.alpha(Color.mOnPrimary, 0.8)
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Digital clock with circular progress
        Item {
          width: Style.fontSizeXXXL * 2 * scaling
          height: Style.fontSizeXXXL * 2 * scaling

          // Seconds circular progress
          Canvas {
            id: secondsProgress
            anchors.fill: parent

            property real progress: Time.date.getSeconds() / 60
            onProgressChanged: requestPaint()

            Connections {
              target: Time
              function onDateChanged() {
                secondsProgress.progress = Time.date.getSeconds() / 60
              }
            }

            onPaint: {
              var ctx = getContext("2d")
              var centerX = width / 2
              var centerY = height / 2
              var radius = Math.min(width, height) / 2 - 4 * scaling

              ctx.reset()

              // Background circle
              ctx.beginPath()
              ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
              ctx.lineWidth = 3 * scaling
              ctx.strokeStyle = Qt.alpha(Color.mOnPrimary, 0.15)
              ctx.stroke()

              // Progress arc
              ctx.beginPath()
              ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + progress * 2 * Math.PI)
              ctx.lineWidth = 3 * scaling
              ctx.strokeStyle = Color.mOnPrimary
              ctx.lineCap = "round"
              ctx.stroke()
            }
          }

          // Digital clock
          ColumnLayout {
            anchors.centerIn: parent
            spacing: -3 * scaling

            NText {
              text: {
                var t = Settings.data.location.use12hourFormat ? Qt.locale().toString(new Date(), "hh AP") : Qt.locale().toString(new Date(), "HH")
                return t.split(" ")[0]
              }
              pointSize: Style.fontSizeS * scaling
              font.weight: Style.fontWeightBold
              color: Color.mOnPrimary
              family: Settings.data.ui.fontFixed
              Layout.alignment: Qt.AlignHCenter
            }

            NText {
              text: Qt.formatTime(Time.date, "mm")
              pointSize: Style.fontSizeS * scaling
              font.weight: Style.fontWeightBold
              color: Color.mOnPrimary
              family: Settings.data.ui.fontFixed
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }
      }
    }

    // Navigation and divider
    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginS * scaling

      NDivider {
        Layout.fillWidth: true
      }

      NIconButton {
        icon: "chevron-left"
        onClicked: {
          let newDate = new Date(grid.year, grid.month - 1, 1)
          grid.year = newDate.getFullYear()
          grid.month = newDate.getMonth()
        }
      }

      NIconButton {
        icon: "calendar"
        onClicked: {
          grid.month = Time.date.getMonth()
          grid.year = Time.date.getFullYear()
        }
      }

      NIconButton {
        icon: "chevron-right"
        onClicked: {
          let newDate = new Date(grid.year, grid.month + 1, 1)
          grid.year = newDate.getFullYear()
          grid.month = newDate.getMonth()
        }
      }
    }

    // Names of days of the week
    RowLayout {
      Layout.fillWidth: true
      spacing: 0

      Item {
        visible: Settings.data.location.showWeekNumberInCalendar
        Layout.preferredWidth: visible ? Style.baseWidgetSize * 0.7 * scaling : 0
      }

      GridLayout {
        Layout.fillWidth: true
        columns: 7
        rows: 1
        columnSpacing: 0
        rowSpacing: 0

        Repeater {
          model: 7

          Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.baseWidgetSize * 0.6 * scaling

            NText {
              anchors.centerIn: parent
              text: {
                let dayIndex = (content.firstDayOfWeek + index) % 7
                const dayNames = ["S", "M", "T", "W", "T", "F", "S"]
                return dayNames[dayIndex]
              }
              color: Color.mPrimary
              pointSize: Style.fontSizeS * scaling
              font.weight: Style.fontWeightBold
              horizontalAlignment: Text.AlignHCenter
            }
          }
        }
      }
    }

    // Grid with weeks and days
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 0

      // Columna de números de semana
      ColumnLayout {
        visible: Settings.data.location.showWeekNumberInCalendar
        Layout.preferredWidth: visible ? Style.baseWidgetSize * 0.7 * scaling : 0
        Layout.fillHeight: true
        spacing: 0

        Repeater {
          model: 6

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            NText {
              anchors.centerIn: parent
              color: Color.mOutline
              pointSize: Style.fontSizeXXS * scaling
              font.weight: Style.fontWeightMedium
              text: {
                let firstOfMonth = new Date(grid.year, grid.month, 1)
                let firstDayOfWeek = content.firstDayOfWeek
                let firstOfMonthDayOfWeek = firstOfMonth.getDay()
                let daysBeforeFirst = (firstOfMonthDayOfWeek - firstDayOfWeek + 7) % 7
                if (daysBeforeFirst === 0) {
                  daysBeforeFirst = 7
                }
                let gridStartDate = new Date(grid.year, grid.month, 1 - daysBeforeFirst)
                let rowStartDate = new Date(gridStartDate)
                rowStartDate.setDate(gridStartDate.getDate() + (index * 7))
                let thursday = new Date(rowStartDate)
                if (firstDayOfWeek === 0) {
                  thursday.setDate(rowStartDate.getDate() + 4)
                } else if (firstDayOfWeek === 1) {
                  thursday.setDate(rowStartDate.getDate() + 3)
                } else {
                  let daysToThursday = (4 - firstDayOfWeek + 7) % 7
                  thursday.setDate(rowStartDate.getDate() + daysToThursday)
                }
                return `${getISOWeekNumber(thursday)}`
              }
            }
          }
        }
      }

      // Days Grid
      MonthGrid {
        id: grid

        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Style.marginXXS * scaling
        month: Time.date.getMonth()
        year: Time.date.getFullYear()
        locale: Qt.locale()

        delegate: Item {
          Rectangle {
            width: Style.baseWidgetSize * 0.9 * scaling
            height: Style.baseWidgetSize * 0.9 * scaling
            anchors.centerIn: parent
            radius: Style.radiusM * scaling

            color: model.today ? Color.mSecondary : Color.transparent

            NText {
              anchors.centerIn: parent
              text: model.day
              color: {
                if (model.today)
                  return Color.mOnSecondary
                if (model.month === grid.month)
                  return Color.mOnSurface
                return Color.mOnSurfaceVariant
              }
              opacity: model.month === grid.month ? 1.0 : 0.4
              pointSize: Style.fontSizeM * scaling
              font.weight: model.today ? Style.fontWeightBold : Style.fontWeightMedium
            }

            Behavior on color {
              ColorAnimation {
                duration: Style.animationFast
              }
            }
          }
        }
      }
    }
  }

  function getISOWeekNumber(date) {
    const target = new Date(date.getTime())
    target.setHours(0, 0, 0, 0)
    const dayOfWeek = target.getDay() || 7
    target.setDate(target.getDate() + 4 - dayOfWeek)
    const yearStart = new Date(target.getFullYear(), 0, 1)
    const weekNumber = Math.ceil(((target - yearStart) / 86400000 + 1) / 7)
    return weekNumber
  }
}
