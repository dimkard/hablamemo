 /* gcompris - MemoryCommon.qml, hablamemo - MemoryGame.qml
 *
 * 
 * Copyright (C) 2014 JB BUTET <ashashiwa@gmail.com>
 * Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com> 
 * 
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *   Dimitris Kardarakos <dimkard@gmail.com> (version for Hablamemo)
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
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import "."
import "../code/memory.js" as Game
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: memoryGame
    focus: true


    property string backgroundImg
    property var dataset
    property string kvtmlFile

    Rectangle {
      id: background

      color: "transparent" //TODO: Review theme.backgroundColor   
      anchors.fill: parent
      focus: true
      signal start
      signal stop
      property alias items: items 
      
      QtObject { 
          id: items

          property var playQueue
          property int playerScore: 0
          property int selectionCount
          property variant dataset: memoryGame.dataset
          property alias containerModel: containerModel
          property alias cardRepeater: cardRepeater
          property alias grid: grid
          property int columns
          property int rows
      }

      ListModel {
          id: containerModel
      }

      Grid { 
          id: grid
          spacing: 15 
          columns: items.columns
          rows: items.rows
          anchors {
              leftMargin : 5
              topMargin: 5
              left: background.left
              right: background.rigth
              top: background.top
          }

          Repeater {
              id: cardRepeater
              model: containerModel

              delegate: CardItem {
                  pairData: pairData_
                  width: (background.width - (grid.columns + 1) * grid.spacing) / grid.columns
                  height: (background.height - (grid.rows + 1) * grid.spacing) / (grid.rows + 0.5)
              }
          }

          add: Transition {
              PathAnimation {
                  path: Path {
                      PathCurve { x: background.width / 3}
                      PathCurve { y: background.height / 3}
                      PathCurve {}
                  }
                  easing.type: Easing.InOutQuad
                  duration: 2000
              }
          }
      }
      
      Row { 
        id: bar
        
        height: 50
        width: parent.width
        anchors {
          bottom: background.bottom
          left: background.left
          leftMargin : 5
        }
        spacing: 20
      
        
        SpinBox {
          id: userLevel
          
          width: 150
          height: 30
          minimumValue: 1
          maximumValue: 3
          prefix: i18n("Level: ")
          style: Styles.SpinBoxStyle  {
            id: levelSpinStyle
 
          }
          
          onValueChanged: {
            Game.setLevel(userLevel.value-1);
          }
        }
        
        PlasmaComponents.Button { //TODO: Use icon?
          id: startButton
          
          width:150
          height: 30          
          text: i18n("Play")
          
          onClicked: {
            memoryGame.focus =  true;
            Game.start(items);       
//             console.log("Game started using memoryFile: " + memoryGame.kvtmlFile); //TODO: Remove
          }
        }
        
      }
    }
}
