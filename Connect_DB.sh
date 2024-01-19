#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C

directory_list=($(ls -F | grep / | sed 's/\/$//'))
if [ -z "$directory_list" ]
	then
        echo "There Are No Databases to Connect."
	else

PS3="Select a Database To Connect: "

# Create a menu using select
select option in "${directory_list[@]}" "Return"
do
  case "$option" in
    "Return")
    	source ../Main_Menu.sh
    	break
      ;;
    *)	
	if [[ ! "$REPLY" =~ ^[0-9]+$ || "$REPLY" -lt 1 || "$REPLY" -gt "${#directory_list[@]}" ]]; then
	echo "Please enter a valid option."
	else
	cd "$option"
	echo "Database $option is successfully Connected"
	source ../../DB_Menu.sh
	fi
      ;;
  esac
done
fi
