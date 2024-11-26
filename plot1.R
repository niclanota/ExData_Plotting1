# Load required libraries
library(data.table)

# Read the data
data <- fread("data/household_power_consumption.txt", 
              sep = ";", 
              na.strings = "?", 
              header = TRUE)

# Convert the Date column to Date format
data[, Date := as.Date(Date, format = "%d/%m/%Y")]

# Filter the data for the required dates (2007-02-01 and 2007-02-02)
filtered_data <- data[Date %in% as.Date(c("2007-02-01", "2007-02-02"))]

# Create the histogram and save it as a PNG file
png("plot1.png", width = 480, height = 480) # Open a PNG device
hist(filtered_data$Global_active_power, 
     col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", 
     breaks = 20) 
dev.off() # Close the PNG device

