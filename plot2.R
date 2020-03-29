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

# plot graph and send to plot2.png
png(file="plot2.png", height=480, width=480)
with(consumption, plot(Time, Global_active_power, type="l", ylab="Global Active Power (kilowatts)"))
dev.off()