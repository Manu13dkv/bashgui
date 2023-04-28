# Bash-Gui
Function library for graphic elements to use in bash scripting.

## Motivation

To ease data presentation in shell scripting
with some common elements like:

- Columns of data.
- Tables
- Separators
- Selectors

# Features

## Frame

Draws a frame to print into.
 
#### Usage:

```frame width height```

## Printxy

Prints a string on a given position

#### Usage:

```printxy x y content``` 

## Printfrom

Prints a column of elements
from a given array.

#### usage:

```printfrom x y content```

## Horizontal separator

#### Usage:

```hseparator width ypos```

## Table

Draws a table with n elements per line
on a given position.

#### Usage:


```table x y operline xspacing yspacing elements```

## Selector

Draws a table of elements from a given array
and place a selector over.
 
Use AWSD keys to move among options
and confirm with E.
 
the returned value is placed 
into "selected" variable.

#### Usage:

```selector x y operline xspacing yspacing selected elements```

## Examples

### NetMonitor

In this example I just extracted network information about my system 
and introduced it inside some arrays.

Then I use the previous functions to set an infinite loop
in order to make a simply kind of network's parameters monitor.

```shell

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

```

## Output

```
$
============================================================================================
|                                                                                          |
|                                     Network Monitor                                      |
|                                                                                          |
============================================================================================
|                                                                                          |
|         interfaces          ipaddr              received            transmited           |
|                                                                                          |
============================================================================================
|                                                                                          |
|         eth0                10.0.2.15           203.9MiB            2.5MiB               |
|         lo                  127.0.0.1           3.2KiB              3.2KiB               |
|         vmnet1              172.16.182.1        0.0B                0.0B                 |
|         vmnet8              192.168.117.1       0.0B                0.0B                 |
|                                                                                          |
|                                                                                          |
============================================================================================
```
