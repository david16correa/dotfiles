#!/bin/bash
# make sure to add the following to visudo:
# %wheel ALL=(ALL) NOPASSWD: /home/david/.myScripts/set-micmute-led.sh
# using `sudo visudo`
echo "$1" > /sys/class/leds/platform::micmute/brightness
