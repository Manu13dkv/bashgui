#!/bin/bash

. bashgui.sh

monitor(){
    
    readarray -t ifaces< <( ifconfig | awk -F ':' '/^[a-z]/ {print $1}' )
    readarray -t ips< <( ifconfig | awk '/inet/ {print $2}' )
    readarray -t received< <( ifconfig | awk '/^\s*RX*...*B/ {print $6 $7}' | tr -d "(,)" )
    readarray -t transmited< <( ifconfig | awk '/^\s*TX*...*B/ {print $6 $7}' | tr -d "(,)" )

    clear
    frame 90 15 

    printxy 38 3 "Network Monitor"
    hseparator 90 4

    fieldtitles=( interfaces ipaddr received transmited )

    table 11 7 4 20 2 "${fieldtitles[@]}"
    printfrom 11 11 "${ifaces[@]}"
    printfrom 31 11 "${ips[@]}"
    printfrom 51 11 "${received[@]}"
    printfrom 71 11 "${transmited[@]}"

	
    hseparator 90 8


}

while [ ! "$key" == "q" ]
do
    monitor
    sleep 2
done

clear





