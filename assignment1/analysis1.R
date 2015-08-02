

setwd("/Users/michaelbessey/Education/Coursera/DataMining/DataVisualization/projects/assignment1")
setwd("/Users/besseym/Personal/Education/Coursera/DataMining/DataVisualization/projects/assignment1/")

library(reshape)
library(ggplot2)
library(plyr)
library(scales)

?melt
?replace
?sub
?head

df <- read.table("data/ExcelFormattedGISTEMPData2TXT.txt", header = TRUE, sep = "\t", strip.white=TRUE, na.strings=c("***", "****", "", "NA"))
head(df)

df_hem <- df[,c("Year", "Glob", "NHem", "SHem")]
head(df_hem)
df_hem_m <- melt(df_hem, id=c("Year"), variable_name="Hem")
head(df_hem_m)
unique(df_hem_m$Hem)

df_glob <- df_hem_m[df_hem_m$Hem == 'Glob',]
df_nhem <- df_hem_m[df_hem_m$Hem == 'NHem',]
df_shem <- df_hem_m[df_hem_m$Hem == 'SHem',]

l_filter <- df_hem_m$Hem == 'Glob' & (df_hem_m$Year %% 10) == 0
df_glob_decade_agg <- ddply(df_hem_m[l_filter, ], .(Year), summarize, Mean_Temp = mean(value))
head(df_glob_decade_agg)

c(253,192,134) / 255

c_alpha <- 0.3

p <- ggplot()
p <- p + geom_line(data = df_hem_m, size = 1.5, aes(x=Year, y=value, group=Hem, color=Hem))
p <- p + scale_colour_manual(name = "Location", values = c("Glob" = rgb(0.4980392, 0.7882353, 0.4980392,1.0), "NHem" = rgb(0.9921569, 0.7529412, 0.5254902, c_alpha), "SHem" = rgb(0.7450980, 0.6823529, 0.8313725, c_alpha)), labels = c("Glob" = "Global", "NHem" = "N. Hemisphere", "SHem" = "S. Hemisphere"))
p <- p + geom_point(data = df_glob_decade_agg, size = 5, aes(x=Year, y=Mean_Temp)) 
p <- p + geom_text(data = df_glob_decade_agg, aes(x = Year, y = Mean_Temp, family="Arial", fontface="italic", label = paste(Mean_Temp, "°C in ", Year, sep = ""), hjust=0.3, vjust=-1.0))
p <- p + labs(x = "Year", y = "Temperature in °C")
p <- p + theme_bw() # + guides(colour=guide_legend(title="Avg. Temp in given Year"))
p <- p + theme(legend.key = element_rect(size = 0), panel.border = element_rect(size = 0))
#p <- p + annotate("text", label = "Points indicate average temperature in specified year.", x = median(df_hem_m$Year), y = 75, size = 5)
p

saveChart(p, "temp_total")


df_loc <- df[,c("Year", "X24N.90N", "X24S.24N", "X90S.24S", "X64N.90N", "X44N.64N", "X24N.44N", "EQU.24N", "X24S.EQU", "X44S.24S", "X64S.44S", "X90S.64S")]
head(df_loc)

df_loc_m <- melt(df_loc, id=c("Year"), variable_name="Loc")
head(df_loc_m)

v_loc <- sub("\\.", " ", sub("X", "", df_loc_m$Loc))

v_loc_split <- strsplit(v_loc, " ", fixed = TRUE)
v_loc_split

f_lat_clean <- function(x){
  
  x1 <- x[2]
  
  v <- sub("N|S", "", x1)
  if(v == 'EQU'){
    v <- "0"
  }
  
  v <- as.numeric(v)
  
  if(grepl('S$', x1)){
    v = -v
  }
  
  v
}



df_loc_m$lat1 = sapply(v_loc_split, f_lat_clean)
df_loc_m$lat2 = sapply(v_loc_split, f_lat_clean)
head(df_loc_m, n=20L)

df_temp_range <- df_loc_m[df_loc_m$Year %in% c(2014), ]
df_temp_range <- df_loc_m[df_loc_m$Year %% 100 == 0, ]

df_loc_m$Year > 1949

l_lat_cols <- df_loc_m$Loc %in% c('X64N.90N', 'X44N.64N', 'X24N.44N', 'EQU.24N', 'X24S.EQU', 'X44S.24S', 'X64S.44S', 'X90S.64S')
l_restict_year <- df_loc_m$Year > 1900
l_mod_year <- df_loc_m$Year %% 10 == 0
sum(l_restict_year  & l_mod_year)

df_temp_range <- df_loc_m[l_lat_cols & l_mod_year, ]
length(unique(df_temp_range$Year))


ggplot(df_temp_range, aes(x = factor(1), y = lat2, fill = value)) + geom_bar(stat = "identity")
ggplot(df_temp_range, aes(x= factor(1), y= lat2, fill=value)) + geom_area(stat="identity")

ggplot(df_temp_range) + geom_ribbon(stat="bin", aes(x = 1, ymin = lat1, ymax = lat2, group = Loc, fill=value), alpha= 0.5) + scale_fill_gradient2(low = muted("blue"), mid = "white", high = muted("red"), midpoint = 0, space = "rgb", guide = "colourbar") + facet_grid(. ~ Year) + facet_wrap( ~ Year, ncol=7)

?aes
?geom_ribbon


library(maps)
library(ggplot2)
map.data <- map_data("world")
ggplot() + geom_polygon(aes(long,lat, group=group), fill="grey65", data=map.data) + theme_bw()

p <- ggplot()
p <- p + geom_polygon(aes(long,lat, group=group), fill="grey65", data=map.data)
p <- p + theme_bw()
p <- p + geom_ribbon(data = df_temp_range, stat="bin", aes(x = 1, ymin = lat1, ymax = lat2, group = Loc, fill=value), alpha= 0.5) 
p <- p + scale_fill_gradient2(name = "Temp. in °C", low = "dodgerblue3", mid = "lightyellow3", high = "firebrick3", midpoint = 0, space = "rgb", guide = "colourbar") 
p <- p + facet_grid(. ~ Year) + facet_wrap( ~ Year, ncol=5)
p <- p + labs(y = "Latitude") 
p <- p + theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.x=element_blank())
p

saveChart(p, "temp_by_latitude")


