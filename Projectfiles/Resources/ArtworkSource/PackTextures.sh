#! /bin/sh

TP=/usr/local/bin/TexturePacker
#TP=~/Programming/TexturePacker/development/main-gui-build/source/app/TexturePacker.app/Contents/MacOS/TexturePacker

SRCROOT=`pwd`/..
SPRITES_ROOT_16=${SRCROOT}/ArtworkSource/_Sprites_16
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
	rm -Rf ${SPRITES_ROOT_16}
	rm -Rf ${SPRITES_ROOT}
	mkdir ${SPRITES_ROOT_16}
	mkdir ${SPRITES_ROOT}
	
	#split landscape
	convert -crop 16x16 ${SRCROOT}/ArtworkSource/Landscape/dungeon.png ${SPRITES_ROOT_16}/${LANDSCAPE_BASE_NAME}
	cp ${SRCROOT}/ArtworkSource/Characters/Sliced/*.png ${SPRITES_ROOT_16}/
	cp ${SRCROOT}/ArtworkSource/Icons/IncludedIcons/*.png ${SPRITES_ROOT}/
	
	cd ${SRCROOT}/ArtworkSource/Characters/
	python flip_characters.py
	
	cd ${SRCROOT}/ArtworkSource/
	python resize_16_to_32.py
	
	echo "started spritesheet assembly..."
	# create hd assets
	${TP} --extrude 1  --smart-update ${SPRITES_ROOT}/*.png  \
          --format cocos2d \
          --data ${SRCROOT}/sheet.plist \
          --sheet ${SRCROOT}/sheet.png \
		  --disable-rotation

	# create sd assets from same sprites
	# ${TP} --smart-update --scale  0.5 ${SRCROOT}/assets/*.png \
	 #          --format cocos2d \
	 #          --data ${SRCROOT}/resources/sheet.plist \
	 #          --sheet ${SRCROOT}/resources/sheet.png
fi
exit 0