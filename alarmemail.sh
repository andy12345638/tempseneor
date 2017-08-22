#!/bin/bash
source /home/pi/tempsensor/email.conf

#Rscript temp120png.r
#Rscript temp10080png.r

for i in "${emaillist[@]}"; do   # The quotes are necessary here
    #echo "$i"
mutt -s "警告!機房溫度過高 `date +"%Y-%m-%d %H:%M"`" "$i" -a /home/pi/tempsensor/temp120png.png -a /home/pi/tempsensor/temp10080png.png < /home/pi/tempsensor/mail.txt 
done


