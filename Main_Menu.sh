#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C

PS3="Select an option[1-5]: "

select option in "Create DB" "List DB" "Connect to DB" "Delete DB" "Exit"; do

  case "$REPLY" in
    1)
      source ../Create_DB.sh
      ;;
    2)
      source ../List_DB.sh
      ;;
    3)
      source ../Connect_DB.sh
      ;;
    4)
      source ../Delete_DB.sh
      ;;
    5)
      exit
      ;;
    *)
      echo "Please Enter a Valid Option"
      ;;
  esac
done

