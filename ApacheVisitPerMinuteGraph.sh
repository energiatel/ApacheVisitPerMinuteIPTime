#!/bin/bash

VISIT_PER_MINUTE=$(cat access_log.1 | cut -d "[" -f2 | cut -d "]" -f1 | awk '{print $1}' | awk -F ':' '{print $2":"$3}' | sort -k 1,2 | uniq -c)
MAX_VISIT_PER_MINUTE=0
LINEA=100

while read -r line; do
    max=$(echo $line | cut -d " " -f1)
    if [ "$max" -gt "$MAX_VISIT_PER_MINUTE" ]; then
        MAX_VISIT_PER_MINUTE=$max
    fi
done <<< "$VISIT_PER_MINUTE"


while read -r line; do
    current_val=$(echo $line | cut -d " " -f1)
    pin_num=$(echo $((($LINEA*$current_val)/$MAX_VISIT_PER_MINUTE)))
    pin_num_int=${pin_num/.*}
    pin=$(seq -s= $pin_num_int|tr -d '[:digit:]')
    echo -e "$line \t $pin"
done <<< "$VISIT_PER_MINUTE"
