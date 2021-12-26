#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
source /home/coreboot/common_scripts/./variables.sh
source /home/coreboot/common_scripts/./download_coreboot.sh
source /home/coreboot/common_scripts/./config_and_make.sh


################################################################################
## MODEL VARIABLES
################################################################################
MAINBOARD="lenovo"
MODEL="t410"

STOCK_BIOS_ROM="stock_bios.bin"
VBIOS_ROM="vbios.bin"

BOOTSPLASH="bootsplash.jpg"

################################################################################

###############################################
##   download/git clone/git pull Coreboot    ##
###############################################
downloadOrUpdateCoreboot

#######################
##   build ifdtool   ##
#######################
if [ ! -f "$DOCKER_COREBOOT_DIR/util/ifdtool/ifdtool" ]; then
  # Make ifdtool
  cd "$DOCKER_COREBOOT_DIR/util/ifdtool" || exit
  make
  chmod +x ifdtool || exit
fi

###################################################################################
##  Extract Intel ME firmware, Gigabit Ethernet firmware, flash descriptor, etc  ##
###################################################################################
if [ ! -d "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" ]; then
  mkdir -p "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/"
fi


if [ ! -f "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/gbe.bin" ]; then
  cd "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" || exit

  cp "$DOCKER_COREBOOT_DIR/util/ifdtool/ifdtool" .

  # ALWAYS COPY THE ORIGINAL.  Never modified the original stock bios file
  cp "$DOCKER_STOCK_BIOS_DIR/$STOCK_BIOS_ROM" .

  # unlock, extract blobs and rename
  ./ifdtool -u "$STOCK_BIOS_ROM" || exit
  ./ifdtool -x "$STOCK_BIOS_ROM" || exit
  mv flashregion_0_flashdescriptor.bin descriptor.bin
  mv flashregion_2_intel_me.bin me.bin
  mv flashregion_3_gbe.bin gbe.bin
  
  ls -la .
  pwd

  # clean up
  rm ifdtool
  rm flashregion_1_bios.bin
fi

if [ -f "$DOCKER_SCRIPT_DIR/$BOOTSPLASH" ]; then
  cp "$DOCKER_SCRIPT_DIR/$BOOTSPLASH" "$DOCKER_COREBOOT_DIR/bootsplash.jpg"
  echo "Copied $BOOTSPLASH"
else
  echo "Missing $BOOTSPLASH"
fi

if [ -f "$DOCKER_STOCK_BIOS_DIR/$VBIOS_ROM" ]; then
  cp "$DOCKER_STOCK_BIOS_DIR/$VBIOS_ROM"  "$DOCKER_COREBOOT_DIR/vbios.bin"
  echo "Copied $VBIOS_ROM"
else
  echo "Missing $VBIOS_ROM"
fi


##############################
##   Copy config and make   ##
##############################
configAndMake

#####################
##   Post build    ##
#####################
if [ ! -f "$DOCKER_COREBOOT_DIR/build/coreboot.rom" ]; then
  echo "Uh oh. Things did not go according to plan."
  exit 1;
else
  mv "$DOCKER_COREBOOT_DIR/build/coreboot.rom" "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom"
  sha256sum "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom" > "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom.sha256"
fi
