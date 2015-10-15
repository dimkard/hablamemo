/* gcompris, hablamemo - memory.js
 *
 * Copyright (C) 2014 JB BUTET
 * Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com>
 * 
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *   Dimitris Kardarakos <dimkard@gmail.com> (Adaptation to Hablamemo needs)
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
.pragma library
.import QtQuick 2.4 as Quick //TODO: Review

var items;
var currentLevel = 0;
var numberOfLevel;
var nbOfPair;
var cardLeft;
var cardList;

function start(items_) {
  items = items_;
  items.numOfTries = 0;
  items.playerScore = 0;
  items.gameCompleted = false;
  numberOfLevel = items.dataset.length;
  initLevel();    
}

function stop() {
}

function initLevel() {
  items.containerModel.clear();
  items.playQueue = [];
  items.selectionCount = 0;

  // compute the number of cards
  var columns = items.dataset[currentLevel].columns;
  var rows = items.dataset[currentLevel].rows;
  var images = items.dataset[currentLevel].images;
  var sounds = items.dataset[currentLevel].sounds;
  var texts = items.dataset[currentLevel].texts;
  items.columns = columns;
  items.rows = rows;
  nbOfPair = rows * columns / 2;
  cardLeft = nbOfPair * 2;

  // Check the provided dataset has enough data
  var maxData = Math.max(
                          images ? images.length : 0,
                          sounds ? sounds.length : 0,
                          texts ? texts.length : 0);

  if(rows * columns > maxData) {
    console.log("ERROR: Memory dataset does not have enough data pairs at level ", currentLevel + 1);
    return
  }

  // Create a list of indexes for the shuffling
  // This way we can keep the 3 lists in sync
  var shuffleIds = []
  for(var i = 0;  i < maxData; ++i) {
    shuffleIds.push(i);
  }
  shuffle(shuffleIds);

  // place randomly a level-defined number of pairs
  cardList = []
  for(var ix = 0;  ix < nbOfPair; ++ix) {
    // select a random item
    for(var j = 0; j < 2; ++j) {
      cardList.push( {
                    image: images ? images[shuffleIds[ix]][j] : "",
                    sound: sounds ? sounds[shuffleIds[ix]][j] : "",
                    text: texts ? texts[shuffleIds[ix]][j] : "",
                    matchCode: ix,
            } );
    }
  }

  cardList = shuffle(cardList)

  // fill the model
  for(i = 0;  i < cardList.length; ++i) {
          items.containerModel.append( { pairData_: cardList[i] } );
  }

  //memory hint
  var cardItem1;
  for(var j = 0;  j < cardList.length; ++j) { 
    cardItem1 = items.cardRepeater.itemAt(j);
    cardItem1.hintInterval = items.dataset[currentLevel].hintTime;
    cardItem1.memoryHintTimer.start();
  }     
}

// Return a pair of cards that have already been shown
function getShownPair() {
  for(var i = 0;  i < nbOfPair * 2; ++i) {
    var cardItem1 = items.cardRepeater.itemAt(i);
    for(var j = 0;  j < nbOfPair * 2; ++j) {
      var cardItem2 = items.cardRepeater.itemAt(j);
      if(i != j && !cardItem1.isFound && cardItem1.isShown && !cardItem2.isFound && cardItem2.isShown && (cardItem1.pairData.matchCode === cardItem2.pairData.matchCode) ) {
        return [cardItem1, cardItem2];
      }
    }
  }
  return
}

function reverseCardsIfNeeded() {
  if(items.playQueue.length >= 2) {
    items.numOfTries = items.numOfTries + 1; //to count total score
    items.selectionCount = 0;
    var item1 = items.playQueue.shift();
    var item2 = items.playQueue.shift();

    if (item1.card.pairData.matchCode === item2.card.pairData.matchCode) {
      // the 2 cards are the same
      item1.card.isBack = false; // stay faced
      item1.card.isFound = true; // signal for hidden state
      item2.card.isBack = false;
      item2.card.isFound = true;
      cardLeft = cardLeft - 2;
      items.playerScore++;

      if(cardLeft === 0) { // no more cards in the level
        youWon();          
      }
    } 
    else {
      // pictures clicked are not the same
      item1.card.isBack = true;
      item2.card.isBack = true;
    }
  }
}

//To be executed upon game completion
function youWon() {
  items.gameCompleted = true;
}

//Go one level forward
function nextLevel() {
  if(numberOfLevel <= ++currentLevel ) {
    currentLevel = numberOfLevel-1;
  }
  initLevel();
}

//Go one level back
function previousLevel() {
  if(--currentLevel < 0) {
    currentLevel = 0;
  }
  initLevel();
}

//Set game level
function setLevel(userLevel) {
  if(userLevel>= 0) {
    currentLevel = userLevel;
  }
}

// Return true is we have enough to make a pair
function addPlayQueue(card) {
  items.playQueue.push({'card': card });
  return items.playQueue.length >= 2;
}


//Shuffle the array items and return it.
function shuffle(o) {
  for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
  return o;
}
