#!/bin/bash

# Number of concurrent requests
CONCURRENT=5
TOTAL_REQUESTS=1000

echo "Starting $TOTAL_REQUESTS requests with $CONCURRENT concurrent connections"

time (
    seq $TOTAL_REQUESTS | xargs -n1 -P$CONCURRENT -I{} \
        curl -s -k --max-time 5 -X GET "http://oge.social:1044/bwscript"
)

echo "All requests completed"