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
powerData <- mutate(powerData, Day_Of_The_Week = ifelse(powerData$Date == "1/2/2007", "Thursday", "Friday"))


#Construct Plot 1
hist(powerData$Global_active_power,
     freq = TRUE,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

#Save PNG file
png(filename = "plot1.png", width = 480, height = 480)
hist(powerData$Global_active_power,
     freq = TRUE,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()
