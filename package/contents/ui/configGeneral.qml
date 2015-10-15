 /* hablamemo - configGeneral.qml
 *
 * Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com> 
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
 
import QtQuick 2.1
import QtQuick.Controls 1.1 as QtControls
import QtQuick.Layouts 1.1 as QtLayouts
import QtQuick.Dialogs 1.2 as Dialogs

Item {
  id: generalPage

  property alias cfg_zoomlevel: zoomlevel.value
  property alias cfg_memoryfile: memoryfile.text
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

        QtControls.Label {
          id: fileLabel

          text: i18n("Memory file:")
        }
          
        QtLayouts.RowLayout {
          QtLayouts.Layout.fillWidth: true
          
          QtControls.TextField  {
            id: memoryfile 
            anchors.fill: parent
            QtLayouts.Layout.fillWidth: true
            QtLayouts.Layout.minimumWidth: units.gridUnit*20
            
            placeholderText: i18n("Path to a .kvtml file ...")
          }
        
          QtControls.Button {
            text: "..."

            onClicked: fileDialog.open();
          }
        }
       }
       
       QtControls.CheckBox {
        id: useimages
            
        text: i18n("Use images if available")
      }
     }
  }
  
  Dialogs.FileDialog {
    id: fileDialog
    
    title: i18n("Please choose a file")
    nameFilters: [ i18n("kvtml files") + " (*.kvtml)"]
    
    onAccepted: {
      memoryfile.text = fileDialog.fileUrl;      
    }
  }
}