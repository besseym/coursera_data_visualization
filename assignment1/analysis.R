

setwd("/Users/michaelbessey/Education/Coursera/DataMining/DataVisualization/projects/assignment1")
setwd("/Users/besseym/Personal/Education/Coursera/DataMining/DataVisualization/projects/assignment1/")

library(reshape)
library(ggplot2)
library(plyr)

df <- read.table("data/ExcelFormattedGISTEMPDataTXT.txt", header = TRUE, sep = "\t", strip.white=TRUE, na.strings=c("***", "****", "", "NA"))
head(df)

sapply(df, class)
summary(df)

v_names <- names(df)

?apply
l_has_missing <- apply(df, 1, function(x){sum(is.na(x)) <= 0})

df <- df[l_has_missing,]


df_monthly <- df[,c("Year", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")]
head(df_monthly)
df_monthly_m <- melt(df_monthly, id=c("Year"), variable_name="Month")
head(df_monthly_m)

write.csv(df_monthly_m, file = "monthly.csv")

l_decade <- df_monthly_m$Year > 1900 & (df_monthly_m$Year %% 10) == 0
df_monthly_decade <- df_monthly_m[l_decade,]

df_monthly_sum_by_year <- ddply(df_monthly_m,.(Year),summarize,value=sum(value))
df_monthly_sum_by_year
ddply(df_monthly_m,.(Month),summarize,value=sum(value))
ddply(df_monthly_m,.(Month),summarize,value=mean(value))

#Decade by Month
v_year <- unique(df_monthly_decade$Year)
v_year[order(v_year, decreasing = TRUE)]
f_year <- factor(df_monthly_decade$Year, levels = v_year[order(v_year, decreasing = TRUE)])
p <- ggplot(df_monthly_decade, aes(x=Month, y=value, group=Year))
p <- p + geom_line(size = 1.5, aes(colour = f_year))
p <- p + geom_point(size = 2.5, aes(colour = f_year))
p <- p + scale_colour_brewer(palette="Paired")
#p <- p + geom_text(aes(label = value), vjust=-0.8)
p <- p + labs(title = "Total Average Temperature Across All Zones per Decade", x = "Month", y = "Temperature") 
p <- p + theme_grey()
p

saveChart(p, "decade_by_month")

#ggplot(df_monthly_m, aes(x=Month, y=value, group=Month)) + geom_line(aes(colour = Year))

# distribution of zones
ggplot(df_monthly_m, aes(Month, value)) + geom_boxplot() + coord_flip()
ggplot(df_monthly_m, aes(x=value)) + geom_histogram() + facet_grid(. ~ Month)


df_zone <- df[,c("Year", "J.D", "D.N", "DJF", "MAM", "JJA", "SON")]
head(df_zone)

df_zone_m <- melt(df_zone, id=c("Year"), variable_name="Zone")
head(df_zone_m)

write.csv(df_zone_m, file = "zone.csv")

ggplot(df_zone_m, aes(x=Year, y=value)) + geom_line(aes(colour = Zone))
ggplot(df_zone_m, aes(x=Year, y=value, group=Zone)) + geom_point(aes(colour = Zone)) + annotate("text", label = "plot mpg vs. wt", x = 2000, y = 50, size = 8, colour = "red")
ggplot(df_zone_m, aes(x=Year, y=value, group=Zone)) + geom_line() + facet_grid(. ~ Zone)
ggplot(df_zone_m, aes(x=Year, y=value, group=Zone)) + geom_line(aes(colour = Zone))

ggplot(df_zone_m, aes(x=value)) + geom_histogram() + facet_grid(. ~ Zone)

unique(df_zone_m$Zone)

# distribution of zones
ggplot(df_zone_m, aes(Zone, value)) + geom_boxplot()

df_zone_sum_by_year <- ddply(df_monthly_m,.(Year),summarize,value=sum(value))

sum(df_zone_sum_by_year$value != df_monthly_sum_by_year$value)


saveChart <- function(p, name, w = 16.18, h = 10){
  
  chartName = paste(name, ".png", sep = "")
  ggsave(filename=chartName, plot = p, dpi=75, width = w, height = h)
}
