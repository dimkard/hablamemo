#!/bin/bash
rm hablamemo.plasmoid
plasmapkg2 --remove  ~/.local/share/plasma/plasmoids/org.kde.hablamemo/
./kNewHostStuff.sh
plasmapkg2 --install hablamemo.plasmoid 
plasmawindowed org.kde.hablamemo
