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
filtered_data <- filtered_data[!is.na(Global_active_power) & 
                                 !is.na(Voltage) & 
                                 !is.na(Global_reactive_power) & 
                                 !is.na(Sub_metering_1) & 
                                 !is.na(Sub_metering_2) & 
                                 !is.na(Sub_metering_3) & 
                                 !is.na(DateTime)]

# Custom x-axis ticks (days of the week)
x_ticks <- seq(min(filtered_data$DateTime), max(filtered_data$DateTime) + 86400, by = "day")

# Set up a 2x2 panel layout
png("plot4.png", width = 480, height = 480) # Open a PNG device
par(mfrow = c(2, 2)) # 2x2 layout

# Plot 1: Global Active Power
plot(filtered_data$DateTime, 
     filtered_data$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power", 
     col = "black",
     xaxt = "n") # Suppress default x-axis ticks
axis.POSIXct(1, at = x_ticks, format = "%a") # Add day-of-week ticks

# Plot 2: Voltage
plot(filtered_data$DateTime, 
     filtered_data$Voltage, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Voltage", 
     col = "black",
     xaxt = "n") # Suppress default x-axis ticks
axis.POSIXct(1, at = x_ticks, format = "%a") # Add day-of-week ticks

# Plot 3: Energy Sub-Metering
plot(filtered_data$DateTime, 
     filtered_data$Sub_metering_1, 
     type = "l", 
     xlab = "", 
     ylab = "Energy sub metering", 
     col = "black",
     xaxt = "n") # Suppress default x-axis ticks
axis.POSIXct(1, at = x_ticks, format = "%a") # Add day-of-week ticks
lines(filtered_data$DateTime, filtered_data$Sub_metering_2, col = "red")
lines(filtered_data$DateTime, filtered_data$Sub_metering_3, col = "blue")
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       lty = 1, 
       lwd = 1, 
       bty = "n") # Remove legend box outline

# Plot 4: Global Reactive Power
plot(filtered_data$DateTime, 
     filtered_data$Global_reactive_power, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Global Reactive Power", 
     col = "black",
     xaxt = "n") # Suppress default x-axis ticks
axis.POSIXct(1, at = x_ticks, format = "%a") # Add day-of-week ticks

dev.off() # Close the PNG device
