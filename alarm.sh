#!/bin/bash
#temp1=`cat /sys/bus/w1/devices/28-0216225333ee/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x)}'`

readtemp () { n="$1" ;echo "select * from tempdb.temp order by timestamp desc limit 1"|mysql -sN -uroot -p1234|awk '{print $'$n'}' ;}

temp1=`readtemp 3`
temp2=`readtemp 4`


while [ "1" -eq "1" ]
do
        temp1=`readtemp 3`
	sendtimes=0
        echo $temp1
        while [ 1 -eq $(echo "$temp1 > 32.00"|bc -l) ]
        do
                echo "temp1>32"
			if [ "$sendtimes" -lt "3" ]
			then
				echo "send"#send email
				./alarmemail.sh
				let "sendtimes++"
			fi
                sleep 600
		temp1=`readtemp 3`
	        echo $temp1
        done

        sleep 60
done

