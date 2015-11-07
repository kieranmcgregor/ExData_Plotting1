library(dplyr)

if(!exists("./power.zip")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "power.zip", method = "curl")
}

#Extract file
powerUnzip <- unzip(("power.zip"), files = "household_power_consumption.txt")

#Set constants
firstDateTime <- strptime("2006-12-16 17:24:00", "%Y-%m-%d %H:%M:%S")
startDateTime <- strptime("2007-02-01 00:01:00", "%Y-%m-%d %H:%M:%S")

#Calculate number of lines to skip
daySkips <- startDateTime - firstDateTime
minuteSkips <- as.numeric(daySkips) * 24 * 60

#Calculate size of block of desired data
dataBlock <- 48 * 60

#Construct table with proper column names
powerDataColNames <- read.table(powerUnzip, 
                                nrows = 1,
                                sep = ";",
                                header = FALSE,
                                stringsAsFactors = FALSE)
powerData <- read.table(powerUnzip,
                        skip = minuteSkips,
                        nrows = dataBlock,
                        sep = ";")
colnames(powerData) <- unlist(powerDataColNames)

#Add Day Of The Week Column
powerData <- mutate(powerData, Day_Of_The_Week = ifelse(powerData$Date == "1/2/2007",
                                                        paste("Thursday",
                                                              powerData$Date,
                                                              powerData$Time,
                                                              sep = " "),
                                                        paste("Friday",
                                                              powerData$Date,
                                                              powerData$Time,
                                                              sep = " ")))
powerData$Date <- as.POSIXct(powerData$Day_Of_The_Week, format = "%A %d/%m/%Y %H:%M:%S")

#Construct Plot3
plot(powerData$Date,
     powerData$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy Sub Metering")
lines(powerData$Date,
      powerData$Sub_metering_2,
      col = "red")
lines(powerData$Date,
      powerData$Sub_metering_3,
      col = "blue")
legend("topright",
       legend = c("Sub_metering_1",
         "Sub_metering_2",
         "Sub_metering_3"),
       lty = 1,
       col = c("black", "red", "blue"),
       cex = 0.75)

#Save Plot3 to PNG file
png(filename = "plot3.png", width = 480, height = 480)
plot(powerData$Date,
     powerData$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy Sub Metering")
lines(powerData$Date,
      powerData$Sub_metering_2,
      col = "red")
lines(powerData$Date,
      powerData$Sub_metering_3,
      col = "blue")
legend("topright",
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"),
       lty = 1,
       col = c("black", "red", "blue"),
       cex = 0.75)
dev.off()