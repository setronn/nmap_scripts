#!/bin/bash
#1 agr - nmap ping scan range. Example: 10.10.0.0/24
#2 agr - Number of repeats 
rm scan_results/$dir/targets.tmp
dir=`echo $1 | tr '/' '-'` #x.x.x.x-mask
mkdir scan_results
mkdir scan_results/$dir 

for i in `seq $2`
do
    startTime=`date +%s`
    echo "Scan #$i: $1 (ping scan). Start time: $(date +%T)"
    nmap -sn -n $1 | grep "^Nmap scan report" | cut -d ' ' -f 5 | sed 's/$/ tcp:undone udp:undone/' >> scan_results/$dir/targets.tmp
    echo "Scan #$i is done after `date -d@$((\`date +%s\`-$startTime)) -u +%H:%M:%S` in $(date +%T)"
    if [ $i != $2 ]; then    #sleep between scans
        echo "Sleeping for 5s before the next lap"
        sleep 5
    fi
done
awk '!a[$0]++' scan_results/$dir/targets.tmp > scan_results/$dir/targets.list  #delete all duplicates
echo ""
echo "----------------------------------------------------------"
echo ""
echo "Result:"
cat scan_results/$dir/targets.list