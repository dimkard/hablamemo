#!/bin/bash
mkdir -p tempstuff/package/contents
#copy data
cp -R package/contents/* tempstuff/package/contents/
cp changelog.txt README LICENSE.GPL3 hablamemo-icon.svg package/metadata.desktop tempstuff/package/ 
#TODO: RECOVER icon

#create locale //TODO:RECOVER
#mkdir -p tempstuff/distrowatcher/contents/locale/el/LC_MESSAGES
#cp build/el.gmo tempstuff/distrowatcher/contents/locale/el/LC_MESSAGES/org.kde.distrowatcher.mo
#cp po/el.po tempstuff/distrowatcher/contents/locale/el/LC_MESSAGES/org.kde.distrowatcher.po
pushd tempstuff
zip -r ../hablamemo.plasmoid package/* 
popd
rm -rf tempstuff