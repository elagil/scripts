#!/bin/bash

CONFIG_FILE=/boot/config.txt

sed -i 's/^dtparam=audio=on/#dtparam=audio=on/' $CONFIG_FILE
sed -i 's/^.*dtoverlay=gpio-ir,.*/dtoverlay=gpio-ir,gpio_pin=4/' $CONFIG_FILE
sed -i 's/^#dtparam=i2s=on/dtparam=i2s=on/' $CONFIG_FILE
sed -i 's/^#dtparam=spi=on/dtparam=spi=on/' $CONFIG_FILE

echo "# Enable HifiBerry overlays" >> $CONFIG_FILE
echo "force_eeprom_read=0" >> $CONFIG_FILE
echo "dtoverlay=hifiberry-dac" >> $CONFIG_FILE
