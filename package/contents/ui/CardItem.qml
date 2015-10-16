/* gcompris/hablamemo - CardItem.qml
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

import "../code/memory.js" as Game
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Flipable {
  id: card

  property variant pairData
  property bool isBack: true
  property bool isShown: false
  property bool isFound: false
  property bool dealCompleted: false
  property bool useImages: plasmoid.configuration.useimages
  property int hintInterval: 1000
  property int zoomLevel: plasmoid.configuration.zoomlevel
  property alias memoryHintTimer: memoryHintTimer
  
  onIsFoundChanged: {
    opacity = 0
    timer.start()
  }

  Timer {
    id: timer
    
    interval: 100
    running: false
    repeat: false
  }


  Timer {
    id: memoryHintTimer
    
    property string action: "show"
    
    interval: 2000
    running: false
    repeat: true
    onTriggered: {
      if (action === "show") {
        card.isBack = false;
        action = "hide";
        interval = card.hintInterval;
      }
      else {
        card.isBack = true;
        card.dealCompleted = true; //Make card clickable after memory hint
        action = "show"; //Restore timer for future actions
        stop();
      }
    }
  }
  
  Timer {
    id: animationTimer
    
    interval: 750
    running: false
    repeat: false
    onTriggered: selectionReady()
  }

  back: Rectangle {
    color: theme.buttonBackgroundColor
    border {
      width : 3
      color:theme.textColor
    }
    radius : 20
    anchors.fill: parent
    
    Image {
      id: cardImage
      
      source: card.pairData.image
      sourceSize.width: parent.width * 0.95
      sourceSize.height: parent.height * 0.95
      anchors.centerIn: parent
      fillMode: Image.PreserveAspectFit
      visible: card.useImages && source !== ""
    }

    PlasmaComponents.Label {
      anchors.centerIn: parent
      minimumPointSize: theme.defaultFont.pointSize
      font {
        pointSize: theme.defaultFont.pointSize * (card.zoomLevel/100)
        bold: true
      }              
      fontSizeMode: Text.Fit //Text.Fit vs Text.FixedSize 
      elide: Text.ElideRight
      width: card.width * 0.8
      height: card.height * 0.8
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: card.pairData.text
      wrapMode: Text.Wrap
      visible: (!card.useImages || (card.useImages && cardImage.source == "") )
    }
    
  }

  // Warning front and back property are reversed. Could not find
  // a way to display back at start time without this trick
  front: Rectangle {
    anchors.fill: parent
    color:  "#1f3f4f" //TODO: Review
    border {
      width : 3
      color: theme.textColor
    }
    radius : 20       

//     PlasmaCore.Svg { //TODO: Replace if a non-installed icon is to be used
//     id: centerIcon
//     
//     size: Qt.size(card.height/2, card.height/2)
//     imagePath: "icons/start"
//   }
//   
//   PlasmaCore.SvgItem {
//     id: centerIconItem
//     
//     anchors.centerIn: parent
//     width: card.height/2
//     height: card.height/2  
//     svg: centerIcon          
//     }

//     PlasmaCore.IconItem {
//       id: centerIconItem
//       
//       anchors.centerIn: parent
//       width: (card.height < card.width) ? card.height*3/4 : card.width*3/4 
//       height: (card.height < card.width) ? card.height*3/4 : card.width*3/4
//       source: "copy"
//     }

    Image { //TODO: Review image source
      id: centerIconItem
      
      anchors.centerIn: parent
      width: (card.height < card.width) ? card.height*3/4 : card.width*3/4 
      height: (card.height < card.width) ? card.height*3/4 : card.width*3/4
      source: "resource/hablamemo-icon.png" // A"resource/pink-crane.png" //"resource/hablamemo-icon.png"
    }
    
  }

  transform: Rotation {
    id: rotation
    
    origin.x: card.width / 2
    origin.y: card.height / 2
    axis.x: 0; axis.y: 1; axis.z: 0
    angle: 0
  }

  transitions: Transition {
    NumberAnimation { target: rotation; property: "angle"; duration: 750 }
  }

  MouseArea {
    anchors.fill: parent
    enabled: card.dealCompleted && card.isBack && !card.isFound && items.selectionCount < 2
    onClicked: selected()
  }

  function selected() {
    card.isBack = false;
    card.isShown = true;
    items.selectionCount++;
    animationTimer.start();
  }
  
  
  function selectionReady() {
    Game.addPlayQueue(card);
    Game.reverseCardsIfNeeded();
  }
  
  Behavior on opacity { NumberAnimation { duration: 1000 } }

  states : [
    State {
      name: "front"
      PropertyChanges { target: rotation; angle: 180 }
      when: !card.isBack
    }
  ]
}
