#!/bin/bash

# Check if the Pi can ping a known server likee google :0
 ping -c 1 8.8.8.8 > /dev/null 2>&1

 if [ $? -ne 0 ]; then

 # Wi-Fi is not connected, send an email notification (optional) echo

mail -s "Wi-Fi Connection Issue" birdboxers11124@gmail.com

 # Shut down Raspberry Pi

sudo shutdown -h now
 else
echo "Wi-Fi is connected."
 fi
