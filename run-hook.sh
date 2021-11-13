#!/bin/bash
echo $*

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    op="$1"

    case $op in
    --req)
        REQ_FILE="$2"
        shift # past argument
        shift # past value
        ;;
    --lock)
        LOCK_FILE="$2"
        shift # past argument
        shift # past value
        ;;
    *)
        POSITIONAL=(${POSITIONAL[@]} "$1")
        shift # past argument
        ;;
    esac
done

echo "REQ_FILE"  = ${REQ_FILE}
echo "LOCK_FILE" = ${LOCK_FILE}

FOUND_REQ=false
FOUND_LOCK=false

for file in ${POSITIONAL[@]}; do
    if [ $file == $REQ_FILE ]; then
        FOUND_REQ=true
    elif [ $file == $LOCK_FILE ]; then
        FOUND_LOCK=true
    fi
done

echo FOUND_REQ $FOUND_REQ
echo FOUND_LOCK $FOUND_LOCK

RED='\033[0;31m'


if [ $FOUND_REQ == true ] && [ $FOUND_LOCK == true ]; then
    printf "${RED}Requirements file modified but no lock file modified. Please generate a new $LOCK_FILE"
    exit 1
fi
