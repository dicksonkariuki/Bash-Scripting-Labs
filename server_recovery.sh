#!/bin/bash
# What you need to do is to create a script that will be used to recover the server in case of a failure. The script should be able to do the following:
# 1. Check if the server is up and running.
# 2. If the server is down, it should try to restart the server.
# 3.Log the details of the failure and the recovery process in a log file.
# 4. If the server is still down after trying to restart it, it should send an email to the administrator with the details of the failure.

# Variables
SERVER_URL="http://localhost:8080"
LOG_FILE="/var/log/server_recovery.log"
ADMIN_EMAIL="dicksonkariuki4@gmail.com"
hostname=$(hostname)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
CONTAINER="nginx-lab"

echo "CHECK WHETHER NGINX IS RUNNING"

docker ps --filter "name=$CONTAINER" --filter "status=running" | grep -q $CONTAINER

if [ $? -ne 0 ]; then
    echo "$TIMESTAMP - $HOSTNAME CRITICAL: - NGINX is not running. Restarting the container" >>$LOG_FILE
    #Attemp to restart the container
    echo "RESTARTING THE NGINX CONTAINER"
    docker restart $CONTAINER

    if [ $? -ne 0 ]; then
        echo "$TIMESTAMP - $HOSTNAME CRITICAL: - Failed to restart NGINX container" >>$LOG_FILE
         mail -s "Nginx Recovery Alert" $ADMIN_EMAIL < $LOG_FILE

        exit 1
    else
        echo "$TIMESTAMP - $HOSTNAME SUCCESS: - Successfully restarted NGINX container" >>$LOG_FILE
    fi
else
    echo "$TIMESTAMP - $HOSTNAME SUCCESS: - NGINX is running" >>$LOG_FILE
fi

