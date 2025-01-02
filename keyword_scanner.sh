#!/bin/bash

# Define paths
LOG_FILE="/var/log/keyword_scanner/scan_results.log"
KEYWORDS_FILE="/home/container/keywords.txt"
LOGS_DIRECTORY="/path/to/your/server/logs"  # <-- Replace this with the actual path to your server logs

# Function to start the scanner
start_scanner() {
    echo "$(date): Starting Keyword Scanner..." >> "$LOG_FILE"
    
    # Check if keywords file exists
    if [ ! -f "$KEYWORDS_FILE" ]; then
        echo "$(date): Keywords file not found at $KEYWORDS_FILE!" >> "$LOG_FILE"
        exit 1
    fi

    # Read keywords into an array, assuming comma-separated values
    IFS=',' read -r -a keywords <<< "$(tr ',' '\n' < "$KEYWORDS_FILE")"

    # Scan logs for each keyword
    for keyword in "${keywords[@]}"; do
        echo "$(date): Scanning for keyword: '$keyword'" >> "$LOG_FILE"
        grep -i "$keyword" "$LOGS_DIRECTORY"/*.log >> "$LOG_FILE" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "$(date): Found occurrences of '$keyword'" >> "$LOG_FILE"
        else
            echo "$(date): No occurrences of '$keyword' found." >> "$LOG_FILE"
        fi
    done

    echo "$(date): Scan completed." >> "$LOG_FILE"
}

# Function to stop the scanner
stop_scanner() {
    echo "$(date): Stopping Keyword Scanner..." >> "$LOG_FILE"
    # If the scanner runs as a background process, you can add commands to terminate it gracefully
    # For example:
    # pkill -f keyword_scanner.sh
    echo "$(date): Keyword Scanner stopped." >> "$LOG_FILE"
}

# Parse command-line arguments
case "$1" in
    start)
        start_scanner
        ;;
    stop)
        stop_scanner
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac

exit 0
