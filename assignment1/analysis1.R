

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

ggplot(df_hem_m, aes(x=Year, y=value)) + geom_line(aes(colour = Hem))


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

df_temp_range <- df_loc_m[df_loc_m$Year > 1949 & df_loc_m$Year %% 10 == 0 & df_loc_m$Loc %in% c('X64N.90N', 'X44N.64N', 'X24N.44N', 'EQU.24N', 'X24S.EQU', 'X44S.24S', 'X64S.44S', 'X90S.64S'), ]
df_temp_range


ggplot(df_temp_range, aes(x = factor(1), y = lat2, fill = value)) + geom_bar(stat = "identity")
ggplot(df_temp_range, aes(x= factor(1), y= lat2, fill=value)) + geom_area(stat="identity")

ggplot(df_temp_range) + geom_ribbon(stat="bin", aes(x = 1, ymin = lat1, ymax = lat2, group = Loc, fill=value), alpha= 0.5) + scale_fill_gradient2(low = muted("blue"), mid = "white", high = muted("red"), midpoint = 0, space = "rgb", guide = "colourbar") + facet_grid(. ~ Year)

?aes
?geom_ribbon


library(maps)
library(ggplot2)
map.data <- map_data("world")
ggplot() + geom_polygon(aes(long,lat, group=group), fill="grey65", data=map.data) + theme_bw()
ggplot() + geom_polygon(aes(long,lat, group=group), fill="grey65", data=map.data) + theme_bw() + geom_ribbon(data = df_temp_range, stat="bin", aes(x = 1, ymin = lat1, ymax = lat2, group = Loc, fill=value), alpha= 0.5) + scale_fill_gradient2(low = muted("blue"), mid = "white", high = muted("red"), midpoint = 0, space = "rgb", guide = "colourbar") + facet_grid(. ~ Year)
?geom_ribbon




huron <- data.frame(year = 1875:1972, level = as.vector(LakeHuron))
huron$decade <- round_any(huron$year, 10, floor)
head(huron)

ggplot(huron, aes(x=year)) + geom_ribbon(aes(ymin=0, ymax=level))


