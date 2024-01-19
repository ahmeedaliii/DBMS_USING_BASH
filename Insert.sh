#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C
files=()
col_names=()
data_types=()
for i in ./*
do
    if [ -f "$i" ] && [[ $i != *"_meta"* ]]; then
        files+=("$i")
    else
        continue
    fi
done

if [ ${#files[@]} -eq 0 ]; then
    echo "No tables found. You can create one."
else
    for file in "${files[@]}"
    do
        echo "$file" | tr ./ ">"
    done
fi

while true
do
    read -p "Enter the table name you want to insert in (or 'Q' to exit): " TB_Name 
    if [[ $TB_Name == "Q" ]] ; then
        . ../../DB_Menu.sh
    elif [[ -z $TB_Name || ! -f $TB_Name ]]; then
        echo "No such table with this name."
        continue
    else
	meta_type=$(sed -n '2p' "${TB_Name}_meta")
    meta_name=$(sed -n '1p' "${TB_Name}_meta")

    IFS=':' read -a columns_types <<< "$meta_type"
    IFS=':' read -a columns_names <<< "$meta_name"

        echo "${columns_names[@]}"
        echo "${columns_types[@]}"
        rw=""

        for ((i = 0; i < ${#columns_names[@]}; i++))
        do
            while true
            do   
                flag="false"                
         read -p "Please enter values of col $((1 + i)) : " data
		if [[ "$data" =~ ^[[:space:]]*$ ]]; then
                        echo "The value can't be empty."
                        continue
                fi
		if [[ "$i" == 0 ]]; then
		    x=$(awk -v data=$data -F ":" '
			{
			    if ($1 == data) {
				print $1
			    }
			}
			END {
			}' $TB_Name | wc -l)

		    if [[ $x -gt 0 ]]; then
			flag="true" 
		echo "The primary key should be unique"
			continue
		    fi
		fi
                if [[ "$flag" == "false" ]]; then
                   if [[ "$data" =~ ^[[:space:]]*$ ]];then
                       echo "The value can't be empty."
                       continue
                   fi
                   if [[ ${columns_types[i]} == "int" ]]; 				then
                        if [[ "$data" =~ ^[0-9]+$ && "$data" -gt 0 ]]; then
                            rw+="$data:"
                            break 
                        else
                            echo "The data type of this column is Integer"
                            continue 
                        fi
                    else 
                        case $data in
                            *[[:space:]]*  )
                                data=$(echo "$data" | sed 's/[[:space:]]/_/g')
                                rw+="$data:"
                                break
                                ;;				
                            *[0-9]* )
                                 rw+="$data:"
           			break		
                                ;;
                            *['!''@#/$\"*{^})(+|,;:~`.%&/=-]>[<?']* )
                                echo "The name value can't have any special characters."
                                continue
                                ;;
                            +([A-Za-z_]*) ) 	
                                rw+="$data:"
				break			
                                ;;
                            * )
                                echo "Invalid data type."
                                continue
                                ;;
                        esac
                    fi
                fi
            done
        done
	rw=$(echo "$rw" | sed 's/:$//')
        echo "$rw" >> "$TB_Name"
    fi
done

