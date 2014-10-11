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

#plot 1
png("plot1.png", width = 480, height = 480, bg = "transparent")
par(mfrow = c(1, 1), mar = c(4, 4, 2, 2), oma = c(1, 1, 1, 1))
hist(data$Global_active_power, col="red", xlab = "Global Active Power (kilowatts)", main ="Global Active Power")
dev.off();