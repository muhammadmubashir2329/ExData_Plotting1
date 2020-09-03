## check if file does not exit check for data.zip, if that too does not exist,
## download the data and extract the data
if(!file.exists("./household_power_consumption.txt")){
  if(!file.exists("./data.zip")){
    ## download date = Sep, 2, 2020 
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  "data.zip")
  }
  unzip("./data.zip")
}

data <- read.csv("household_power_consumption.txt", sep = ";", header = TRUE, 
                 stringsAsFactors = FALSE, na.strings="?")

##load dplyr and lubridate package
library(dplyr)
library(lubridate)
data <- tibble::as_tibble(data)
#filtered_data <- filter(data, Date %in% c("1/2/2007","2/2/2007"))
data$Date <- as.Date(data$Date, "%d/%m/%Y")
filtered_data <- filter(data, 
                        data$Date == as.Date("01/02/2007","%d/%m/%Y" ) | data$Date ==as.Date("02/02/2007","%d/%m/%Y"))
filtered_data$Global_active_power <- as.numeric(filtered_data$Global_active_power)
date_time <- paste(filtered_data$Date, filtered_data$Time)
filtered_data$Datetime <- as.POSIXct(date_time)
#filtered_data <- mutate(filtered_data, 
#                        datetime = mapply(to_datetime, filtered_data$Date, filtered_data$Time))

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(filtered_data, {
  plot(Global_active_power~Datetime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  plot(Voltage~Datetime, type="l", 
       ylab="Voltage (volt)", xlab="")
  plot(Sub_metering_1~Datetime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~Datetime,col='Red')
  lines(Sub_metering_3~Datetime,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power~Datetime, type="l", 
       ylab="Global Rective Power (kilowatts)",xlab="")
})

dev.copy(png, file = "plot4.png",  width = 480, height = 480)
dev.off()