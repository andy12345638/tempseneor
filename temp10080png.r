library("RMySQL")
conn <- dbConnect(MySQL(),host="127.0.0.1", dbname = "tempdb", username="root", password="1234")
temp.df = dbGetQuery(conn, "select * from tempdb.temp where timestamp > (now() - INTERVAL 10080 minute) LIMIT 10080 ;")
dbDisconnect(conn)

temp.df$timestamp=as.POSIXct(temp.df$timestamp)

png("temp10080png.png",width = 1200, height = 400)
#plot(temp.df$temp1~temp.df$timestamp,type="l",ylab="Temperature",xlab="Time",main=paste(head(temp.df$timestamp,1),"~",substr(tail(temp.df$timestamp,1),1,20)))


    plot(temp.df$timestamp,temp.df$temp1,type="n",main=paste(head(temp.df$timestamp,1),"~",substr(tail(temp.df$timestamp,1),1,20)),xlab="Time",ylab="溫度",ylim=c(20,35))
    lines(temp.df$timestamp,temp.df$temp1,col="black",lwd=2.5)
    lines(temp.df$timestamp,temp.df$temp2,col="green",lwd=2.5)
    lines(temp.df$timestamp,temp.df$temp3,col="blue",lwd=2.5)
    lines(temp.df$timestamp,temp.df$temp4,col="brown",lwd=2.5)
    abline(h=30,col="red")
    	legend("topright", # places a legend at the appropriate place 
    	    c("Temp1","Temp2","Temp3","Temp4","30 degree"), # puts text in the legend
    	    lty=c(1,1,1,1,1), # gives the legend appropriate symbols (lines)
    	    lwd=c(2.5,2.5,2.5,2.5,2.5),col=c("black","green","blue","brown","red")# gives the legend lines the correct color and width
    	) 
dev.off()
