#!/bin/bash
shopt -s extglob
export LC_COLLATE=C

PS3="Select an option[1-8]: "

tables=$(ls -F | grep -v '/$' | grep -v '_meta$')

      if [ -z "$tables" ]; then
        echo "There Are No Tables to List."
      else
        echo "$tables"
      fi
