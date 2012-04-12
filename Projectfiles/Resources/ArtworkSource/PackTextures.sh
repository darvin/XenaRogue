#! /bin/sh

TP=/usr/local/bin/TexturePacker
#TP=~/Programming/TexturePacker/development/main-gui-build/source/app/TexturePacker.app/Contents/MacOS/TexturePacker

SRCROOT=../
SPRITES_ROOT=${SRCROOT}/ArtworkSource/_Sprites

LANDSCAPE_BASE_NAME=dungeon_landscape_tile_%d.png

if [ "${ACTION}" = "clean" ]
then
	echo "cleaning..."
	rm ${SRCROOT}/sheet.png
	rm ${SRCROOT}/sheet.plist	

	rm ${SRCROOT}/sheet-hd.png
	rm ${SRCROOT}/sheet-hd.plist
else
	echo "building..."


	#split landscape
	convert -crop 16x16 ${SRCROOT}/ArtworkSource/Landscape/dungeon.png ${SPRITES_ROOT}/${LANDSCAPE_BASE_NAME}

	# create hd assets
	${TP} --extrude 1  --smart-update ${SPRITES_ROOT}/*.png  \
          --format cocos2d \
          --data ${SRCROOT}/sheet.plist \
          --sheet ${SRCROOT}/sheet.png

	# create sd assets from same sprites
	# ${TP} --smart-update --scale  0.5 ${SRCROOT}/assets/*.png \
	 #          --format cocos2d \
	 #          --data ${SRCROOT}/resources/sheet.plist \
	 #          --sheet ${SRCROOT}/resources/sheet.png
fi
exit 0