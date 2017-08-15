# tempseneor
rpi3 with ds18b20

# 材料
1.Raspberry PI 3 Model B $1800內  
2.Sandisk sd card 32G $500 內  
3.110V to USB 充電器 2.5A $300  
4.usb 充電線 30cm $100內  
5.DS18B20 溫度感應器 3米*4條 $1500 內  
6.其他焊接材料(洞洞板、電阻、杜邦頭)$300內  
共計 $4500 內  

# 架構
1.每分鐘讀取4隻溫度資料並寫入mysql #scantemp.sh  
2.每週匯出圖表給指定email sendemail.sh  
3.一個每分鐘監測溫度的迴圈，當其中一個溫度大於30度，寄出email，含30分鐘圖表，停10分鐘;若還是高於30度就再寄出，低於就寄出安全與圖表;連續三封信。三封信後舊部再寄出，直到溫度恢復，才重新有警報。#alarm.sh + alarmemail.sh
4.寄email的帳號密碼  
5.收email的列表 mail.conf  
6.寄email的bash sendemail.sh alarmemail.sh  
7.畫出30分鐘圖表的rscritp #temp120png.r  
8.畫出一週圖表的rscritp temp10080png.r  

# 事前準備
## exim4
`sudo apt-get install mutt`
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
