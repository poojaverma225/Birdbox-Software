#!/bin/bash
#SETS THE output to our album :)
OUTPUT_DIR="Birdbox v1:album/Birdbox Version 1 at Lake Elizabeth"
TEMP_THRESHOLD_HIGH=70000  # 70°C (shutdown threshold)
TEMP_THRESHOLD_RESUME=60000  # 60°C (resume photo taking)
TEMP_THRESHOLD_STOP=65000  # 65°C (stop photo taking)
VOLTAGE_THRESHOLD=0.7  
#testing if its super duper high
while true
do
  temp=$(cat /sys/class/thermal/thermal_zone0/temp)
  voltage=$(vcgencmd measure_volts | sed 's/V//g')

  if [ $temp -gt $TEMP_THRESHOLD_HIGH ]; then
    echo "Raspberry pi is overheating critically! Shutting down."
    echo "Temperature: $(echo "scale=2; $temp / 1000" | bc)°C" | mail -s "RASP PI EMERGENCY" birdboxers11124@gmail.com
    sleep 15
    sudo systemctl poweroff -f
  fi
#testing if its a little high
  if [ $temp -gt $TEMP_THRESHOLD_STOP ]; then
    echo "Raspberry pi is overheating! Stopping photo taking."
    # Stop taking photos
    pkill libcamera-still
    echo "Temperature: $(echo "scale=2; $temp / 1000" | bc)°C" | mail -s "RASP PI EMERGENCY" birdboxers11124@gmail.com
    # Wait for temperature to drop
    while [ $temp -gt $TEMP_THRESHOLD_RESUME ]; do
      sleep 10
      temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    done
    echo "Temperature has dropped. Resuming photo taking."
    echo "Temperature: $(echo "scale=2; $temp / 1000" | bc)°C" | mail -s "RASP PI RESUMED" birdboxers11124@gmail.com
  fi
#this probably wont happen butttt
  if [ $(echo "$voltage < $VOLTAGE_THRESHOLD" | bc) -eq 1 ]; then
    echo "Voltage is low! Shutting down."
    echo "Voltage is $voltage" | mail -s "RASP PI EMERGENCY" birdboxers11124@gmail.com
    sleep 15
    sudo systemctl poweroff -f
  fi

  # Take photos and send them to pcloud album using rclone :D
#year, month, day, hour, minute, second; the percent helps the system get them and dollar is similar
  TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
#every file is named diff that way
  FILE_NAME="${TIMESTAMP}.jpg"
#sudo = superuser, libcamera takes photos, o = output file name
  sudo libcamera-still -o "${FILE_NAME}"
#copys the photo itp othe rclone 
  rclone copy "/home/birdbox/${FILE_NAME}" "Birdbox v1:album/Birdbox Version 1 at Lake Elizabeth"
  
#if the exit status of the last command was successful, than remove the file from the local directory 
#if tests for a certain condition
if [ $? -eq 0 ]; then
    sudo rm "/home/birdbox/${FILE_NAME}"
  else
#If not, email us that it didnt work
    echo "oopsies floopsies"
  fi

  sleep 180
done

