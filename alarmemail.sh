#!/bin/bash
source email.conf

Rscript temp120png.r
Rscript temp10080png.r

for i in "${emaillist[@]}"; do   # The quotes are necessary here
    #echo "$i"
mutt -s "警告!機房溫度過高 `date +"%Y-%m-%d %H:%M"`" "$i" -a ./temp120png.png -a ./temp10080png.png < mail.txt 
done


