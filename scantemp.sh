#!/bin/bash

temp1=`cat /sys/bus/w1/devices/28-000005fb9a56/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}'` &
PID1=$!

temp1=` cat /sys/bus/w1/devices/28-000008ec7f8e/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}'` &
PID2=$!

temp1=`cat /sys/bus/w1/devices/28-000008ecdabb/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}'` &
PID3=$!

temp1=`cat /sys/bus/w1/devices/28-000008ecf8ec/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}'` &
PID4=$!

wait $PID1
wait $PID2
wait $PID3
wait $PID4

echo "INSERT INTO tempdb.temp (temp1,temp2,temp3,temp4) VALUE($temp1,$temp2,$temp3,$temp4)"|mysql -h 127.0.0.1 -urpi -p12345678

exit 0
