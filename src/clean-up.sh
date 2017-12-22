#!/bin/bash

# This script is intended to be run *within* the container that is
# defined by this project's Dockerfile.

if [ "$1" == "" ]
then
    echo "You must provide the path to your encrypted wallet file:" >&2
    echo >&2
    echo "$0 [path-to-wallet-file]" >&2
    echo >&2
    exit 1
fi

echo "Deleting files:"
rm -v "$1"
rm -v "${1}-seed.txt"
rm -v "${1}-private-keys.txt"
