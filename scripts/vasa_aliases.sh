VASA_DIR="$AUSPEX_HOST_DIR/AUSPEX-VASA"

alias vasabash='docker exec -it $(docker ps -q --filter ancestor=auspex_vasa) /bin/bash'

alias invasa='docker exec -it $(docker ps -q --filter ancestor=auspex_vasa) /bin/bash -cil'

alias iv=invasa

alias killvasa='docker kill $(docker ps -q --filter ancestor=auspex_vasa)'

alias buildvasa='$VASA_DIR/scripts/build_vasa.sh'

alias rebuildvasa='$VASA_DIR/scripts/rebuild_vasa.sh'

alias runvasa='$VASA_DIR/scripts/run_vasa.sh'
