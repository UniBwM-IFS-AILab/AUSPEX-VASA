#!/bin/bash

echo "OBC type: $OBC_TYPE"

if [ -z "$OBC_TYPE" ]; then
  echo "error: OBC_TYPE is empty."
  exit 1
fi

if [ "$OBC_TYPE" == "DESKTOP" ]; then
    docker run \
    --mount type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX \
    --mount type=bind,source=/home/$USER/auspex_params,target=/root/auspex_params \
    --gpus all \
    --network host \
    --name vasa \
    --rm -d auspex_vasa tail -f /dev/null

elif [ "$OBC_TYPE" == "JETSON" ]; then
    docker run \
    --device /dev/video0 \
    --device /dev/media0 \
    --device /dev/media1 \
    --group-add video \
    --mount type=bind,source=/run/udev,target=/run/udev,readonly \
    --mount type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX \
    --mount type=bind,source=/home/$USER/auspex_params,target=/root/auspex_params \
    --network host \
    --privileged \
    --rm \
    --name vasa \
    -d auspex_vasa tail -f /dev/null

elif [ "$OBC_TYPE" == "PI" ]; then
    docker run \
    --device /dev/video0 \
    --device /dev/media0 \
    --device /dev/media1 \
    --group-add video \
    --mount type=bind,source=/run/udev,target=/run/udev,readonly \
    --mount type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX \
    --mount type=bind,source=/home/$USER/auspex_params,target=/root/auspex_params \
    --mount type=bind,source=/home/$USER/auspex-lituus,target=/root/auspex-lituus \
    --network host \
    --privileged \
    --rm \
    --name vasa \
    -d auspex_vasa tail -f /dev/null

else
  echo "unknown OBC type."
  exit 1
fi
