#!/bin/bash

# Execute the curl commands and time the entire operation
time (
    urls=()
    for i in {1..100}; do
        if [ $i -gt 1 ]; then
            urls+=(--next)
        fi
        urls+=(-s -k --max-time 5 -X GET "http://localhost:3000/bwscript")
    done
    curl "${urls[@]}"
)