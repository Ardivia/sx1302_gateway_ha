#!/bin/bash

CONFIG_PATH=/data/options.json
echo "Reading configuration from $CONFIG_PATH"
RESET_PIN=$(jq --raw-output '.reset_pin' $CONFIG_PATH)
POWER_EN_PIN=$(jq --raw-output '.power_en_pin' $CONFIG_PATH)

echo "CoreCell reset through GPIO$RESET_PIN and GPIO$POWER_EN_PIN..."

# Use gpiod for controlling GPIO
gpioset gpiochip0 $RESET_PIN=1
sleep 0.1
gpioset gpiochip0 $POWER_EN_PIN=1
sleep 0.1
gpioset gpiochip0 $RESET_PIN=0
sleep 0.1
gpioset gpiochip0 $POWER_EN_PIN=0

echo "CoreCell reset complete."