#!/bin/bash
source email.conf

DATE=`date +%Y-%m-%d:%H:%M:%S`
Rscript temp120png.r
Rscript temp10080png.r

for i in "${emaillist[@]}"; do   # The quotes are necessary here
    #echo "$i"
mutt -s "test mail" "$i" -a ./temp120png.png -a ./temp10080png.png < mail.txt 
done


