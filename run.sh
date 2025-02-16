#!/bin/bash

VERSION="1.0.0"

echo "Running SX1302 LoRa Gateway version: $VERSION"

# Read configuration values from the options file
CONFIG_PATH=/data/options.json
echo "Reading configuration from $CONFIG_PATH"
REGION=$(jq --raw-output '.region' $CONFIG_PATH)
IP=$(jq --raw-output '.server_address' $CONFIG_PATH)
PORT=$(jq --raw-output '.port' $CONFIG_PATH)

echo "Configuration values:"
echo "REGION: $REGION"
echo "IP: $IP"
echo "PORT: $PORT"

CONFIG_FILE="/sx1302_hal/packet_forwarder/global_conf.json.sx1250.${REGION}"

echo "Using configuration file: $CONFIG_FILE"

# Check if the selected region configuration file exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE found."
    echo "Updating the configuration file with IP: $IP and PORT: $PORT..."

    # Update the configuration file with the provided IP and port using sed
    sed -i "s/\"server_address\": \".*\"/\"server_address\": \"$IP\"/" "$CONFIG_FILE"
    sed -i "s/\"serv_port_up\": [0-9]*/\"serv_port_up\": $PORT/" "$CONFIG_FILE"
    sed -i "s/\"serv_port_down\": [0-9]*/\"serv_port_down\": $PORT/" "$CONFIG_FILE"
    sed -i "s/\"gps_tty_path\": \".*\"/\"gps_tty_path\": \"\/dev\/ttyS0\"/" "$CONFIG_FILE"
    
else
    echo "Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Start the LoRa packet forwarder
echo "Starting the LoRa packet forwarder..."
exec /sx1302_hal/packet_forwarder/lora_pkt_fwd -c "$CONFIG_FILE"