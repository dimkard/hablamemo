#!/bin/sh
BASEDIR="../"			# root of translatable sources
BUGADDR="https://github.com/dimkard/package/"	# MSGID-Bugs
PROJECT="hablamemo"		# project name
WDIR=`pwd`			# working dir
 
 
echo "Preparing rc files"
cd ${BASEDIR}
# we use simple sorting to make sure the lines do not jump around too much from system to system
find . -name '*.rc' -o -name '*.ui' -o -name '*.kcfg' | sort > ${WDIR}/rcfiles.list
xargs --arg-file=${WDIR}/rcfiles.list extractrc > ${WDIR}/rc.cpp
# additional string for KAboutData
echo 'i18nc("NAME OF TRANSLATORS","Your names");' >> ${WDIR}/rc.cpp
echo 'i18nc("EMAIL OF TRANSLATORS","Your emails");' >> ${WDIR}/rc.cpp
intltool-extract --quiet --type=gettext/ini package/metadata.desktop.template
cat package/metadata.desktop.template.h >> ${WDIR}/rc.cpp
rm package/metadata.desktop.template.h
cd ${WDIR} 
echo "Done preparing rc files"

 
echo "Extracting messages"
cd ${BASEDIR}
# see above on sorting
find . -name '*.cpp' -o -name '*.h' -o -name '*.c' -o -name '*.qml' | sort > ${WDIR}/infiles.list
echo "rc.cpp" >> ${WDIR}/infiles.list
cd ${WDIR}
xgettext --from-code=UTF-8 -C -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 -ktr2i18n:1 \
	-kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kN_:1 -kaliasLocale -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
	--msgid-bugs-address=${BUGADDR} \
	--files-from=infiles.list -D ${BASEDIR} -D ${WDIR} -o plasma_applet_org.kde.${PROJECT}.pot || { echo "error while calling xgettext. aborting."; exit 1; }
echo "Done extracting messages"
 
 
echo "Merging translations"
catalogs=`find . -name '*.po'`
for cat in $catalogs; do
  echo $cat
  msgmerge -o $cat.new $cat plasma_applet_org.kde.${PROJECT}.pot
  mv $cat.new $cat
done
cd ${BASEDIR}
intltool-merge --quiet --desktop-style ${WDIR} package/metadata.desktop.template package/metadata.desktop
cd ${WDIR}	
echo "Done merging translations"
 
 
echo "Cleaning up"
cd ${WDIR}
rm rcfiles.list
rm infiles.list
rm rc.cpp
echo "Done"
