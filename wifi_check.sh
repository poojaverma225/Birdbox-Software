#!/bin/bash

# Check if the Pi can ping a known server likee google :0
 ping -c 1 8.8.8.8 > /dev/null 2>&1

 if [ $? -ne 0 ]; then

 # Wi-Fi is not connected, send us an email (we are paranoid.....)

mail -s "Wi-Fi Connection Issue" birdboxers11124@gmail.com

 # Shut down Raspberry Pi (its for your own good :_()

sudo shutdown -h now
 else
echo "Wi-Fi is connected."
 fi

#HELLO IF YOURE READING THIS HAHAH!! this script specifically may need some adjustments
#its a little counterintuitive rn; if the pi cant even connect to googles server, how would it have the internet to email us??
