import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services
import qs.Widgets

Text {
  id: root

  property string family: Settings.data.ui.fontDefault
  property real pointSize: Style.fontSizeM * scaling
  property real fontScale: {
    return (root.family === Settings.data.ui.fontDefault ? Settings.data.ui.fontDefaultScale : Settings.data.ui.fontFixedScale)
  }

  font.family: root.family
  font.weight: Style.fontWeightMedium
  font.pointSize: root.pointSize * fontScale
  color: Color.mOnSurface
  elide: Text.ElideRight
  wrapMode: Text.NoWrap
  verticalAlignment: Text.AlignVCenter
}
