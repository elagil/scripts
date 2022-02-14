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

cat <<EOT > /tmp/$SAMSUNG_KEYMAP_FILE
[[protocols]]
name = "samsung_necx"
protocol = "nec"
[protocols.scancodes]
0x70702 = "KEY_POWER"
0x7070f = "KEY_MUTE"
0x70704 = "KEY_1"
0x70705 = "KEY_2"
0x70706 = "KEY_3"
0x70708 = "KEY_4"
0x70709 = "KEY_5"
0x7070a = "KEY_6"
0x7070c = "KEY_7"
0x7070d = "KEY_8"
0x7070e = "KEY_9"
0x70711 = "KEY_0"
0x70712 = "KEY_CHANNELUP"
0x70710 = "KEY_CHANNELDOWN"
0x70707 = "KEY_VOLUMEUP"
0x7070b = "KEY_VOLUMEDOWN"
0x70760 = "KEY_UP"
0x70768 = "KEY_ENTER"
0x70761 = "KEY_DOWN"
0x70765 = "KEY_LEFT"
0x70762 = "KEY_RIGHT"
0x7072d = "KEY_EXIT"
0x70749 = "KEY_RECORD"
0x70747 = "KEY_PLAY"
0x70746 = "KEY_STOP"
0x70745 = "KEY_REWIND"
0x70748 = "KEY_FORWARD"
0x7074a = "KEY_PAUSE"
0x70703 = "KEY_SLEEP"
0x7076c = "KEY_RED"
0x70714 = "KEY_GREEN"
0x70715 = "KEY_YELLOW"
0x70716 = "KEY_BLUE"
0x70758 = "KEY_BACK"
0x7071a = "KEY_MENU"
0x7076b = "KEY_LIST"
0x70701 = "KEY_TV2"
0x7071f = "KEY_INFO"
0x7071b = "KEY_TV"
0x7078b = "KEY_AUX"
0x7078c = "KEY_MEDIA"
EOT

sudo mv /tmp/$SAMSUNG_KEYMAP_FILE $SAMSUNG_KEYMAP_DIR/$SAMSUNG_KEYMAP_FILE

# Run ir-keytab at boot
IR_KEYTAB_SERVICE_FILE=ir_keytable.service
cat <<EOT > /tmp/$IR_KEYTAB_SERVICE_FILE
[Unit]
Description=Foo

[Service]
ExecStart=ir-keytable -c -w $SAMSUNG_KEYMAP_DIR/$SAMSUNG_KEYMAP_FILE

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl stop $IR_KEYTAB_SERVICE_FILE
sudo systemctl disable $IR_KEYTAB_SERVICE_FILE

sudo mv /tmp/$IR_KEYTAB_SERVICE_FILE /usr/lib/systemd/system/$IR_KEYTAB_SERVICE_FILE

sudo systemctl daemon-reload
sudo systemctl start $IR_KEYTAB_SERVICE_FILE
sudo systemctl enable $IR_KEYTAB_SERVICE_FILE

# Install triggerhappy
sudo apt-get install triggerhappy -y
