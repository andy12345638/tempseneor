library(magrittr)
library(shiny)
library(RMySQL)
library(DBI)
rmysql.settingsfile <- "~/.mylogin.cnf"
rmysql.db <- "tempdb"
drv <- dbDriver("MySQL")
#temp120=read.csv("~/data")
#con <- dbConnect(drv, default.file = rmysql.settingsfile, group = rmysql.db, user = NULL, password = NULL)

server <- function(input, output,session) {

  conn <- dbConnect(MySQL(),, default.file = rmysql.settingsfile, group = rmysql.db, user = NULL, password = NULL)
  temp120 = dbGetQuery(conn,"select * from tempdb.temp where time > (now() - INTERVAL 2 HOUR) LIMIT 120;")
  temp10080 = dbGetQuery(conn,"select * from tempdb.temp where time > (now() - INTERVAL 148 HOUR) LIMIT 10080;")

  dbDisconnect(conn)  

  #sqldf=as.data.frame(sqldf,stringsAsFactors=FALSE)
  temp120$timestamp%<>%strptime(., "%Y-%m-%d %H:%M:%S")
  temp10080$timestamp%<>%strptime(., "%Y-%m-%d %H:%M:%S")
  
  max120=max(temp120[,2:5])
  min120=min(temp120[,2:5])
  
  output$currentVersion <- renderText({
    paste("現在版本",tail(temp120$timestamp,1))
  })
  output$currentTime <- renderText({
    paste("現在時間", Sys.time())
  })
  output$currenttemp1 <- renderText({
    paste("現在設備溫度", tail($temp1,1),"度")
  })  
  #output$currentdays <- renderText({
  #  paste("系統已運作", length(sqldaykwh$date),"天")
  #})
    output$averagekwh <- renderText({
      paste("平均溫度", mean(temp120[,2]),"度")
    })
#  output$plottemp120 <- renderPlot({
#    plot(temp120$timestamp,temp120$temp1,type="l",main="兩個小時內的設備溫度",xlab="Time",ylab="溫度",ylim=c(20,35))
#    lines(temp120$timestamp,temp120$temp1,col=”red”,lwd=2.5)
#    par(new=T)
#    plot(temp120$timestamp,temp120$temp2,type="l",main="",xlab="",ylab="",xaxt="n",yaxt="n",col="green",ylim=c(20,35))
#    par(new=T)
#    plot(temp120$timestamp,temp120$temp3,type="l",main="",xlab="",ylab="",xaxt="n",yaxt="n",col="blue",ylim=c(20,35))
#    par(new=T)
#    plot(temp120$timestamp,temp120$temp4,type="l",main="",xlab="",ylab="",xaxt="n",yaxt="n",col="brown",ylim=c(20,35))
#    abline(h=30,col="red")
#    	legend("topright", # places a legend at the appropriate place 
#    	    c("Temp1","Temp2","Temp3","Temp4","30 degree"), # puts text in the legend
#    	    lty=c(1,1,1,1,1), # gives the legend appropriate symbols (lines)
#    	    lwd=c(2.5,2.5,2.5,2.5,2.5),col=c("black","green","blue","brown","red")# gives the legend lines the correct color and width
#    	) 
#
#        })  
    output$plottemp120 <- renderPlot({
    plot(temp120$timestamp,temp120$temp1,type="n",main="兩個小時內的設備溫度",xlab="Time",ylab="溫度",ylim=c(20,35))
    lines(temp120$timestamp,temp120$temp1,col="black",lwd=2.5)
    lines(temp120$timestamp,temp120$temp2,col="green",lwd=2.5)
    lines(temp120$timestamp,temp120$temp3,col="blue",lwd=2.5)
    lines(temp120$timestamp,temp120$temp4,col="brown",lwd=2.5)
    abline(h=30,col="red")
    	legend("topright", # places a legend at the appropriate place 
    	    c("Temp1","Temp2","Temp3","Temp4","30 degree"), # puts text in the legend
    	    lty=c(1,1,1,1,1), # gives the legend appropriate symbols (lines)
    	    lwd=c(2.5,2.5,2.5,2.5,2.5),col=c("black","green","blue","brown","red")# gives the legend lines the correct color and width
    	) 

        })

 

}
