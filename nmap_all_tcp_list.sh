#!/bin/bash

dir=`echo $1 | tr '/' '-'` 

while read NAME
do
    IP=`echo $NAME | cut -d ' ' -f 1`
    nmap -p- -Pn --min-rate=500 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//
done < scan_results/$dir/targets.list