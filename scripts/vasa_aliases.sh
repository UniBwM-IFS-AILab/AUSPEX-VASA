vasa_dir="$HOME/AUSPEX-VASA"

alias run_terra_vasa="docker run \
    --mount type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX \
    --mount type=bind,source=/home/$USER/auspex_params,target=/root/auspex_params \
    --mount type=bind,source=/home/$USER/MENTHON-WS,target=/root/MENTHON-WS \
    --network host \
    --rm -it auspex_vasa"

alias run_avis_pi_vasa="docker run \
    --device /dev/video0 \
    --device /dev/media0 \
    --device /dev/media1 \
    --group-add video \
    --mount type=bind,source=/run/udev,target=/run/udev,readonly \
    --mount type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX \
    --mount type=bind,source=/home/$USER/auspex_params,target=/root/auspex_params \
    --mount type=bind,source=/home/$USER/MENTHON-WS,target=/root/MENTHON-WS \
    --network host \
    --privileged \
    --rm \
    -it auspex_vasa"

alias run_avis_jetson_vasa="docker run \
    --device /dev/video0 \
    --device /dev/media0 \
    --device /dev/media1 \
    --group-add video \
    --mount type=bind,source=/run/udev,target=/run/udev,readonly \
    --mount type=bind,source=/home/$USER/AUSPEX,target=/root/AUSPEX \
    --mount type=bind,source=/home/$USER/auspex_params,target=/root/auspex_params \
    --mount type=bind,source=/home/$USER/MENTHON-WS,target=/root/MENTHON-WS \
    --network host \
    --privileged \
    --rm \
    -it auspex_vasa"

alias vasabash='docker exec -it $(docker ps -q --filter ancestor=auspex_vasa) /bin/bash'

alias invasa='docker exec -it $(docker ps -q --filter ancestor=auspex_vasa) /bin/bash -cil'

alias iv=invasa

alias killvasa='docker kill $(docker ps -q --filter ancestor=auspex_vasa)'

alias buildvasa='sudo docker build . -t auspex_vasa'

alias build_terra_vasa="cd $AUSPEX_HOST_DIR/AUSPEX-VASA/terra/ && buildvasa"
alias build_pi_vasa="cd $AUSPEX_HOST_DIR/AUSPEX-VASA/avis_pi/ && buildvasa"
alias build_jetson_vasa="cd $AUSPEX_HOST_DIR/AUSPEX-VASA/avis_jetson/ && buildvasa"
