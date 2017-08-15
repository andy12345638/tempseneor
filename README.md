# tempseneor
rpi3 with ds18b20

# 材料
1. Raspberry PI 3 Model B $1800內  
2. Sandisk sd card 32G $500 內  
3. 110V to USB 充電器 2.5A $300  
4. usb 充電線 30cm $100內  
5. DS18B20 溫度感應器 3米*4條 $1500 內  
6. 其他焊接材料(洞洞板、電阻、杜邦頭)$300內  
共計 $4500 內  

# 架構
1. 每分鐘讀取4隻溫度資料並寫入mysql #scantemp.sh  
2. 每週匯出圖表給指定email sendemail.sh  
3. 一個每分鐘監測溫度的迴圈，當其中一個溫度大於30度，寄出email，含30分鐘圖表，停10分鐘;若還是高於30度就再寄出，低於就寄出安全與圖表;連續三封信。三封信後舊部再寄出，直到溫度恢復，才重新有警報。#alarm.sh + alarmemail.sh
4. 寄email的帳號密碼  
5. 收email的列表 mail.conf  
6. 寄email的bash sendemail.sh alarmemail.sh  
7. 畫出30分鐘圖表的rscritp #temp120png.r  
8. 畫出一週圖表的rscritp temp10080png.r  

# 事前準備
## exim4
`sudo apt-get install exim4 mutt`
>https://fourdollars.blogspot.tw/2014/08/ubuntu-1404-exim4-gmail.html

## mysql
`sudo apt-get install mysql-server mysql-clent`  
`mysql -u root -p `  
`CREATE DATABASE tempdb;  
USE tempdb;  
CREATE TABLE temp (timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
temp1 decimal(5,3),  
temp2 decimal(5,3),  
temp3 decimal(5,3),  
temp4 decimal(5,3));  `

## R
`sudo apt-get install r-base`  
`R`  
`install.packages("DBI")`  
`install.packages("RMySQL")`

https://www.raspberrypi.org/forums/viewtopic.php?t=111375&p=765242
>For those who might doing same stuff like me, here is how i fix the issue.  

>1. Guess this is really an out of memory issue, some how Pi runs out of memory when installing RSQLite package. So you have to increase swap file size to prevent the out of memory error kicks in.  
>2. Type in command "sudo nano /etc/dphys-swapfile" without the quote.  
>3. edit the line "CONF_SWAPSIZE=100" to "CONF_SWAPSIZE=1024" (I'm using model B with 512MB, so the recommended value is 2*RAM size, and of course you need a bigger SD card at least 2GB free space available)  
>4. Save the change to dphys-swapfile file and go to root directory using cd /  
>5. type in "sudo /etc/init.d/dphys-swapfile stop" to stop the current swap file  
>6. type in "sudo /etc/init.d/dphys-swapfile start" to create new swap file with 1024MB size, you should see a message "generating swapfile ... of 1024MBytes"  
>7. Start R and install RSQLite package like normal, you should not see the error anymore. It will take a while to complete the installation.  
>8. You can repeat step 2 to step 6 if you don't want to allocate 1GB for swap file, change back CONF_SWAPSIZE to 100 to get back the space u need.  



## W1 for DS18B20
`sudo modprobe w1-gpio && sudo modprobe w1_therm`  
`sudo vim /etc/modules #add`  
`w1-gpio `  
`w1_therm `  

`sudo vim /boot/config.txt #add `  
`dtoverlay=w1-gpio #pin4`  

`sudo reboot`  

`ls -l /sys/bus/w1/devices/`
`cat /sys/bus/w1/devices/28-00000283c6cd/w1_slave`

`cat /sys/bus/w1/devices/28-00000283c6cd/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}'`  

# Set crontab
`crontab -e`#add
* * * * * /home/pi/tempsensor/scantemp.sh
@reboot /home/pi/tempsensor/alarm.sh
0 9 * * 1 /home/pi/tempsensor/sendemail.sh





