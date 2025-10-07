pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "d MMM yy HH:mm:ss");
    }
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
