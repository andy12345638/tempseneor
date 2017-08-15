library("RMySQL")
conn <- dbConnect(MySQL(),host="127.0.0.1", dbname = "tempdb", username="root", password="1234")
temp.df = dbGetQuery(conn, "select * from tempdb.temp where timestamp > (now() - INTERVAL 120 minute) LIMIT 120 ;")
dbDisconnect(conn)

temp.df$timestamp=as.POSIXct(temp.df$timestamp)
#dtTime <- as.numeric(temp.df$timestamp - trunc(temp.df$timestamp, "hours"))


png("temp120png.png")
plot(temp.df$temp1~temp.df$timestamp,type="l",ylab="Temperature",xlab="Time",main=paste(head(temp.df$timestamp,1),"~",substr(tail(temp.df$timestamp,1),12,20)))
#paste(head(temp.df$timestamp,1),"~",substr(tail(temp.df$timestamp,1),12,20))
dev.off()
