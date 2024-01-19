


#!/bin/bash
shopt -s extglob
export LC_COLLATE=C

tables_list=($(ls -F | grep -v '/$' | grep -v '_meta$'))
if [ -z "$tables_list" ]; then
        echo "There Are No Tables To Select From."
else

PS3="Select a Table To Select From : "

select option in "${tables_list[@]}" "Return"
do
  case "$option" in
    "Return")
      source ../../DB_Menu.sh
      break
      ;;
    *)

    if [[ ! "$REPLY" =~ ^[0-9]+$ || "$REPLY" -lt 1 || "$REPLY" -gt "${#tables_list[@]}" ]]; then
        echo "Please enter a valid option."
    else
        PS3="Select an option: "
        select option1 in "Select All From Table" "Select Column" "Select Record" "Return"; do
            case "$option1" in
                "Select All From Table")
                    
		table_file="${option}"
                meta_file="${option}_meta"
                echo ""
		echo "------------------"		   
		head -n 1 "$meta_file"
        echo "------------------"    
               	cat "$table_file"
		echo "------------------"
		echo ""                 
		   
		source ../../Select.sh
		break
		;;
                 
		"Select Column")

		 # File containing the table and the meta_data
                    table_file="${option}"
                    meta_file="${option}_meta"

                    # Get user input for the column name
                    read -p "Enter the column name to select by (or 'Q' to quit): " column_name_to_select

                    field_number=
                    while true; do
                        # Check if the user wants to quit
                        if [ "$column_name_to_select" == "Q" ]; then
                            echo "User chose to quit. Exiting..."
                            source ../../Select.sh
                        fi

                        # Check if the column name exists in the table
                        if field_number=$(awk -F: -v col_name="$column_name_to_select" 'NR==1 { for (i=1; i<=NF; i++) if ($i == col_name) { print i; exit 0; } exit 1; }' "$meta_file"); then
                            break
                        else
                            echo "Error: Column '$column_name_to_select' does not exist in the table."
                            read -p "Enter a valid column name (or 'Q' to quit): " column_name_to_select
                        fi
                    done
			echo "----"
			echo "$column_name_to_select"
			echo "----"
			awk -v col="$field_number" -F: '{print $col; print "----"}' "$table_file" 


			source ../../Select.sh
			break


			;;

  
                "Select Record")
                    # File containing the table and the meta_data
                    table_file="${option}"
                    meta_file="${option}_meta"

                    # Get user input for the column name
                    read -p "Enter the column name to select by (or 'Q' to quit): " column_name_to_select

                    field_number=
                    while true; do
                        # Check if the user wants to quit
                        if [ "$column_name_to_select" == "Q" ]; then
                            echo "User chose to quit. Exiting..."
                            source ../../Select.sh
                        fi

                        # Check if the column name exists in the table
                        if field_number=$(awk -F: -v col_name="$column_name_to_select" 'NR==1 { for (i=1; i<=NF; i++) if ($i == col_name) { print i; exit 0; } exit 1; }' "$meta_file"); then
                            break
                        else
                            echo "Error: Column '$column_name_to_select' does not exist in the table."
                            read -p "Enter a valid column name (or 'Q' to quit): " column_name_to_select
                        fi
                    done

                    # Get user input for the column value
                    while true; do
                        read -p "Enter the $column_name_to_select value to select (or 'Q' to quit): " column_value_to_select

                        # Check if the user wants to quit
                        if [ "$column_value_to_select" == "Q" ]; then
                            echo "User chose to quit. Exiting..."
                            source ../../Select.sh
                        fi
			
			# Check if the value exists in the specified column

			if awk -F: -v col_number="$field_number" -v search_value="$column_value_to_select" '$col_number == search_value {found=1; exit 0} END {exit !found}' "$table_file"; then


                        # Display rows with the specified value in the specified column

			echo ""
			echo "-------------"
			echo "$column_name_to_select"
			echo "-------------"
                        awk -v col_number="$field_number" -v search_value="$column_value_to_select" -F: '$col_number == search_value' "$table_file"
			echo "-------------"
			echo ""
                        source ../../Select.sh
                        break
			 else
				echo "Error: The specified value '$column_value_to_select' does not exist in the column '$column_name_to_select'."
			  fi
                    done
                    ;;
                "Return")
                    source ../../Select.sh
                    break
                    ;;
                *)
                    echo "Invalid option. Please choose again."
                    ;;
            esac
        done
    fi
    ;;
  esac
done
fi

