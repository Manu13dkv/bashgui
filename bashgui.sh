#
# Author : Manuel Dominguez Montero
#
# Library for simple shell graphic elements
# 
#=========================================================


# Draws a frame to print into.
# 
# Usage:
#
#  frame width height
#
# ---------------------------------
frame(){

	width="${1:-$dfwidth}"
	height="${2:-$dfheight}"

	dfwidth=50
	dfheight=30

	for i in $(seq -1 $width)
	do
		echo -n "="
	done

	echo

	for i in $(seq 1 $height)
	do
		printf '|%'"$width"'s|\n' ""
	done

	for i in $(seq -1 $width)
	do
		echo -n "="
	done

	echo

}


# Prints a string on a given position
#
# Usage:
#
# printxy x y content
#
# ------------------------------------
printxy(){

	echo -e "\e[s"
	df_x=4
	df_y=4
	content=$3

	x="${1:-$df_x}"
	y="${2:-$df_y}"
	
	echo -e "\e[""$y"";""$x"H $content 
		
	echo -e "\e[u"
}


# Prints a column of elements
# from a given array.
#
# Usage:
# 
# printfrom x y content 
#
# ---------------------------------
printfrom(){
	
	echo -e "\e[s"

	x=$1
	y=$2		
	
	shift 2
	
	content=("$@")

	printf "\e[%s;%sH" "$y" "$x"

	for index in $(seq 0 ${#content[*]})
	do	
		printf "%-s" ${content[index]}	
		printf "\e[%s;%sH" "$((++y))" "$x"  
	done
	
	printf "\e[u"
}


# Horizontal separator
#
# Usage:
# 
# hseparator width ypos
#
# ---------------------------------
hseparator(){

	width=$1
	ypos=$2
	
	echo -e "\e[s"
	echo -e "\e[""$ypos"";"1f

	for i in $(seq -1 $width)
	do
		echo -n  "="
	done

	echo -e "\e[u"

}


# Draws a table with n elements per line
# on a given position.
#
# Usage:
#
# table x y operline xspacing yspacing elements
#
# ----------------------------------------
table(){

	declare -A position
	position[x]=$1
	position[y]=$2	
	operline=$3
	xspacing=$4
	yspacing=$5

	shift 5

	options=("$@")
	
	printf "\e[s"

	printf  "\e[%s;%sH" "${position[y]}" "${position[x]}"	

	counter=0
	for option in $(seq 0 ${#options[*]})
	do
		printf "%-"$xspacing"s" ${options[option]}	
		[[ "$((++counter))" -eq "$operline" ]] && 	
		{ printf "\e[%s;%sH" "$((position[y]+=yspacing))" "${position[x]}"  ; counter=0;} 
	done	
	
	printf "\e[u"
	

}


# Draws a table of elements from a given array
# and place a selector over.
# 
# Use AWSD keys to move among options
# and confirm with E.
# 
# the returned value is placed 
# into "selected" variable.
#
# Usage:
#
# selector x y operline xspacing yspacing selected elements
#
# ----------------------------------------------------------
selector(){

	declare -A position
	position[x]=$1
	position[y]=$2	
	operline=$3
	xspacing=$4
	yspacing=$5

	local selected=$6

	shift 6

	options=("$@")

	xbound=$(( (xspacing*operline) +  
				position[x] - xspacing ))
	
	ybound=$((yspacing *( ( ${#options[*]} / operline ) + 
			  ( ${#options[*]} % operline > 0 ) ) + position[y] - yspacing))
	
	xor=${position[x]}
	yor=${position[y]}

	printf "\e[s"
	printf "\e[%s;%sH" "${position[y]}" "${position[x]}"
		
	table "${position[x]}" "${position[y]}" \
			"$operline" "$xspacing" "$yspacing" \
			"${options[@]}"
		
	while [ "$key" != "q" ]
	do
		read -sn1 key
			
		case $key in	
			a)
				[[ "${position[x]}" -gt "$xor" ]] &&
				((position[x]-=xspacing))
			;;

			d)
				
				[[ "${position[x]}" -lt "$xbound" ]] &&
				((position[x]+=xspacing))
			;;
	
			w)
				[[ "${position[y]}" -gt "$yor" ]] &&
				((position[y]-=yspacing))
			;;

			s)
				[[ "${position[y]}" -lt "$ybound" ]] &&
				((position[y]+=yspacing))
			;;	
			
			e)
				[[  
					$(( xcoord=( ( (position[x]-xor)/xspacing ) + 
						( (position[x]-xor) % xspacing > 0 ) + 1  )  )) -eq "0" ]] &&
				xcoord=1
	
				[[ $(( ycoord=( ( (position[y]-yor)/yspacing ) + 
						( (position[y]-yor) % yspacing > 0 ) + 1  )  )) -eq "0" ]] &&
				ycoord=1
	
				element=$(( (ycoord-1)*operline + xcoord -1 )) 

				eval $selected="'${options[element]}'"
				printf "\e[u"
				return 0
			;;
		esac	
		printf "\e[%s;%sH" "${position[y]}" "${position[x]}"
	done
	
	printf "\e[u"
}
