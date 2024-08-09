#!/bin/bash

read -p "enter the threshold value in minutes of runtime:" threshold
#how am i gonna accept threshold values? minutes/seconds/ ,gave minutes 
temp_i="/home/blaze/kavithesh/onsite2/temp_i.txt"
temp_f="/home/blaze/kavithesh/onsite2/temp_f.txt"
threshold_sec=$(($threshold*60))

#echo "$(docker ps)" &> temp_i.txt
docker ps &> "$temp_i"

tail +2 "$temp_i" > "$temp_f"


# Process each line in the temp_f file
while read -r line; do
    # Extract fields using awk
    container_id=$(echo "$line" | awk '{print $1}')
    img=$(echo "$line" | awk '{print $2}')
    cmd=$(echo "$line" | awk '{print $3}')
    cr_time=$(echo "$line" | awk '{print $4 " " $5}')  # Grabbing the time and the unit (seconds, minutes)
    status=$(echo "$line" | awk '{print $7}')
    runtime_val=$(echo "$line" | awk '{print $8}')
    runtime_unit=$(echo "$line" | awk '{print $9}')

    if [[ $runtime_unit == "seconds" ]]; then
        continue
    elif [[ $runtime_unit == "minutes" ]]; then
        runtime_val=$((runtime_val * 60))
    elif [[ $runtime_unit == "hours" ]]; then
        runtime_val=$((runtime_val*3600))
    else
        echo "Unknown runtime unit: $runtime_unit"
        continue
    fi
    
    container_name=$(echo "$line" | awk '{print $10}')
    #the below will work when the container is part of a single network,
    network_name="$(docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{$key}} {{end}}' $container_id)"
    
    echo "Container ID: $container_id"
    echo "Image: $img"
    echo "Command: $cmd"
    echo "Creation Time: $cr_time"
    echo "Status: $status"
    echo "runtime: $runtime"
    echo "Container Name: $container_name"
    echo "************************************************************"

done < "$temp_f"

#gets you the containers names that are part of the network given network name or id
#docker network inspect "$network_name_or_id" --format='{{range .Containers}}{{.Name}} {{end}}')


container_names_in_network=$(docker network inspect "$network_name" --format='{{range .Containers}}{{.Name}} {{end}}')
for c_name in $container_names_in_network; do
    ids=$(docker ps -q -f name="$c_name")
    related_container_ids+="$ids "
done
echo "$related_container_ids"

#now all i have to do is : check if the container's run time > threshold , for all containers in the network
#if all containers are old , then kill all of them

get_container_uptime() {
    local container_id="$1"
    local start_time=$(docker inspect --format='{{.State.StartedAt}}' "$container_id")
    local start_time_epoch=$(date -d "$start_time" +%s)
    local current_time_epoch=$(date +%s)
    local uptime_seconds=$((current_time_epoch - start_time_epoch))
    echo "$uptime_seconds"
}

related_c_uptimes=""
for c_id in $related_container_ids; do
    c_uptime="$(get_container_uptime "$c_id")"
    echo "Uptime for container $c_id: $c_uptime seconds"
    if [ "$c_uptime" -lt "$threshold_sec" ]; then
        all_old=false
        break
    fi
done

if $all_old; then
    echo "All containers are old. Killing them..."
    for c_id in $related_container_ids; do
        docker kill "$c_id"
        echo "Killed container $c_id"
    done
else
    echo "Not all containers are old. Keeping them running."
fi


#related_c_uptimes+="$c_uptime "
