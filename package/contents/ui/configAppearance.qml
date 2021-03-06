/* hablamemo - configGeneral.qml
 *
 * Copyright (C) 2017 Dimitris Kardarakos <dimkard@gmail.com>
 *
 * Authors:
 *   Dimitris Kardarakos <dimkard@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Controls 1.3 as QtControls
import QtQuick.Layouts 1.1 as QtLayouts
import QtQuick.Dialogs 1.2 as Dialogs

Item {
    id: generalPage

    property alias cfg_zoomlevel: zoomlevel.value
    property alias cfg_useimages: useimages.checked

    width: childrenRect.width
    height: childrenRect.height

    QtControls.GroupBox {
        flat: true
        QtLayouts.Layout.fillWidth: true
        
        QtLayouts.ColumnLayout {
            QtLayouts.Layout.fillWidth: true
            spacing: 10

            QtLayouts.GridLayout {
                rows: 2
                columns: 2
                QtLayouts.Layout.fillWidth: true

                QtControls.Label {
                    id: zoomLabel

                    text: i18n("Text zoom level:")
                }

                QtControls.SpinBox {
                    id: zoomlevel

                    minimumValue: 100
                    maximumValue : 500
                }

                QtControls.CheckBox {
                    id: useimages

                    text: i18n("Use images if available")
                }
            }
        }
    }
}
