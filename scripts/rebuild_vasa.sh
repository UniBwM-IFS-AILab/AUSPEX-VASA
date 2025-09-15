#!/bin/bash

echo "OBC type: $OBC_TYPE"

if [ -z "$OBC_TYPE" ]; then
  echo "error: OBC type is empty."
  exit 1
fi

if [ "$OBC_TYPE" == "DESKTOP" ]; then
    cd $AUSPEX_HOST_DIR/AUSPEX-VASA/terra/
    sudo docker build --no-cache -t auspex_vasa .

elif [ "$OBC_TYPE" == "JETSON" ]; then
    cd $AUSPEX_HOST_DIR/AUSPEX-VASA/avis_jetson/
    sudo docker build --no-cache -t auspex_vasa .

elif [ "$OBC_TYPE" == "PI" ]; then
    cd $AUSPEX_HOST_DIR/AUSPEX-VASA/avis_pi/
    sudo docker build --no-cache -t auspex_vasa .

else
  echo "unknown OBC type."
  exit 1
fi
