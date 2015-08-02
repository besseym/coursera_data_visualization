

setwd("/Users/michaelbessey/Education/Coursera/DataMining/DataVisualization/projects/assignment1")
setwd("/Users/besseym/Personal/Education/Coursera/DataMining/DataVisualization/projects/assignment1/")

library(reshape)
library(ggplot2)
library(plyr)
library(scales)

df <- read.table("data/ExcelFormattedGISTEMPDataTXT.txt", header = TRUE, sep = "\t", strip.white=TRUE, na.strings=c("***", "****", "", "NA"))
head(df)

sapply(df, class)
summary(df)

v_names <- names(df)

df_monthly <- df[,c("Year", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")]
head(df_monthly)

l_has_missing <- apply(df_monthly, 1, function(x){sum(is.na(x)) > 0})

df_mc <- df_monthly[!l_has_missing,]
head(df_mc)

df_mc_m <- melt(df_mc, id=c("Year"), variable_name="Month")
head(df_mc_m)
names(df_mc_m) <- c('Year', 'Month', 'Temp')

write.csv(df_mc_m, file = "monthly.csv")

p <- ggplot(df_mc_m, aes(x=Year, y=Temp))
p <- p + geom_line(size = 1, aes(colour = Temp))
#p <- p + scale_color_gradient2(low = muted("blue"), mid = "grey", high = muted("red"), midpoint = 0, space = "rgb", guide = "colourbar")
#p <- p + scale_colour_brewer("RdBu")
p <- p + scale_color_gradient2(name = "Temp. in °C", low = "dodgerblue3", mid = "lightyellow3", high = "firebrick3", midpoint = 0, space = "rgb", guide = "colourbar")
p <- p + facet_grid(Month ~ .) +  facet_wrap( ~ Month, ncol=2) + theme_bw()
p <- p + labs(x = "Year", y = "Temperature in °C") 
p

saveChart(p, "temp_by_month", w = 12, h = 9)


l_decade <- df_mc_m$Year > 1900 & (df_mc_m$Year %% 10) == 0
df_decade <- df_mc_m[l_decade,]
head(df_decade)

v_year <- unique(df_decade$Year)
f_year <- factor(df_decade$Year, levels = v_year[order(v_year, decreasing = TRUE)])

p <- ggplot(df_decade, aes(x=Month, y=Temp, group=f_year))
p <- p + geom_line(size = 1.5, aes(colour = f_year))
p <- p + geom_point(size = 2.5, aes(colour = f_year))
p <- p + labs(x = "Month", y = "Temp. in °C") 
#p <- p + theme_bw()
#p <- p + scale_colour_brewer(palette="Paired")
p <- p + theme_grey() + guides(colour=guide_legend(title="Year"))
p

?legend

saveChart(p, "decade_by_month")


ggplot(df_decade, aes(x=Temp)) + geom_histogram() + facet_grid(. ~ Month)


saveChart <- function(p, name, w = 16.18, h = 10){
  
  chartName = paste(name, ".png", sep = "")
  ggsave(filename=chartName, plot = p, dpi=75, width = w, height = h)
}
