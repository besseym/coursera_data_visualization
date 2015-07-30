

setwd("/Users/michaelbessey/Education/Coursera/DataMining/DataVisualization/projects/assignment1")

library(reshape)
library(ggplot2)

df <- read.table("data/ExcelFormattedGISTEMPDataTXT.txt", header = TRUE, sep = "\t", strip.white=TRUE, na.strings=c("***", "****", "", "NA"))
head(df)

sapply(df, class)
summary(df)

v_names <- names(df)
v_names_zone <- c()


df_monthly <- df[,c("Year", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")]
head(df_monthly)
df_monthly_m <- melt(df_monthly, id=c("Year"), variable_name="Month")
head(df_monthly_m)

ggplot(df_monthly_m, aes(x=Month, y=value, group=Year)) + geom_line()


df_zone <- df[,c("Year", "J.D", "D.N", "DJF", "MAM", "JJA", "SON")]
head(df_zone)

df_zone_m <- melt(df_zone, id=c("Year"), variable_name="Zone")
head(df_zone_m)

ggplot(df_zone_m, aes(x=Year, y=value, group=Zone)) + geom_line(aes(colour = Zone))
unique(df_zone_m$Zone)
