#!/bin/bash

PORT=9000
DIRECTORY=$(pwd) # Current directory where the files are being served
IPADD=$(hostname -I | grep -E '^192.168' | cut -d ' ' -f 1)

while [[ $# -gt 0 ]]; do
  case $1 in
    -p)
      PORT="$2"
      shift 2  # Skip past the -p and its value
      ;;
    -d)
      DIRECTORY="$2"
      shift 2  # Skip past the -d and its value
      ;;
    *)
      echo "Usage: $0 [-p <port>] [-d <directory>]"
      exit 1
      ;;
  esac
done


echo "Starting Server with Address: ${IPADD}:${PORT} for directory ${DIRECTORY}"
python3 -m http.server $PORT -d $DIRECTORY
echo "Killing Server...."
