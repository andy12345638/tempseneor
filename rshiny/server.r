#suntempsql.sh 2017/05/26 change to bash>sql>r no sqldaykwh table
#db=solar_schema
#table=solar_data2
#include c( time | v | a | w | wh | D1temp | D2temp )
library(magrittr)
library(shiny)
library(RMySQL)
server <- function(input, output,session) {
  #data=read.csv("~/Sync/log5.csv",header=F,sep=" ", stringsAsFactors=FALSE)
  conn <- dbConnect(MySQL(),host="140.112.57.110", dbname = "solar_schema", username="rpi", password="a09876543")
  #sqldf = dbGetQuery(conn, "SELECT * FROM solar_schema.solar_data;")
  sqldf = dbGetQuery(conn,"select * from solar_schema.solar_data2 where time > (now() - INTERVAL 72 HOUR) LIMIT 4320;")
  daysqldf = dbGetQuery(conn,"select * from solar_schema.solar_data2 where  DATE(time) = CURDATE() and hour(time)  BETWEEN '05' AND '18';")
  ghost_w=dbGetQuery(conn,"select round(avg(w),0) from solar_schema.solar_data2 where   hour(time)=hour(now()) and minute(time)=minute(now()) group by date_format(time,'%H:%i');")
  ghost_hs=dbGetQuery(conn,"select date_format(time,'%H:%i') as t,avg(w) as w from solar_schema.solar_data2 group by date_format(time,'%H:%i');")
  

  sqldaykwh=dbGetQuery(conn,"select from_days(to_days(time)) as date,max(wh) as max, min(wh) as min ,max(wh) - min(wh) as daywh from solar_data2 group by from_days(to_days(time));")
  dbDisconnect(conn)  
  sqldf=as.data.frame(sqldf,stringsAsFactors=FALSE)
  sqldf$time%<>%strptime(., "%Y-%m-%d %H:%M:%S")
  daysqldf=as.data.frame(daysqldf,stringsAsFactors=FALSE)
  daysqldf$time%<>%strptime(., "%Y-%m-%d %H:%M:%S")
  ghost_hs=as.data.frame(ghost_hs,stringsAsFactors=FALSE)
  ghost_hs$t%<>%strptime(., "%H:%M")
  
  #df=read.csv("/home/fisher/Sync/df.csv",header=T,sep=",", stringsAsFactors=FALSE)
  #df=as.data.frame(df,stringsAsFactors=FALSE)
  #df$t%<>%strptime(., "%Y-%m-%d %H:%M:%S")
  
  #kwhday=read.csv("/home/fisher/Sync/kwhday.csv",header=T,sep=",", stringsAsFactors=FALSE)
  #kwhday%<>%as.data.frame(.,stringsAsFactors=FALSE)
  sqldaykwh%<>%as.data.frame(.,stringsAsFactors=FALSE)
  sqldaykwh$date%<>%as.Date(.,origin="1970-01-01")
#  num=dim(data)[1]/9
#  t=array(0,dim=c(num))
#  v=array(0,dim=c(num))
#  a=array(0,dim=c(num))
#  w=array(0,dim=c(num))
#  kwh=array(0,dim=c(num))
  

  output$currentVersion <- renderText({
    invalidateLater(1000*60*2, session)
    #df=read.csv("/home/fisher/Sync/df.csv",header=T,sep=",", stringsAsFactors=FALSE)
    #df=as.data.frame(df,stringsAsFactors=FALSE)
    #df$t%<>%strptime(., "%Y-%m-%d %H:%M:%S")
    
    #kwhday=read.csv("/home/fisher/Sync/kwhday.csv",header=T,sep=",", stringsAsFactors=FALSE)
    #kwhday%<>%as.data.frame(.,stringsAsFactors=FALSE)
    paste("現在版本",tail(sqldf$time,1))
  })
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("現在時間", Sys.time())
  })
  output$currentw <- renderText({
    invalidateLater(1000, session)
    paste("即時功率", tail(sqldf$w,1),"w/",tail(sqldf$a*sqldf$v,1),"w/",ghost_w,"w")
  })
  output$currentD1temp <- renderText({
    invalidateLater(1000, session)
    paste("現在設備溫度", tail(sqldf$D1temp/1000,1),"度")
  })  
  output$currentD2temp <- renderText({
    invalidateLater(1000, session)
    paste("現在空氣溫度", tail(sqldf$D2temp/1000,1),"度")
  })
  output$currentpf <- renderText({
    invalidateLater(1000, session)
    paste("現在功率因數", tail(replace(sqldf$w/(sqldf$a*sqldf$v), is.na(sqldf$w/(sqldf$a*sqldf$v)), 0),1),"%")
  })
  output$currentmeanpf <- renderText({
    invalidateLater(1000, session)
    paste("平均功率因數", mean(sqldf$w/(sqldf$a*sqldf$v),na.rm = T),"%")
  })
  output$currentodaykwh <- renderText({
    invalidateLater(1000, session)
    paste("今天產量", tail(sqldaykwh$daywh/1000,1),"度")
  })
  output$currentdays <- renderText({
    invalidateLater(1000, session)
    paste("系統已運作", length(sqldaykwh$date),"天")
  })
    output$currentkwh <- renderText({
    invalidateLater(1000, session)
    paste("累積產量", max(sqldf$wh)/1000,"度")
  })
    output$averagekwh <- renderText({
      invalidateLater(1000, session)
      paste("平均每日發電", max(sqldf$wh)/(1000*length(sqldaykwh$date)),"度")
    })
  output$plotv <- renderPlot({
    invalidateLater(1000*60*2, session)
    plot(sqldf$t,sqldf$v,type="l",main="電壓",xlab="Time",ylab="電壓(V)")
    abline(h=mean(sqldf$v),col="blue")
    })
  output$plota <- renderPlot({
    plot(sqldf$t,sqldf$a,type="l",main="電流",xlab="Time",ylab="電流(A)")})
  output$plottav <- renderPlot({
    plot(daysqldf$t,daysqldf$v*daysqldf$a,type="l",main="今日視在功率",xlab="Time",ylab="視在功率(V*A)")
    })
  output$plotav <- renderPlot({
    plot(sqldf$time,sqldf$v*sqldf$a,type="l",main="視在功率",xlab="Time",ylab="視在功率(V*A)")})
  output$plotw <- renderPlot({
    plot(sqldf$time,sqldf$w,type="l",main="有功功率",xlab="Time",ylab="有功功率(W)")
    })
  output$plotD1temp <- renderPlot({
    plot(sqldf$time,sqldf$D1temp/1000,type="l",main="現在設備溫度",xlab="Time",ylab="溫度")
    abline(h=38)
    abline(h=34)
        })
  output$plotD2temp <- renderPlot({
    plot(sqldf$time,sqldf$D2temp/1000,type="l",main="現在空氣溫度",xlab="Time",ylab="溫度")
    })
  output$plotD1D2temp <- renderPlot({
    plot(sqldf$time,sqldf$D1temp/1000,type="l",ylim=c(min(sqldf$D2temp/1000)*0.98,max(sqldf$D1temp/1000)*1.02),main="混合溫度",xlab="Time",ylab="溫度")
    par(new = T)
    plot(sqldf$time,sqldf$D2temp/1000,type="l",ylim=c(min(sqldf$D2temp/1000)*0.98,max(sqldf$D1temp/1000)*1.02), axes=F, xlab=NA, ylab=NA, cex=1.2,col="green")
    })
  output$plotkwh <- renderPlot({
    plot(sqldf$time,sqldf$wh/1000,type="l",main="累計千瓦時",xlab="Time",ylab="度(KWH)")})
  output$plotwav <- renderPlot({
    plot(sqldf$time,sqldf$w/(sqldf$a*sqldf$v),type="l",main="功率因數",xlab="Time",ylab="功率因數(%)")
    abline(h=c(0.7,0.9,1))
    abline(h=mean(sqldf$w/(sqldf$a*sqldf$v),na.rm = T),col="blue")
    })
  output$plotkwht <- renderPlot({  
    par(mar = c(5,5,2,5))
    plot(sqldf$time,sqldf$wh/1000,type="l",main="功率與累計產量",xlab="Time",ylab="度(KWH)")
    par(new = T)
    plot(sqldf$time,sqldf$v*sqldf$a,type="l", axes=F, xlab=NA, ylab=NA, cex=1.2,col="green")
    axis(side = 4)
    mtext(side = 4, line = 3, 'W=A*V')
  })
  
  
  output$plotkwhday <- renderPlot({
    plot(as.Date(sqldaykwh$date,origin="1970/01/01"),sqldaykwh$daywh/1000,main="每日發電度數",xlab="Time",ylab="度(KWH)",ylim=c(0,max(sqldaykwh$daywh/1000,na.rm = T)+0.2))
    abline(h=mean(sqldaykwh$daywh/1000,na.rm = T))
    stdevs <- mean(sqldaykwh$daywh/1000,na.rm = T) + c(-1, +1) * sd(sqldaykwh$daywh/1000,na.rm = T)
    abline(h=stdevs, lty=2, lwd=4, col="blue")
    })#everyday kwh
  #output$plotmean20 <- renderPlot({
   # plot()
  #  mean(tail(sqldf[,3],5)+0.001)/mean(tail(sqldf[,3],20)+0.000001)
  #})#everyday kwh
  output$plotghosths <- renderPlot({
    plot(ghost_hs,type="l",col="blue")
  })

}
