#!/bin/bash

# This is a script for OMC Daily Scans

# Get CPU and memory utilization
cpu_util=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{print $0}')
mem_util=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

# Get space utilization
dirs=("/" "/home" "/boot" "/var" "/var/log"  "/var/tmp" "/var/log/audit")

root=$(df -h "${dirs[0]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}') 
home=$(df -h "${dirs[1]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}')
boot=$(df -h "${dirs[2]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}')
var=$(df -h "${dirs[3]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}')
logs=$(df -h "${dirs[4]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}')
tem=$(df -h "${dirs[5]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}')
#audit=$(df -h "${dirs[6]}" | awk '/[0-9]%/{gsub(/%/, "", $(NF-1)); print int($(NF-1))}')


# Zabbix agent availability
hostname="hostname"
status="zabbix-agent"

server=$($hostname)
#zabbix_agent=$(zabbix_agentd -t agent.ping | grep "OK")

# ================================================================================================

# show the date and formmat 
date=$(date +"%B %d, %Y")
format="%-15s %-10s\n"
line="==========================="

# Print column headers
printf "\n"
printf "OMC Daily Scans%s\n" " $date"
printf "$server\n\n" 

# CPU and mem utilization
printf "$format" "CPU" "$cpu_util"%""   
printf "$format\n" "Memory" "$mem_util"%""   
#printf "$format" "Status" "$status"          

# Space utilization
printf "$format\n" "Root"  "$root"%""                             
printf "$format\n" "Home"  "$home"%""                             
printf "$format\n" "Boot"  "$boot"%""                             
printf "$format\n" "Var"   "$var"%""                              
printf "$format\n" "log"   "$logs"%""                              
printf "$format\n" "Tem"   "$tem"%""                              
#printf "$format\n" "Audit" "$audit"%""                            

# ===============================================================

# Check disk space utilization
sizes=($root $home $boot $var $logs $tem)

for size in "${sizes[@]}"; do
    if [[ $size -ge 50 ]]; then
        echo "Please take a look at all diskwith size $size"
        break
    fi
done

#Check CPU and memory utilization
if [[ $cpu_util -ge 50 || $(echo "$mem_util >= 75" | bc -l) -eq 1 ]]; then
    echo "Please take a look at CPU or memory"
fi