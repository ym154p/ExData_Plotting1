if(!file.exists("exdata-data-household_power_consumption.zip")) {
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
}

 fi <- file(file)
# 
# install.packages("sqldf")
if (!require("sqldf")) {
  install.packages("sqldf")
} 

library(sqldf)

df <- sqldf("select * from fi where Date IN ('1/2/2007', '2/2/2007')",
            file.format = list(header = TRUE, sep = ";"))

# close the connection
close(fi)


## Getting full dataset
# data_full <- read.csv("./household_power_consumption.txt", header=T, sep=';', na.strings="?", 
#                       nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
# data_full$Date <- as.Date(data_full$Date, format="%d/%m/%Y")
# 
# ## Subsetting the data
# df <- subset(data_full, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
# rm(data_full)

## Converting dates
datetime <- strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S")
df$Date <- as.POSIXct(datetime)


## Plot 3
with(df, {
  plot(Sub_metering_1~Date, type="l",
       ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~Date,col='Red')
  lines(Sub_metering_3~Date,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()