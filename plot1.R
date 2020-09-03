

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

##load dplyr package
library(dplyr)
data <- tibble::as_tibble(data)
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data <- filter(data, 
               data$Date == as.Date("01/02/2007","%d/%m/%Y" ) | data$Date ==as.Date("02/02/2007","%d/%m/%Y"))
data$Global_active_power <- as.numeric(data$Global_active_power)


png("plot1.png", width = 480, height = 480)

hist(data$Global_active_power, col = "red", main = "Global Active Power",
     xlab = "Global Active Power (killowats)")

dev.off()
