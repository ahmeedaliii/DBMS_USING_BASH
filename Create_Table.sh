#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C

while true; do
    read -p "Please Enter The Table Name (or 'Q' to exit): " TB_Name

    if [ "$TB_Name" == "Q" ]; then
        echo "Exiting..."
        source ../../DB_Menu.sh
        break
    fi

    TB_Name=$(echo "$TB_Name" | sed 's/ /_/g')

    if [ -z "$TB_Name" ]; then
        echo "Please Enter a Name"
    else
        if [[ "$TB_Name" =~ ^[[:digit:]] ]]; then
            echo "Table name cannot start with a number"
        elif [[ ! "$TB_Name" =~ ^[[:alnum:]_]+$ ]]; then
            echo "Table name cannot has a special character"
        elif [ -e "$TB_Name" ]; then
            echo "Table '$TB_Name' already exists. Please enter another name."
        else
            touch "$TB_Name"
            touch "${TB_Name}_meta"
            echo "Table '$TB_Name' is successfully created"
            break
        fi
    fi
done

while true; do
    read -p "Enter number of columns (or 'Q' to quit) : " cols
    if [ "$cols" == "Q" ]; then
        rm "$TB_Name"
	rm "${TB_Name}_meta"
	. ../../DB_Menu.sh
        break
    fi
    if [[ "$cols" =~ ^[0-9]+$ && "$cols" -gt 0 ]]; then
        echo "Number of fields is $cols"
        break
    else
        echo "Please enter a number (no strings)"
        continue
    fi
done

let cols=$cols
echo "The first column is the primary key"
row=""
row2=""
row3=""

for ((i=1; i<=$cols; i++)); do
    while true; do
        read -p "Enter name of column ${i} (or 'Q' to quit) : " col
	if [ "$col" == "Q" ]; then
        rm "$TB_Name"
	rm "${TB_Name}_meta"
	. ../../DB_Menu.sh
        break
	fi
        col=$(echo "$col" | sed 's/[[:space:]]/_/g')
        if [ -z "$col" ]; then
            echo "Please Enter a Name"
            continue
        elif [[ "$col" =~ ^[0-9] ]]; then
            echo "The name can't start with numbers"
            continue
        elif [[ ! "$col" =~ ^[[:alnum:]_]+$ ]]; then
	echo "The name can't has any special characters"
            continue
        else
            if echo "$row" | awk -F: -v col="$col" '{for(i=1;i<=NF;i++) if ($i == col) exit 1}'; then
                row+="$col:"
                break
            else
                echo "This column is already exist"
            fi
        fi
    done

    while true; do
        read -p "Enter the data type of column $i [int] OR [str] (or 'Q' to quit) : " col_type
	if [ "$col_type" == "Q" ]; then
        rm "$TB_Name"
	rm "${TB_Name}_meta"
	. ../../DB_Menu.sh
        break
	fi
        if [[ $col_type == "int" ]]; then
            row2+="$col_type:"
            break
        elif [[ $col_type == "str" ]]; then
            row2+="$col_type:"
            break
        else
            echo "[1] OR [2] only"
            continue
        fi
    done
done

row=$(echo "$row" | sed 's/:$//')
row2=$(echo "$row2" | sed 's/:$//')
echo "$row" >> "${TB_Name}_meta"
echo "$row2" >> "${TB_Name}_meta"

