#!/bin/bash

# Accept the threshold value in minutes and convert it to seconds
read -p "Enter the threshold value in minutes of runtime: " threshold
threshold_sec=$((threshold * 60))

temp_i="/home/blaze/kavithesh/onsite2/temp_i.txt"
temp_f="/home/blaze/kavithesh/onsite2/temp_f.txt"

# Capture docker ps output
docker ps &> "$temp_i"

# Skip the header and save it to temp_f
tail +2 "$temp_i" > "$temp_f"

# Process each line in the temp_f file
while read -r line; do
    container_id=$(echo "$line" | awk '{print $1}')
    img=$(echo "$line" | awk '{print $2}')
    cmd=$(echo "$line" | awk '{print $3}')
    cr_time=$(echo "$line" | awk '{print $4 " " $5}')
    status=$(echo "$line" | awk '{print $7}')
    runtime_val=$(echo "$line" | awk '{print $8}')
    runtime_unit=$(echo "$line" | awk '{print $9}')

    # Convert runtime to seconds
    if [[ $runtime_unit == "seconds" ]]; then
        continue
    elif [[ $runtime_unit == "minutes" ]]; then
        runtime_val=$((runtime_val * 60))
    elif [[ $runtime_unit == "hours" ]]; then
        runtime_val=$((runtime_val * 3600))
    else
        echo "Unknown runtime unit: $runtime_unit"
        continue
    fi
    
    container_name=$(echo "$line" | awk '{print $10}')
    #network_name=$(docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{$key}} {{end}}' "$container_id")
    network_name=$(docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{$key}} {{end}}' "$container_id" | xargs)

    
    echo "Container ID: $container_id"
    echo "Image: $img"
    echo "Command: $cmd"
    echo "Creation Time: $cr_time"
    echo "Status: $status"
    echo "Runtime: $runtime_val seconds"
    echo "Container Name: $container_name"
    echo "network name is : $network_name*"

    echo "************************************************************"

done < "$temp_f"
echo "network name is : $network_name"

# Get the names of containers in the same network
container_names_in_network=$(docker network inspect "$network_name" --format='{{range .Containers}}{{.Name}} {{end}}')
#container_names_in_network=$(docker network inspect "bridge" --format='{{range .Containers}}{{.Name}} {{end}}')

related_container_ids=""

for c_name in $container_names_in_network; do
    ids=$(docker ps -q -f name="$c_name")
    related_container_ids+="$ids "
done

# Initialize the all_old flag
all_old=true

# Function to get the uptime of a container
get_container_uptime() {
    local container_id="$1"
    local start_time=$(docker inspect --format='{{.State.StartedAt}}' "$container_id")
    local start_time_epoch=$(date -d "$start_time" +%s)
    local current_time_epoch=$(date +%s)
    local uptime_seconds=$((current_time_epoch - start_time_epoch))
    echo "$uptime_seconds"
}

# Check if all containers have been running longer than the threshold
for c_id in $related_container_ids; do
    c_uptime=$(get_container_uptime "$c_id")
    echo "Uptime for container $c_id: $c_uptime seconds"
    
    if [ "$c_uptime" -lt "$threshold_sec" ]; then
        all_old=false
        break
    fi
done

# Kill all containers if they are all old
if $all_old; then
    echo "All containers are old. Killing them..."
    for c_id in $related_container_ids; do
        docker kill "$c_id"
        echo "Killed container $c_id"
    done
else
    echo "Not all containers are old. Keeping them running."
fi
