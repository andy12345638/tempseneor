#!/bin/bash
temp1=`cat /sys/bus/w1/devices/28-0216225333ee/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}'`

echo "INSERT INTO tempdb.temp (temp1) VALUE($temp1)"|mysql -h 127.0.0.1 -uroot -p1234

exit 0
