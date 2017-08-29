#!/bin/bash
cd /home/pi/tempsensor/
source /home/pi/tempsensor/phone.conf

#Rscript temp120png.r
#Rscript temp10080png.r

for i in "${phonelist[@]}"; do   # The quotes are necessary here
   # echo "$i"
#mutt -s "警告!機房溫度過高 `date +"%Y-%m-%d %H:%M"`" "$i" -a /home/pi/tempsensor/temp120png.png -a /home/pi/tempsensor/temp10080png.png < /home/pi/tempsensor/mail.txt 

curl "http://api.message.net.tw/send.php?id=0971009571&password=a123456&tel=$i&msg=警告！機房溫度過高，請至http://140.112.57.180/plot.php查看&mtype=G&encoding=utf8"
 
done


