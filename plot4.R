# source of household consumption data
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile = "consumption.zip"
if(!file.exists("household_power_consumption.txt")) {
  download.file(fileURL, destfile)
  unzip(destfile)
}

# read in only data from dates 2007-02-01, 2007-02-02
library(sqldf)
consumption <- read.csv.sql(file="household_power_consumption.txt", sql = "select * from file where `Date` in ('1/2/2007', '2/2/2007')", header = TRUE, sep = ";")
# consumption_all <- read.table(file="household_power_consumption.txt", header = TRUE, sep = ";")

# convert Date and Time fields to Date/Time class
library(lubridate)
consumption$Date <- as.Date(consumption$Date, "%d/%m/%Y")
consumption$Time <- strptime(consumption$Time, "%H:%M:%S")
date(consumption$Time) <- consumption$Date # replace date component of Time field with data from Date field

# plot graph and send to plot4.png
png(file="plot4.png", height=480, width=480)
par(mfrow=c(2,2), mar=c(4,4,2,2), oma=c(1,1,1,1))
with(consumption, {
  plot(Time, Global_active_power, type="l", xlab="", ylab="Global Active Power")
  plot(Time, Voltage, type="l", xlab="datetime", ylab="Voltage")
  plot(Time, Sub_metering_1, type="l", col="black", xlab="", ylab="Energy sub metering"); points(Time, Sub_metering_2, type="l", col="red"); points(Time, Sub_metering_3, type="l", col="blue"); legend("topright", lty=c(1,1,1), col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Time, Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
})
dev.off()