#!/usr/bin/bash
export LC_COLLATE=C
shopt -s extglob   

files=()
for i in ./*
do
	if [ -f $i ] && [[ $i != *"_meta"* ]];then
		files+=("$i")
	else
		continue
	fi
done
        
if [ ${#files[@]} -eq 0 ]; then
       	echo -e " No tables found you can create one "
else
	for file in "${files[@]}"
	do
		echo "$file" | tr ./ ">"
	done
fi

while true 
do    
	read -p "choose table to update (or 'Q' to quit) : " tbname

	if [[ $tbname == "Q" ]] ; then
		. ../../DB_Menu.sh
	elif [[ -z $tbname || ! -f $tbname ]] ; then
		echo -e " No such table with this name "
		continue
	else	
		clear
		while true
		do
			OLDIFS=$IFS

			found=false
			read -p "Enter PK of record you want to update (or 'Q' to quit) : " data
			if [[ $data == "Q" ]] ; then
			. ../../DB_Menu.sh
			fi

			loop=`cut -d : -f 1 $tbname`
			read -ra arr3 <<< $loop
			index=0

			for val in "${arr3[@]}"
			do
				index=$((index + 1))
				if [[ "$data" == "$val" ]];then
					let index=$index
					IFS=':'
					line=`sed -n "${index}p" $tbname`
					read -ra arr <<< "$line"
					IFS=$OLDIFS
					echo "Record $index for PK $data: ${arr[@]}"
					found=true
					break
				fi
			done

			if [[ "$found" == true ]];then
				IFS=':'

				str=`awk -F : '{if(NR == 1){print $0}}' $tbname"_meta"`
				read -ra fields <<< "$str"

				str1=`awk -F : '{if(NR == 2){print $0}}' $tbname"_meta"`
				read -ra arr1 <<<"$str1"

				IFS=$OLDIFS
				echo " Columns : ${fields[@]} "
				read -p " Enter column name you want  to modify (or 'Q' to quit) : " colname 
				if [[ $colname == "Q" ]] ; then
				. ../../DB_Menu.sh
				fi				
				col_index=-1

				for ((i = 0 ; i <${#fields[@]} ; i++))
				do

					if [[ "$colname" == "${fields[i]}" ]]; then 	
						col_index=$((i+1))
						break
					fi
				done
				if [[ $col_index -ne -1 ]];then

					col_value=${arr[col_index -1]}
					echo "Value in column '$colname' for PK $data: $col_value"

					while true
					do
					  read -p "Enter new value for column '$colname': (or 'Q' to quit) : " new_value 
						if [[ $new_value == "Q" ]] ; then
						. ../../DB_Menu.sh
						fi
						lop=`cut -d : -f $col_index $tbname`
						read -ra arr4 <<< $lop
						fod=false
			
						if [[ $colname == ${fields[0]} ]] ;then					
						for ((i = 0 ; i <${#arr4[@]} ; i++))
						do
						if [[ "$new_value" == "${arr4[i]}" ]]; then 	
						echo "The primary key should be unique set another value" 
						continue 2
						fi
						done
						fi

						if [[ $fod == false ]] ;then

							if [[ "$data" =~ ^[[:space:]]*$ ]]; then
					      			echo " The value can't be empty."
								continue
					       		fi

							if [[ ${arr1[col_index -1]} == "int" ]]; then
							   if [[ "$new_value" =~ ^[0-9]+$  ]];then


						       	   sed -i ''$index's/'$col_value'/'$new_value'/g' $tbname
							     echo "Column '$colname' updated with '$new_value' "
								break 
							   else
								echo -e " the data type of this column is Integer "
								 continue 
							   fi
							else 
							    case $new_value in
								 *[[:space:]]*  )
						 		 new_value=$(echo "$new_value" | sed 's/[[:space:]]/_/g')

								sed -i ''$index's/'$col_value'/'$new_value'/g' $tbname
									echo "Column '$colname' updated with'$new_value' "
									break 
									;;

								 *[0-9]* )
									echo "Column '$colname' updated with '$new_value'"
								    sed -i ''$index's/'$col_value'/'$new_value'/g' $tbname
									break
									;;

									*['!''@#/$\"*{^})(+|,;:~`.%&/=-]>[<?']* )
									echo "The value have any special characters "
									continue
									;;

									+([A-Za-z_]*) )

								      sed -i ''$index's/'$col_value'/'$new_value'/g' $tbname
									echo "Column '$colname' updated with '$new_value'"
									break					
									;;

									*)
									echo " invalid data type "
									continue				
									;;
								esac
							fi
											
						fi
					done

		
				else 
					echo "This column doesn't Exist "
					continue
				fi
			else
				echo " This PK not Avialable "
				continue
			fi
		done
	fi
done
