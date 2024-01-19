#!/bin/bash
shopt -s extglob
export LC_COLLATE=C

tables_list=($(ls -F | grep -v '/$' | grep -v '_meta$'))
if [ -z "$tables_list" ]; then
        echo "There Are No Tables to Delete From."
else

PS3="Select a Table To Delete From: "

select option in "${tables_list[@]}" "Return"
do
  case "$option" in
    "Return")
     	source ../../DB_Menu.sh
    	break
      ;;
    *)

	if [[ ! "$REPLY" =~ ^[0-9]+$ || "$REPLY" -lt 1 || "$REPLY" -gt "${#directory_list[@]}" ]]; then
        
		echo "Please enter a valid o1ption."
        

	else
		PS3="Select an option: "
		select option1 in "Delete All Data" "Delete a record" "Return"; do
	    	case "$option1" in
	       	 "Delete All Data")
           		sed -i '1,$d' $option
				echo "all the data in table $option was deleted"
            ;;
        	"Delete a record")
            

# File containing the table and the meta_data
table_file="${option}"
meta_file="${option}_meta"


# Get user input for the column name
read -p "Enter the column name to delete (or 'Q' to quit): " column_name_to_delete

field_number=
while true; do
    # Check if the user wants to quit
    if [ "$column_name_to_delete" == "Q" ]; then
        echo "User chose to quit. Exiting..."
        source ../../Delete.sh
    fi
    
    # Check if the column name exists in the table
    if field_number=$(awk -F: -v col_name="$column_name_to_delete" 'NR==1 { for (i=1; i<=NF; i++) if ($i == col_name) { print i; exit 0; } exit 1; }' "$meta_file"); then
        break
    else
        echo "Error: Column '$column_name_to_delete' does not exist in the table."
        read -p "Enter a valid column name (or 'Q' to quit): " column_name_to_delete
    fi
done



# Get user input for the column value
while true; do
    read -p "Enter the $column_name_to_delete value to delete (or 'Q' to quit): " column_value_to_delete

    # Check if the user wants to quit
    if [ "$column_value_to_delete" == "Q" ]; then
        echo "User chose to quit. Exiting..."
        source ../../Delete.sh
    fi

    # Check if the value exists in the specified column
    if awk -F: -v col_number="$field_number" -v search_value="$column_value_to_delete" '$col_number == search_value {found=1; exit 0} END {exit !found}' "$table_file"; then
        # Value exists, perform deletion
        awk -v col_number="$field_number" -F: '{ if ($col_number != col_value) print }' col_value="$column_value_to_delete" "$table_file" > tmpfile && mv tmpfile "$table_file"
        echo "Deletion successful."
        source ../../Delete.sh
        break
    else
        echo "Error: The specified value '$column_value_to_delete' does not exist in the column '$column_name_to_delete'."
    fi
done




            ;;
        	"Return")
            	source ../../Delete.sh
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
