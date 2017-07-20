library(dplyr)
library(ggplot2)

nei_data <- tbl_df(readRDS("summarySCC_PM25.rds"))
scc_data <- tbl_df(readRDS("Source_Classification_Code.rds"))

## find source classification codes for coal combustion-related sources
coal_related <- scc_data %>% filter(grepl("Coal", Short.Name))

## get all coal related codes
coal_ids <- coal_related %>% select(SCC)

## get all coal-related observations from NEI data
coal_data <- filter(nei_data, SCC %in% coal_ids$SCC)

## and group them by year
coal_data <- coal_data %>% group_by(year)

## calculate total emissions for every year
summary <- coal_data %>% summarise(sum(Emissions))
names(summary) <- c("year", "total_emissions")

## build the plot
png("plot4.png", width = 600, height = 600)
plot <- qplot(year, total_emissions, data = summary, xlab = "Year", ylab = "Total Emission (tons)", ## add a regression line and center the title
              main = "Emissions from coal combustion-related sources across the US (1999-2008)") + geom_smooth(method = "lm") + theme(plot.title = element_text(hjust = 0.5))

print(plot)
dev.off()