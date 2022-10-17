#!/bin/bash

startTime=`date +%s`
RED='\033[0;31m'
NC='\033[0m'
dir=`echo $1 | tr '/' '-'` 

echo -e "${RED}Scanning: $2 (TCP). Start time: $(date +%T)${NC}"
nmap -Pn -p- $2 -oN scan_results/$dir/$2.tcp.tmp
ports=`cat scan_results/$dir/$2.tcp.tmp | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//`
echo -e "${RED}Found ports: ${ports}${NC}"
if [ ${#ports} != 0 ]; then
    sudo nmap -p$ports -A $2 -oN scan_results/$dir/$2.tcp
fi
echo -e "${RED}TCP scan is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)${NC}"
echo ""
echo -e "${RED}======================================================================================${NC}"
echo ""
startTime=`date +%s`
echo -e "${RED}Scanning: $2 (UDP). Start time: $(date +%T)${NC}"
sudo nmap -sU -Pn $2 -oN scan_results/$dir/$2.udp.tmp
ports=`cat scan_results/$dir/$2.udp.tmp| grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//`
echo -e "${RED}Found ports: ${ports}${NC}"
if [ ${#ports} != 0 ]; then
    sudo nmap -n -v -Pn -sV -sC -oA udp-version -sU -p$ports -A $2 -oN scan_results/$dir/$2.udp
fi
echo -e "${RED}UDP scan is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)${NC}"