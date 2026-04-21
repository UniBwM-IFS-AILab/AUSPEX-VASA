#!/usr/bin/env bash

VASA_DIR="$AUSPEX_HOST_DIR/AUSPEX-VASA"

alias vasa_attach='docker exec -it vas_primum /bin/bash'

alias vasa_cmd='docker exec -it vas_primum /bin/bash -cil'

alias vasa_kill='docker kill vas_primum'

alias vasa_build='$VASA_DIR/scripts/vasa_build.sh'

alias vasa_rebuild='$VASA_DIR/scripts/vasa_rebuild.sh'

alias vasa_run='$VASA_DIR/scripts/vasa_run.sh'

vasa_shell() {
  if [ -n "$(docker ps -q -f name=^/vas_primum$)" ]; then
    vasa_attach
  else
    vasa_run
  fi
}
