#!/bin/bash

startTime=`date +%s`
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}Scanning: $1 (TCP). Start time: $(date +%T)${NC}"
nmap -Pn -p- $1 -n -oN scan_results/$1.tcp.tmp
ports=`cat scan_results/$1.tcp.tmp | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//`
echo -e "${RED}Found ports: ${ports}${NC}"
if [ ${#ports} != 0 ]; then
    sudo nmap -n -p$ports -A $1 -oN scan_results/$1.tcp
fi
echo -e "${RED}TCP scan is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)${NC}"
echo ""
echo -e "${RED}======================================================================================${NC}"
echo ""
startTime=`date +%s`
echo -e "${RED}Scanning: $1 (UDP). Start time: $(date +%T)${NC}"
sudo nmap -sU -Pn $1 -n -oN scan_results/$1.udp.tmp
ports=`cat scan_results/$1.udp.tmp| grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//`
echo -e "${RED}Found ports: ${ports}${NC}"
if [ ${#ports} != 0 ]; then
    sudo nmap -n -v -Pn -sV -sC -oA udp-version -sU -p$ports -A $1 -oN scan_results/$1.udp
fi
echo -e "${RED}UDP scan is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)${NC}"