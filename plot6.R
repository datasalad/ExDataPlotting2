library(dplyr)
library(ggplot2)

nei_data <- tbl_df(readRDS("summarySCC_PM25.rds"))
scc_data <- tbl_df(readRDS("Source_Classification_Code.rds"))

## find source classification codes for motor vehicle sources
vehicle_related <- filter(scc_data, grepl("Vehicle", Short.Name) | grepl("Vehicle", EI.Sector))

## get all coal related codes
vehicle_ids <- vehicle_related %>% select(SCC)

## get all motor vehicle-related observations from NEI data in Baltimore, MD
motor_data_baltimore <- nei_data %>% filter(SCC %in% vehicle_ids$SCC & fips == "24510")
motor_data_baltimore <- motor_data_baltimore %>% mutate(city = "Baltimore")

## get all motor vehicle-related observations from NEI data in LA
motor_data_la <- nei_data %>% filter(SCC %in% vehicle_ids$SCC & fips == "06037")
motor_data_la <- motor_data_la %>% mutate(city = "Los Angeles")

## combine data for Baltimore and LA
data <- rbind(motor_data_la, motor_data_baltimore)

## group by year and city
by_year_city <- data %>% group_by(year, city)

## summarise by total emissions
summary <- by_year_city %>% summarise(sum(Emissions))
names(summary) <- c("year", "city", "total_emissions")

## build the plot
png("plot6.png", width = 600, height = 600)
plot <- qplot(year, total_emissions, data = summary, facets = . ~ city) + 
    geom_smooth(method = "lm", lty = 2, lwd = 0.5) +
    labs(x = "Year", y = "Total emissions ( tons)") +
    labs(title = "PM2.5 Emissions from Motor Vehicles (1999-2008)") +
    theme(plot.title = element_text(hjust = 0.5))
print(plot)
dev.off()