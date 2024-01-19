#!/bin/bash
shopt -s extglob
export LC_COLLATE=C

tables_list=($(ls -F | grep -v '/$' | grep -v '_meta$'))
if [ -z "$tables_list" ]; then
        echo "There Are No Tables to Drop."
else

PS3="Select a Table To Drop: "

select option in "${tables_list[@]}" "Quit"
do
  case "$option" in
    "Quit")
     	echo "Exiting..."
		PS3="Select an option[1-8]: "
    	break
		
      ;;
    *)
	if [[ ! "$REPLY" =~ ^[0-9]+$ || "$REPLY" -lt 1 || "$REPLY" -gt "${#directory_list[@]}" ]]; then
                    echo "Please enter a valid option."
        else
	rm  "$option"
	rm "${option}_meta"
	echo "You Successfully dropped Table $option"
	fi
      ;;
  esac
done
fi
