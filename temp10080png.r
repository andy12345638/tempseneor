library("RMySQL")
conn <- dbConnect(MySQL(),host="127.0.0.1", dbname = "tempdb", username="root", password="1234")
temp.df = dbGetQuery(conn, "select * from tempdb.temp where timestamp > (now() - INTERVAL 10080 minute) LIMIT 10080 ;")
dbDisconnect(conn)

temp.df$timestamp=as.POSIXct(temp.df$timestamp)

png("temp10080png.png", width = 2400, height = 800)
plot(temp.df$temp1~temp.df$timestamp,type="l",ylab="Temperature",xlab="Time",main=paste(head(temp.df$timestamp,1),"~",substr(tail(temp.df$timestamp,1),1,20)))
dev.off()
