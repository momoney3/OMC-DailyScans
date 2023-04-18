#!/bin/bash

# Ths is a script is for OMC Daily Scans

# Functions for utilisation of the servers

cpu_mem_utilization ()
{
    # Get CPU and memory utilization 
    cpu_util=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{print $0"%"}')
    mem_util=$(free | awk '/Mem/{printf("%.2f%"), $3/$2*100}')

    # Print CPU and memoru utilization
    echo "$cpu_util"
    echo "$mem_util"
}

# Get space utilization
space_utilization() {
    # create an array of directories to check disk space
    dirs=("/" "/home" "/boot" "/var" "/var/log" "/var/log/audit" "/var/tmp")

    # loop through the array and append the disk usage information to the result string
    result=""
    for dir in "${dirs[@]}"; do
        usage=$(df -h "${dir}" | awk '/[0-9]%/{print $(NF-1)}')
        result+="${dir} ${usage}\n"
    done

    # return the result string
    echo -e "$result"
}


# Zappix agent availability
hostname="hostname"
agent=dfkj 

server=$($hostname)
zabbix_agent=$(zabbix_agentd -t agent.ping)



# ================================================================================================
# Print column headers

date="$(date)"
format="%-10s %-10s %-10s\n"

# Date 
printf "OMC Daily Checks %s\n: $date"

# colom strocter
printf "s% $format" "Utilisatino"    "aec1-bigid"  "c1-bigid-dgaas"  "Zabbix Server"
printf "s% $format" "-----------"    "----------"  "--------------"  "-------------"

# Print data rows
printf "s% $format" "CPU" "           "$cpu_util"       ""                ""       "
printf "s% $format" "Memory"          "$mem_util"       ""                ""       "
printf "s% $format" "Staus"           "42"              "Me"              ""       "
printf "s% $format" "Cach Used"       "n/a"             "n/a"             ""       " 

# Space Utilization
printf "s% $format" "-----------"     "----------" "--------------" "-------------"

printf "s% $format" "root"                "31"          "Fle"           "df"
printf "s% $format" "boot"                "31"          "Fe"            "n/a"
printf "s% $format" "home"                "31"          "Fe"            "n/a"
printf "s% $format" "var/log"             "31"          "le"            "n/a"
printf "s% $format" "/log/autid"          "31"          "le"            "n/a"
printf "s% $format" "var/tmp"             "df"          "fd"            "n/a"

# Print table footer
printf "% $format" "-----------"      "----------"  "--------------"  "-------------"








