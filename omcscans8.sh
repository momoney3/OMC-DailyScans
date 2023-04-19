#!/bin/bash

# This is a script for OMC Daily Scans

# Function to get CPU and memory utilization
cpu_mem_utilization() {
    # Get CPU and memory utilization
    cpu_util=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{print $0"%"}')
    mem_util=$(free | awk '/Mem/{printf("%.2f%"), $3/$2*100}')

    # Print CPU and memory utilization
    echo "$cpu_util"
    echo "$mem_util"
}

# Function to get space utilization
space_utilization() {
    # Create an array of directories to check disk space
    dirs=("/" "/home" "/boot" "/var" "/var/log"  "/var/tmp")
    #"/var/log/audit"

    # Loop through the array and append the disk usage information to the result string
    result=""
    for dir in "${dirs[@]}"; do
        usage=$(df -h "${dir}" | awk '/[0-9]%/{print $(NF-1)}')
        result+="${dir} ${usage}\n"
    done

    # Return the result string
    echo -e "$result"
}

# ================================================================================================
# Print column headers

date=$(date +"%A, %B %d, %Y")
format="%-15s %-10s\n"

printf "OMC Daily Scans%s\n\n" "$date"

printf "$format" "CPU" "$cpu_util"   
printf "$format" "Memory" "$mem_util"   
printf "$format" "Status" ""          
printf "$format\n" "Cache Used" "n/a"       

printf "$format\n" "Space Utilization"
space_utilization