#!/bin/bash
mkdir -p tempstuff/package/contents
#copy data
cp -R package/contents/* tempstuff/package/contents/
cp changelog.txt README LICENSE.GPL3 hablamemo-icon.svg package/metadata.desktop tempstuff/package/ 
#create locale
mkdir -p tempstuff/package/contents/locale/el/LC_MESSAGES
msgfmt po/el.po --output-file po/el.mo
cp po/el.mo tempstuff/package/contents/locale/el/LC_MESSAGES/plasma_applet_org.kde.hablamemo.mo
#cp po/el.po tempstuff/package/contents/locale/el/LC_MESSAGES/org.kde.hablamemo.po
pushd tempstuff
zip -r ../hablamemo.plasmoid package/* 
popd
rm -rf tempstuff