library(dplyr)

nei_data <- tbl_df(readRDS("summarySCC_PM25.rds"))
scc_data <- tbl_df(readRDS("Source_Classification_Code.rds"))

## group data by year
by_year <- nei_data %>% group_by(year)

## calculate total emissions from all sources
q1 <- by_year %>% summarise(sum(Emissions))
names(q1) <- c("year", "total_emissions")

png("plot1.png", width = 480, height = 480)

## force R to not use scientific notation for y axis
options(scipen = 100) 
par(pch = 23)
plot(q1$year, q1$total_emissions, 
     type = "o", bg = "red", 
     xlab = "Year", 
     ylab = "Total PM2.5 emission from all sources (tons)", 
     main = "Total emissions from PM2.5 in the US (1999-2008)")

## add a regression line
abline(lm(q1$total_emissions ~ q1$year), col = "blue", lty = 2, lwd = 0.5)
dev.off()
