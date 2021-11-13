#!/bin/bash

# Flatten args by expanding cli input
ARGS=()
for arg in $@; do 
    ARGS+=("$arg")
done

# Populate REQ_FILE and LOCK_FILE
POSITIONAL=()
END=${#ARGS[@]} # end = length of flat args
for ((i=0;i<END;i++)); do
    case ${ARGS[$i]} in
    --req)
        REQ_FILE=${ARGS[($i+1)]}
        i=$i+1
        ;;
    --lock)
        LOCK_FILE=${ARGS[($i+1)]}
        i=$i+1
        ;;
    *)
        POSITIONAL+=(${ARGS[$i]})
        ;;
    esac
done

FOUND_REQ=false
FOUND_LOCK=false

for file in ${POSITIONAL[@]}; do
    if [ $file == $REQ_FILE ]; then
        FOUND_REQ=true
    elif [ $file == $LOCK_FILE ]; then
        FOUND_LOCK=true
    fi
done

RED='\033[0;31m'

if [ $FOUND_REQ == true ] && [ $FOUND_LOCK == false ]; then
    printf "${RED}Requirements file modified but no lock file modified. Please generate a new $LOCK_FILE \n"
    exit 1
fi
