#shebang: execute bash
#!/bin/bash
#sending us how its doing :)

#runs htop in -b batch mode; it displays current system usage basically and -n 1 tells it to display 1 update
#output of htop in htop_output.txt
htop -n 1 -b > htop_output.txt

#mail -s sends an email ofc
mail -s "HTOP SYSTEM CHECK WEEKLY REPORT" birdboxers11124@gmail.com<htop_output.txt

#housekeeping stuff

#gets the latest sofware updates, -y automatically accepts all prompts, && executes both commands
#explain sudo; superuser
sudo apt update && sudo apt upgrade -y

#removes unnecessary packages that are not needed, -y confirms that they are removed automatically
sudo apt autoremove -y

#removes versions of packages that can't be downloaded anymore (basically like discontinued)
sudo apt autoclean

#clears respository of package files and frees up disk space
sudo apt-get clean

#removes all the compressed log filed (*gz) in the /var/log to clear disk space
sudo rm -rf /var/log*.gz
#cleaning disk space :D

#if the disk is filled more than 80, then it deletes files that were changed over 30 days ago
#df -h is disk space in a readable format, awk NR stuff basically extracts the actual percent usage from a df file output
#then it cuts the actual percentage so it can be compared to the numerical threshold
THRESHOLD=80
CURRENT_USAGE=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

if [ "$CURRENT_USAGE" -ge "$THRESHOLD" ];then

#f specifies that its a file, directory is /home/birdbox, +10m is over 10 mb
find /home/birdbox -type f -size +10M -mtime +30 -delete
fi

#rtcwake bascially puts the whoe system in a sleep state, making it wake up after 7200 s (2 hrs) to conserve the system energy!!
sudo rtcwake -m off -s 7200

