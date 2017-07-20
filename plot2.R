library(dplyr)

nei_data <- tbl_df(readRDS("summarySCC_PM25.rds"))
scc_data <- tbl_df(readRDS("Source_Classification_Code.rds"))

## group data by year
by_year <- nei_data %>% group_by(year)

## filter the data for Baltimore, MD
baltimore_data <- by_year %>% filter(fips == "24510")

## calculate total emissions from all sources
q2 <- baltimore_data %>% summarise(sum(Emissions))
names(q2) <- c("year", "total_emissions")

png("plot2.png", width = 480, height = 480)

## force R to not use scientific notation for y axis
options(scipen = 100) 
par(pch = 22)
plot(q2$year, q2$total_emissions, 
     type ="o", bg = "red", 
     xlab = "Year", 
     ylab = "Total PM2.5 emission from all sources (tons)", 
     main="Total emissions from PM2.5 in the Baltimore City, Maryland")

## add a regression line
abline(lm(q2$total_emissions ~ q2$year), col = "blue", lty = 2, lwd = 0.5)
dev.off()
