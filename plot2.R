# Load required libraries
library(data.table)

# Step 1: Read the dataset
data <- fread("data/household_power_consumption.txt", 
              sep = ";", 
              na.strings = "?", 
              header = TRUE)

# Step 2: Convert the Date and Time columns to a single DateTime column
data[, DateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Step 3: Convert the Date column to Date format and filter for the required dates
data[, Date := as.Date(Date, format = "%d/%m/%Y")]
filtered_data <- data[Date %in% as.Date(c("2007-02-01", "2007-02-02"))]

# Step 4: Create the line plot and save it as a PNG file
png("plot2.png", width = 480, height = 480) # Open a PNG device
plot(filtered_data$DateTime, 
     filtered_data$Global_active_power, 
     type = "l", # Line plot
     col = "black", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n") # Suppress default x-axis ticks

# Custom x-axis: Add day-of-week ticks, including an additional day
axis.POSIXct(1, 
             at = seq(min(filtered_data$DateTime), max(filtered_data$DateTime) + 86400, by = "day"), 
             format = "%a") 
dev.off() # Close the PNG device
