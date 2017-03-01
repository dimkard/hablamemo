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
import QtQuick 2.4  
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import "."
import "../code/memory.js" as Game
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {

  id: memoryGame

  property string backgroundImg
  property var dataset
  property string kvtmlFile

  focus: true

  Rectangle {
    id: background

    property alias items: items 

    signal start
    signal stop

    color: "transparent" //TODO: Review theme.backgroundColor   
    anchors.fill: parent
    focus: true
    
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
          messageStage = i18n("Game completed!\n");
          messageStage = messageStage + " " + i18n("Mistakes") + ": " + (items.numOfTries - items.playerScore) + "\n";
          messageStage = messageStage + i18n("Press 'Play' to start again.");
          items.winMessage = messageStage;
          rotateAnim.start();
          heightAnim.start();
          widthAnim.start();
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
      width:  1 //OLD: childrenRect.width 
      height: 1 //OLD: childrenRect.height
      
//         Behavior on width { //TODO: Replace if childrenRect width is to be used
//           animation: NumberAnimation {
//             duration: 3000
//             easing.type: Easing.InOutCubic
//           }
//         }
//         
//         Behavior on height {//TODO: Replace if childrenRect height is to be used
//           animation: NumberAnimation {
//             duration: 3000
//             easing.type: Easing.InOutCubic
//           }
//         }
      
      NumberAnimation {
        id: widthAnim

        duration: 750
        property: "width"
        target: messageContainer
        from: 0
        to: memoryGame.width * 3/4
        easing.type: Easing.Linear
      }
      
      NumberAnimation {
        id: heightAnim
        
        duration: 750
        property: "height"
        target: messageContainer
        from: 0
        to: (memoryGame.height - bar.height) / 2
        easing.type: Easing.Linear
      }
      
      RotationAnimation {
        id: rotateAnim
        
        duration: 750
        property: "rotation"
        target: messageContainer
        from: 0
        to: 2*360
        easing.type: Easing.Linear
        direction: RotationAnimation.Clockwise
      }
        
      PlasmaComponents.Label {
        id: winMessage
        
        width: messageContainer.width
        height: messageContainer.height
        //anchors.centerIn: parent
        font.pointSize: theme.defaultFont.pointSize * (plasmoid.configuration.zoomlevel/100)
        fontSizeMode: Text.Fit //Text.Fit vs Text.FixedSize 
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: items.winMessage
        wrapMode: Text.Wrap
        style: Text.Raised
        styleColor: theme.buttonBackgroundColor   
      }
    }
    
    Row { 
      id: bar
      
      height: childrenRect.height
      width: childrenRect.width
      anchors {
        bottom: background.bottom
        left: background.left
        leftMargin : 5
      }
      spacing: 20
    
      
      SpinBox {
        id: userLevel

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
      
      PlasmaComponents.Button {
        id: startButton
        
        text: i18n("Play")
        
        onClicked: {
          memoryGame.focus =  true;
          Game.start(items);       
        }
      }
    }
  }
}
