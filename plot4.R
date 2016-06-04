library(dplyr)
library(lubridate)
library(data.table)

## Download data set
fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile= "./data/power_consumption.zip", method = "curl")
file <- unzip("./data/power_consumption.zip")
unlink(fileUrl)

## read in data
power <- fread(file, header = TRUE, sep = ";", na.strings="?",stringsAsFactors = FALSE)
power$Date <- as.Date(power$Date, format = "%d/%m/%Y")
data <- subset(power, subset = (Date >= "2007-02-01" & Date <= "2007-02-02"))

## remove power data to free some memory 
rm(power)

## check if there are any NA values in the dataframe data
sapply(data, function(x) sum(is.na(x)))

## convert Datetime
datetime <- paste(as.Date(data$Date), data$Time)
data$Datetime <- as.POSIXct(datetime)

## Plot 4
#  set parameters
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
#  subplot 1
plot(Global_active_power ~ Datetime, data = data, type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)")

#  subplot 2
plot(Voltage ~ Datetime, data = data, type = "l",
     xlab = "datetime", ylab = "Voltage")

#  subplot 3
with(data, {
        plot(Sub_metering_1 ~ Datetime, type="l", 
             ylab = "Global active power (kilowatts",  xlab = "")
        lines(Sub_metering_2 ~ Datetime, col = "red")
        lines(Sub_metering_3 ~ Datetime, col = "blue")
})
# Add legend
legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


#  subplot 4
plot(Global_reactive_power ~ Datetime, data = data, type = "l",
     xlab = "datetime", ylab = "Global reactive power")

## Saving to file
dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()
