#!/bin/bash
#temp1=`cat /sys/bus/w1/devices/28-0216225333ee/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x)}'`
cd /home/pi/tempsensor/

readtemp () { n="$1" ;echo "select * from tempdb.temp order by timestamp desc limit 1"|mysql -sN -urpi -p12345678|awk '{print $'$n'}' ;}

maxtemp () {
temp1=`readtemp 3`;
temp2=`readtemp 4`;
temp3=`readtemp 5`;
temp4=`readtemp 6`;
Rscript -e "args<-commandArgs(TRUE);cat(max(as.numeric(args)))" 1 $temp1 $temp2 $temp3 $temp4;}

max1=`maxtemp`
#echo $max1


while [ "1" -eq "1" ]
do
        max1=`maxtemp`
	sendtimes=0
        echo $max1
        while [ 1 -eq $(echo "$max1 > 30.00"|bc -l) ]
        do
                echo "temp1>30"
			if [ "$sendtimes" -lt "3" ]
			then
				echo "send"#send email
				/home/pi/tempsensor/alarmemail.sh
				let "sendtimes++"
			fi
                sleep 600
		max1=`maxtemp`
	        echo $max1
        done

        sleep 60
done

