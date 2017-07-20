library(dplyr)
library(ggplot2)

nei_data <- tbl_df(readRDS("summarySCC_PM25.rds"))
scc_data <- tbl_df(readRDS("Source_Classification_Code.rds"))

## find source classification codes for motor vehicle sources
vehicle_related <- filter(scc_data, grepl("Vehicle", Short.Name) | grepl("Vehicle", EI.Sector))

## get all the coal-related codes
vehicle_ids <- vehicle_related %>% select(SCC)

## get all the motor vehicle-related observations from NEI data in Baltimore, MD
motor_data <- nei_data %>% filter(SCC %in% vehicle_ids$SCC & fips == "24510")

## group the data by year
motor_data_by_year <- motor_data %>% group_by(year)

## summarise by total emissions
summary <- motor_data_by_year %>% summarise(sum(Emissions))

names(summary) <- c("year", "total_emissions")

## build the plot
png("plot5.png", width = 600, height = 600)
plot <- qplot(year, total_emissions, data=summary, xlab = "Year",
              ylab = "Total emissions (tons)",
              main = "Emissions from motor vehicle sources in Baltimore City (1999–2008)"
) + geom_line() + geom_smooth(method = "lm", linetype = "dashed", se = FALSE) + theme(plot.title = element_text(hjust = 0.5))

print(plot)
dev.off()