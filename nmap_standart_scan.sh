#!/bin/bash
ports=$(nmap -p- -Pn --min-rate=500 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
sudo nmap -p$ports -A $1 > $1.tcp

ports=$(sudo nmap -sU -Pn $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
sudo nmap -n -v -Pn -sV -sC -oA udp-version -sU -p$ports -A > $1.udp