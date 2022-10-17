#!/bin/bash

ports=$(nmap -p- -Pn --min-rate=500 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
sudo nmap -p$ports -A $1 > $1.tcp

ports=$(nmap -sU -Pn $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
nmap -n -v -Pn -sV -sC -sU -p$ports $1 > $1.udp