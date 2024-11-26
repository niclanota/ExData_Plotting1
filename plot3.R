# Load required libraries
library(data.table)

# Read the dataset
data <- fread("data/household_power_consumption.txt", 
              sep = ";", 
              na.strings = "?", 
              header = TRUE)

# Convert the Date and Time columns to a single DateTime column
data[, DateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Convert the Date column to Date format and filter for the required dates
data[, Date := as.Date(Date, format = "%d/%m/%Y")]
filtered_data <- data[Date %in% as.Date(c("2007-02-01", "2007-02-02"))]

# Remove rows with NA values
filtered_data <- filtered_data[!is.na(Sub_metering_1) & !is.na(Sub_metering_2) & !is.na(Sub_metering_3) & !is.na(DateTime)]

# Create the plot with custom x-axis ticks and sub-metering lines
png("plot3.png", width = 480, height = 480) # Open a PNG device
plot(filtered_data$DateTime, 
     filtered_data$Sub_metering_1, 
     type = "l", # Line plot
     xlab = "", # No x-axis label
     ylab = "Energy sub metering", # Y-axis label
     col = "black", # Black line for Sub_metering_1
     lwd = 1, # Line width
     xaxt = "n") # Suppress default x-axis ticks

# Add additional lines for Sub_metering_2 and Sub_metering_3
lines(filtered_data$DateTime, filtered_data$Sub_metering_2, col = "red", lwd = 1) # Sub_metering_2 in red
lines(filtered_data$DateTime, filtered_data$Sub_metering_3, col = "blue", lwd = 1) # Sub_metering_3 in blue

# Add custom x-axis: day-of-week ticks
axis.POSIXct(1, 
             at = seq(min(filtered_data$DateTime), max(filtered_data$DateTime) + 86400, by = "day"), 
             format = "%a") # Format: day of the week (e.g., Thu, Fri, Sat)

# Add legend
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       lty = 1, # Line type
       lwd = 1) # Line width

dev.off() # Close the PNG device
