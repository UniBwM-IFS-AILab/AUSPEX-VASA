#!/bin/bash -i
# Run multiple instances of the 'px4' binary, without starting the simulator.
# Reads platform_id from JSON and names instances accordingly.

# Number of PX4 instances
sitl_num=2
[ -n "$1" ] && sitl_num="$1"

# JSON file path
JSON_FILE="$HOME/auspex_params/platform_properties/platform_properties.json"

PLATFORM_ID=$(jq -r '.platform_id' "$JSON_FILE")

# Check if platform_id is empty
if [ -z "$PLATFORM_ID" ]; then
    echo "Error: platform_id not found in JSON!"
    exit 1
fi


build_path=${HOME}/PX4-Autopilot/build/px4_sitl_default

echo "killing running instances"
pkill -x px4 || true

sleep 1

export PX4_SIM_MODEL=none_iris
rcS_file="$build_path/etc/init.d-posix/rcS"
if [ ! -f "$rcS_file" ]; then
    echo "Error: rcS file not found at $rcS_file"
    exit 1
fi

# Overwrite params:
param_commands=(
  "param set-default EKF2_MAG_TYPE 0"
  "param set-default EKF2_REQ_GPS_H 3.0"
  "param set-default COM_ARM_MAG_STR 0"
  "param set-default UXRCE_DDS_SYNCT 0"
)

for param_command in "${param_commands[@]}"; do
  # Extract just the identifier (e.g., EKF2_MAG_TYPE)
  param_key=$(echo "$param_command" | awk '{print $3}')

  if grep -q "^param set-default $param_key" "$rcS_file"; then
    # Replace the existing line
    sed -i "s|^param set-default $param_key.*|$param_command|" "$rcS_file"
  else
    # Insert the command after the first occurrence of 'param set-default'
    sed -i "0,/^param set-default/ s|\(^param set-default.*\)|\1\n$param_command|" "$rcS_file"
  fi
done

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
