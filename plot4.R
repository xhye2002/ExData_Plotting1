library(data.table)

#download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
tmpFile<-tempfile();
download.file(fileUrl, tmpFile);

unzip(tmpFile, exdir = getwd());
unlink(tmpFile);

#find row range of the data between Date 1/12/2007 and 2/12/2007
file<-"household_power_consumption.txt";
fdata<-fread(file, header=TRUE);
rows<-which(fdata$Date == "1/2/2007" | fdata$Date == "2/2/2007");

#read data between 1/12/2007 and 2/12/2007
startRow<-rows[1];
colNames <- read.table(file, sep=";", head=TRUE, nrows=1)
data<-read.table(file, header = TRUE, sep=";", na.strings=c("?"), skip = startRow - 1, nrow = length(rows));

colnames(data)<-colnames(colNames);
data$DateTime <- strptime(paste(data$Date, data$Time, sep=","), format="%d/%m/%Y,%H:%M:%S")


#plot 4
png("plot4.png", width = 480, height = 480, bg = "transparent")
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma=c(0, 0 , 2, 0))
with(data, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab="Global Active Power"));
with(data, plot(DateTime, Voltage, type = "l", xlab="datetime"))

with(data, plot(DateTime, Sub_metering_1, type= "l", xlab = "", ylab = "Energy sub metering"));
with(data, lines(DateTime, Sub_metering_2, col="red" ));
with(data, lines(DateTime, Sub_metering_3, col = "blue"));
legend("topright", lwd = 1, bty = "n", col=c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(data, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime"));
dev.off();