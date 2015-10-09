/* hablamemo - main.qml
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
import QtQuick.XmlListModel 2.0


MemoryGame {
    
  id:memorygame
      
  width: 800
  height: 600
  
  property string kvtmlFile: plasmoid.configuration.memoryfile //TODO: Review
  property variant texts: []
  property variant images: []

  dataset: 
  [
    { // Level 1
      columns: 3,
      rows: 2,
      images: memorygame.images,
      texts: memorygame.texts,
      hintTime: 3000
    },
    { // Level 2
      columns: 4,
      rows: 3,
      images: memorygame.images,
      texts: memorygame.texts,
      hintTime: 6000
    }
    ,
    { // Level 3
      columns: 4,
      rows: 4,
      images: memorygame.images,
      texts: memorygame.texts,
      hintTime: 10000
    }
  ]
    
  XmlListModel {
    id: xmlListModel
    
    source: memorygame.kvtmlFile
    query: "/kvtml/entries/entry"
    
    XmlRole { 
      name: "translation0" 
      query: "translation[@id='0']/text/string()" 
    }
    
    XmlRole { 
      name: "translation1" 
      query: "translation[@id='1']/text/string()" 
    }
    
    XmlRole { 
      name: "image0" 
      query: "translation[@id='0']/image/string()" 
    }
    
    XmlRole { 
      name: "image1" 
      query: "translation[@id='1']/image/string()" 
    }    
    
    onStatusChanged: {
      if (xmlListModel.status === XmlListModel.Ready) {
        var textsArray = [];
        for (var i = 0; i < xmlListModel.count; i++) {
          if(xmlListModel.get(i).translation0 !== "" && xmlListModel.get(i).translation1 !== "") {
            memorygame.texts.push([xmlListModel.get(i).translation0,xmlListModel.get(i).translation1]);
            memorygame.images.push([xmlListModel.get(i).image0,xmlListModel.get(i).image1]);
            console.log(i + ": " + texts[i][0] + " " + texts[i][1] + " - " + images[i][0] + " " + images[i][1]); 
          }
        }
      }
    }
  }
  onKvtmlFileChanged: {
    xmlListModel.reload();
  }
}