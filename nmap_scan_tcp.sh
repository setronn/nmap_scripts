#!/bin/bash

startTime=`date +%s`
RED='\033[0;31m'
NC='\033[0m'
dir=`echo $1 | tr '/' '-'` 

echo -e "${RED}Scanning: $2 (TCP). Start time: $(date +%T)${NC}"
nmap -Pn -p- $2 -n -oN scan_results/$dir/$2.tcp.tmp
ports=`cat scan_results/$dir/$2.tcp.tmp | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//`
echo -e "${RED}Found ports: ${ports}${NC}"
if [ ${#ports} != 0 ]; then
    sudo nmap -n -p$ports -A $2 -oN scan_results/$dir/$2.tcp
fi
echo -e "${RED}TCP scan is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)${NC}"