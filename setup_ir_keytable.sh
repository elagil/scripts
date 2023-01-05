#!/bin/bash

# Disable the kernel reaction to pressing the power key
LOGIND_FILE=logind.conf
LOGIND_DIR=/etc/systemd
cat $LOGIND_DIR/$LOGIND_FILE | grep -v "HandlePowerKey" > /tmp/$LOGIND_FILE
echo "HandlePowerKey=ignore" >> /tmp/$LOGIND_FILE
sudo mv /tmp/$LOGIND_FILE $LOGIND_DIR/$LOGIND_FILE

sudo systemctl restart systemd-logind

# Install ir keytable
sudo apt-get update
sudo apt-get install ir-keytable -y

# Install keymap for Samsung remote
SAMSUNG_KEYMAP_DIR=/etc/rc_keymaps
SAMSUNG_KEYMAP_FILE=samsung_necx.toml

sudo cp ./$SAMSUNG_KEYMAP_FILE $SAMSUNG_KEYMAP_DIR/$SAMSUNG_KEYMAP_FILE

# Load ir-keytable config at boot
RC_MAP_FILE=rc_maps.conf
RC_MAP_DIR=/etc

echo "* * $SAMSUNG_KEYMAP_FILE" >> /tmp/$RC_MAP_FILE
sudo mv /tmp/$RC_MAP_FILE $RC_MAP_DIR/$RC_MAP_FILE

# Install triggerhappy
sudo apt-get install triggerhappy -y

sudo mkdir -p /opt/triggerhappy/audio/
sudo cp ./audio.conf /etc/triggerhappy/triggers.d/audio.conf

sudo systemctl restart triggerhappy
