#!/bin/bash

# Disable the kernel reaction to pressing the power key
LOGIND_FILE=logind.conf
LOGIND_DIR=/etc/systemd
cat $LOGIND_DIR/$LOGIND_FILE | grep -v "HandlePowerKey" > /tmp/$LOGIND_FILE
echo "HandlePowerKey=ignore" >> /tmp/$LOGIND_FILE
sudo mv /tmp/$LOGIND_FILE /etc/systemd/$LOGIND_FILE

sudo systemctl restart systemd-logind

# Install ir keytable
sudo apt-get update
sudo apt-get install ir-keytable -y

# Install keymap for Samsung remote
SAMSUNG_KEYMAP_DIR=/etc/rc_keymaps
SAMSUNG_KEYMAP_FILE=samsung_necx.toml

sudo mv ./$SAMSUNG_KEYMAP_FILE $SAMSUNG_KEYMAP_DIR/$SAMSUNG_KEYMAP_FILE

# Run ir-keytab at boot
IR_KEYTAB_SERVICE_FILE=ir_keytable.service

sudo systemctl stop $IR_KEYTAB_SERVICE_FILE
sudo systemctl disable $IR_KEYTAB_SERVICE_FILE

sudo mv ./$IR_KEYTAB_SERVICE_FILE /usr/lib/systemd/system/$IR_KEYTAB_SERVICE_FILE

sudo systemctl daemon-reload
sudo systemctl start $IR_KEYTAB_SERVICE_FILE
sudo systemctl enable $IR_KEYTAB_SERVICE_FILE

# Install triggerhappy
sudo apt-get install triggerhappy -y

sudo mkdir -p /opt/triggerhappy/audio/
sudo cp ./audio.conf /etc/triggerhappy/triggers.d/audio.conf

sudo systemctl restart triggerhappy
