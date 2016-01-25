if(!file.exists("exdata-data-household_power_consumption.zip")) {
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
}

fi <- file(file)

# install.packages("sqldf")
if (!require("sqldf")) {
  install.packages("sqldf")
  } 

library(sqldf)

df <- sqldf("select * from fi where Date IN ('1/2/2007', '2/2/2007')",
            file.format = list(header = TRUE, sep = ";"))

# close the connection
close(fi)

## Converting dates
df$Date <- strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S")

## Plot 1
hist(df$Global_active_power, main="Global Active Power", 
           xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

## Saving to file
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()