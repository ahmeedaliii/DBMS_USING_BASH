#!/bin/bash
shopt -s extglob
export LC_COLLATE=C

PS3="Select an option[1-8]: "

select option in "Create Table" "Drop Table" "List Tables" "Select" "Insert" "Update" "Delete" "Return"; do

  case "$REPLY" in
    1)
      source ../../Create_Table.sh
      ;;
    2)
      source ../../Drop_Table.sh
      ;;
    3)
      source ../../List_Tables.sh
      ;;
    4)
      source ../../Select.sh
      ;;
    5)
      source ../../Insert.sh
      ;;
    6)
      source ../../Update.sh
      ;;
    7)
      source ../../Delete.sh
      ;;
    8)			
	cd ..			
	source ../Main_Menu.sh 
	;;
    *)
      echo "Please Enter a Valid Option"
      ;;
  esac
done

