#!/bin/bash

IPS=$(nmap -sL -n $1 | grep "Nmap scan report" | cut -d ' ' -f 5 | tr '\n' ' ')
IFS=' ' read -r -a ARRAY <<< "$IPS"

for IP in "${ARRAY[@]}"
do
    startTime=`date +%s`
    echo "Scanning: $IP. Start time: $(date +%T)"
    ports=$(nmap -Pn -p- --min-rate=500 $IP | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
    if [ ${#ports} != 0 ]; then
        rm $IP.tcp
        sudo nmap -p$ports -A $IP > $IP.tcp
    fi
    ports=$(sudo nmap -sU -Pn $IP | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
    if [ ${#ports} != 0 ]; then
        rm $IP.udp
        sudo nmap -n -v -Pn -sV -sC -oA udp-version -sU -p$ports -A $IP > $IP.udp
    fi
    echo "Scan is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)"
done