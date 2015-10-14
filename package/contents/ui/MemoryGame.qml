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
        property int numOfTries: 0
        property string winMessage: ""
        property bool gameCompleted: false
        property int selectionCount
        property variant dataset: memoryGame.dataset
        property alias containerModel: containerModel
        property alias cardRepeater: cardRepeater
        property alias grid: grid
        property int columns
        property int rows
        
        onGameCompletedChanged : {
          var messageStage = "";
          if (gameCompleted == true) {
            messageStage = i18n("Game completed!");
            if (items.numOfTries > items.playerScore) {
              if (items.numOfTries - items.playerScore === 1) {
                messageStage = messageStage + " " + i18n("You made just one mistake!");
              }
              else {
                messageStage = messageStage + " " + i18n("You made %1 mistakes.", items.numOfTries - items.playerScore);
              }
            }
            messageStage = messageStage + "\n\n" + i18n("Press 'Play' to start a new game.");
            items.winMessage = messageStage;
            console.log("WIN!"); //TODO: Remove
            console.log("tries: " + items.numOfTries); //TODO: Remove
            console.log("playerScore: " + items.playerScore); //TODO: Remove
            console.log("Score: " + items.playerScore/items.numOfTries*100); //TODO: Remove
            rotateAnim.start();
//             heightAnim.start(); //TODO: Review
//             widthAnim.start(); //TODO: Review
          }        
          else {
           items.winMessage = "";
          }
        }
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
      
      Rectangle {
        id: messageContainer
        
        anchors.centerIn: parent
        visible: items.gameCompleted
        clip: true
        color: "transparent"
        width:  childrenRect.width // 0
        height: childrenRect.height // 0
        
        Behavior on width { //TODO: Review
          animation: NumberAnimation {
            duration: 3000
            easing.type: Easing.InOutCubic
          }
        }
        
        Behavior on height {
          animation: NumberAnimation {
            duration: 3000
            easing.type: Easing.InOutCubic
          }
        }
        
//         NumberAnimation { //TODO: Review
//           id: widthAnim
// 
//           duration: 4000
//           property: "width"
//           target: messageContainer
//           from: 0
//           to: childrenRect.width
//           easing.type: Easing.InOutCubic
//         }
//         
//         NumberAnimation { //TODO: Review
//           id: heightAnim
//           
//           duration: 4000
//           property: "height"
//           target: messageContainer
//           from: 0
//           to: childrenRect.height
//           easing.type: Easing.InOutCubic
//         }
//         
        RotationAnimation {
          id: rotateAnim
          
          direction: RotationAnimation.Clockwise
          property: "rotation"
          target: messageContainer
          from: 0
          to: 5*360
          duration: 3000
          easing.type: Easing.InOutCubic
          
        }
          
//         Component.onCompleted: { //TODO: Delete
//           console.log("onCompleted.width: " + width);
//           console.log("onCompleted.implicitWidth  : " + implicitWidth);
//         }        
//         onImplicitWidthChanged: { //TODO: Delete
//           console.log("implicitWidth: " + implicitWidth);
//         }
//         onWidthChanged: { //TODO: Delete
//           console.log("width (change): " + width);
//         }
//         onYChanged: { //TODO: Delete
//           console.log("Y: " + y);
//         }  
//         onXChanged: { //TODO: Delete
//           console.log("X: " + x );
//         }           
//         
        PlasmaComponents.Label {
          id: winMessage
          
          //anchors.centerIn: parent
          font.pointSize: theme.defaultFont.pointSize * (plasmoid.configuration.zoomlevel/100)
          fontSizeMode: Text.Fit //Text.Fit vs Text.FixedSize 
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          text: items.winMessage
          wrapMode: Text.Wrap
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
