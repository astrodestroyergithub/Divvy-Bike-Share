# update working directory to this script path
library(rstudioapi)
script_dir = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(script_dir))
getwd()

# load packages
library(tidyverse)
library(dplyr)

# load the csv file for analysis
df <- read_csv("divvy-tripdata_cleaned.csv")

# aggregating the trip duration for each date
df2 = aggregate(df$trip_duration, by=list(date=df$date), FUN=sum)

df3 = df2 %>%
  rename("trip_duration"="x")

# writing the resultant data frame into a csv file
write_csv(df3, "aggregate_trip_duration_date.csv")
