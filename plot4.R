# First, let's download the data if it is not already in our workspace
if(!file.exists('household_power_consumption.txt'))
{
    fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(fileUrl, destfile = './household_power_consumption.zip')
    unzip('./household_power_consumption.zip', exdir = '.')
}


# There are a lot of observations in the data.
# We will only be using data from the dates 2007-02-01 and 2007-02-02. 
# We will use the alternative to read the data from just those dates rather than reading in the entire dataset 
# and subsetting to those dates.

files <- file('./household_power_consumption.txt')

mydata = read.table(text = grep("^[1,2]/2/2007",readLines(files),value=TRUE), sep =";", header = TRUE, na.strings = "?")
# since it removes the names of the column, I copy paste the first line of the document here o rename the header.
names(mydata) <- c("Date","Time", "Global_active_power","Global_reactive_power", "Voltage","Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")


# let's transform the string date as Date
mydata$Date <- as.Date(mydata$Date, format="%d/%m/%Y")

# I will add a new column combining date and time.
library(dplyr)
mydata <- mutate(mydata, DateTime = as.POSIXct(paste(as.Date(Date), Time)))


# Lets build our image as on the Readme, and store it into plot3.png
# Plot4 corresponds to 4 plots (2*2)
png(filename = './plot4.png', width = 480, height = 480, units='px')

par(mfrow = c(2,2), mar = c(4, 4, 2, 1))
# The 1st plot is the same as plot2
plot(mydata$Global_active_power ~ mydata$DateTime, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

# The 2nd is a plot of the Voltage depending on the datetime
plot(mydata$Voltage ~ mydata$DateTime, xlab = "datetime", ylab = "Voltage", type = "l")
 
# The 3rd plotis the same as plot3 : plot of the 3 types of Energy sub metering, in function of the time. 
plot(mydata$Sub_metering_1 ~ mydata$DateTime, type = "n", ylab = "Energy sub metering", xlab = "")
points(mydata$Sub_metering_1 ~ mydata$DateTime, col = "black", type = "l")
points(mydata$Sub_metering_2 ~ mydata$DateTime, col = "red", type = "l")
points(mydata$Sub_metering_3 ~ mydata$DateTime, col = "blue", type = "l")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

# The 4th plot is the Global_reactive_power depending on the datetime.
plot(mydata$Global_reactive_power ~ mydata$DateTime, xlab = "datetime", ylab = "Global_reactive_power", type = "l")



dev.off()

