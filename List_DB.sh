#!/bin/bash
shopt -s extglob 
export LC_COLLATE=C

PS3="Select an option[1-5]: "

databases=$(ls -F | grep / | sed 's/\/$//')

      if [ -z "$databases" ]; then
        echo "There Are No Databases to List."
      else
        echo "$databases"
      fi
