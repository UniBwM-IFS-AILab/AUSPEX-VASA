#!/bin/bash -i
# Run multiple instances of the 'px4' binary, without starting the simulator.
# Reads platform_id from JSON and names instances accordingly.

# Number of PX4 instances
sitl_num=2
[ -n "$1" ] && sitl_num="$1"

# JSON file path
JSON_FILE="$HOME/auspex_params/platform_properties/sim_platform_properties.json"

PLATFORM_ID=$(jq -r '.platform_id' "$JSON_FILE")

# Check if platform_id is empty
if [ -z "$PLATFORM_ID" ]; then
    echo "Error: platform_id not found in JSON!"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
src_path="$SCRIPT_DIR/../../"
build_path=${src_path}/build/px4_sitl_default

echo "killing running instances"
pkill -x px4 || true

sleep 1

export PX4_SIM_MODEL=none_iris

n=0
while [ $n -lt $sitl_num ]; do
    # Create a unique name using platform_id + instance number
    INSTANCE_NAME="${PLATFORM_ID}_${n}"

	working_dir="$build_path/instance_$n"
	[ ! -d "$working_dir" ] && mkdir -p "$working_dir"

	pushd "$working_dir" &>/dev/null
    echo "Starting instance $n: $INSTANCE_NAME in $(pwd)"

	export PX4_UXRCE_DDS_NS=$INSTANCE_NAME
	$build_path/bin/px4 -i $n -d "$build_path/etc" -s etc/init.d-posix/rcS&>/dev/null&
	popd &>/dev/null

	n=$(($n + 1))
done
