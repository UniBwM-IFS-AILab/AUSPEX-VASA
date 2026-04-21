#!/usr/bin/env bash

echo "OBC_TYPE: $OBC_TYPE"
echo "PLATFORM_NAME: $PLATFORM_NAME"

if [[ -z "$OBC_TYPE" ]]; then
  echo "error: OBC_TYPE is empty."
  exit 1
fi

docker_cmd=(
  docker run
  --mount "type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX"
  --network host
  --privileged
  --rm
  --name vas_primum
  -it
)

camera_args=(
  --device /dev/video0
  --device /dev/media0
  --device /dev/media1
  --group-add video
  --mount "type=bind,source=/run/udev,target=/run/udev,readonly"
  --mount "type=bind,source=/dev/dma_heap,target=/dev/dma_heap"
)

if [[ "$OBC_TYPE" != "DESKTOP" ]]; then
  if [[ -n "$CAM_TYPE" ]]; then
    docker_cmd+=("${camera_args[@]}")
  fi
fi

docker_cmd+=(auspex_vasa)

"${docker_cmd[@]}"