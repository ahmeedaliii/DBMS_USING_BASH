#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C

directory_list=($(ls -F | grep / | sed 's/\/$//'))
if [ -z "$directory_list" ]; then
    echo "There Are No Databases to Delete."
else

    PS3="Select a Database To Delete: "

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
                    rm -r "${directory_list[$((REPLY-1))]}"
                    echo "Database ${directory_list[$((REPLY-1))]} is successfully Deleted"
                fi
                ;;
        esac
    done
fi

