library(dplyr)
library(ggplot2)

nei_data <- tbl_df(readRDS("summarySCC_PM25.rds"))
scc_data <- tbl_df(readRDS("Source_Classification_Code.rds"))

## get data for Baltimore, MD
baltimore_data <- nei_data %>% filter(fips == "24510")

## group data by type(point, nonpoint, onroad, nonroad) and year
by_type <- baltimore_data %>% group_by(type, year)

## calculate total emissions for each type and year
d <- by_type %>% summarise(sum(Emissions))
names(d) <- c("type", "year", "total_emissions")

## build a plot
png("plot3.png", width = 600, height = 600)

plot <- qplot(year, total_emissions, facets = . ~ type, data = d,
              xlab = "Year", ylab = "Emissions (tons)", ## add a regression line and center the title
              main = "Emissions from PM2.5 by sources in Baltimore, MD (1999–2008)") + geom_smooth(method = "lm") + theme(plot.title = element_text(hjust = 0.5)) 
print(plot)
dev.off()