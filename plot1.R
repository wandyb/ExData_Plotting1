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

## Plot 1
par(bg = "white")
hist(data$Global_active_power, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "Red")

## Saving to file
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()
