#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C

curr_path=$(pwd)

flag=0
for var in $(ls "$curr_path" -F | grep '/')
do
    if [ "$var" = "DBMS/" ]; then
        flag=1
        break
    fi
done

if [ "$flag" -eq 0 ]
 then
    mkdir "./DBMS"
	cd "./DBMS"
    echo "The DBMS directory is created"
	source ../Main_Menu.sh
else
    cd "./DBMS" || exit 1
	echo "The DBMS directory is already created"
	source ../Main_Menu.sh 
fi

