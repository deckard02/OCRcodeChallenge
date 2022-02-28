#!/bin/bash
echo checking for run-away process ...
IS_CPU_OVERLOADED=false
while :
do
	CPU_USAGE=$(uptime | cut -d"," -f4 | cut -d":" -f2 | cut -d" " -f2 | sed -e "s/\.//g")
	CPU_USAGE_THRESHOLD=800 #80%
	TOPPROCESS=$(ps -eo pid,pcpu,command --no-headers | sort -nrk 2 | head -n 1)
	#echo CPU USAGE is at $((10#CPU_USAGE + 1))
	#echo Top-most process $TOPPROCESS

	if [[ $((10#$CPU_USAGE + 1)) -gt ${CPU_USAGE_THRESHOLD} ]] 
	then
		if [["$IS_CPU_OVERLOADED" = false ]]
		then
			echo $(date) system overloaded!	Top process $TOPPROCESS CPU USAGE is at $CPU_USAGE
			IS_CPU_OVERLOADED=true
			#kill -9 $(ps -eo pid | sort -k 1 -r | grep -v PID | head -n 1) #original
  			#kill -9 $(ps -eo pcpu | sort -k 1 -r | grep -v %CPU | head -n 1)
  			#kill -9 $TOPPROCESS
		fi
	else
		if [[ "$IS_CPU_OVERLOADED" = true ]]
		then
			echo $(date) system NO LONGER overloaded.	Top process $TOPPROCESS CPU USAGE is at $CPU_USAGE
			IS_CPU_OVERLOADED=false
		fi
	fi
	sleep 1;
done