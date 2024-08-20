#!/bin/bash
#sending us how its doing :)
htop -n 1 -b > htop_output.txt

mail -s "HTOP SYSTEM CHECK WEEKLY REPORT" birdboxers11124@gmail.com<htop_output.txt
#housekeeping stuff
sudo apt update && sudo apt upgrade -y

sudo apt autoremove -y

sudo apt autoclean

sudo apt-get clean

sudo rm -rf /var/log*.gz
#cleaning disk space :D
THRESHOLD=80
CURRENT_USAGE=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

if [ "$CURRENT_USAGE" -ge "$THRESHOLD" ];then

find /home/birdbox -type f -size +10M -mtime +30 -delete
fi

sudo rtcwake -m off -s 7200

