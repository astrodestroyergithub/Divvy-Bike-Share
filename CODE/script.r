# update working directory to this script path
library(rstudioapi)
script_dir = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(script_dir))
getwd()

# load packages
library(readr)
library(tidyverse)
library(dplyr)
library(lubridate)
library(skimr)
library(janitor)

# load the csv file for analysis
df <- read_csv("divvy_trips.csv")
str(df)

# taking a sample from the data for simplicity
sample_df <- sample_n(df,76000,replace=F)

# writing the sample into a sample dataset
write_csv(sample_df,"sample_dataset.csv")
str(sample_df)

# loading the sample dataset
df <- read_csv("sample_dataset.csv")

# exploring various attributes of sample
colnames(df)
nrow(df)  
dim(df) 
head(df)  
str(df)  
summary(df)

# viewing the sample dataset
View(df)

# adding new columns for calculating the following for each ride
# date
# year
# month
# day
# day of the week
df$date <- as.Date(df$`START TIME`,"%m/%d/%Y")
df$year <- format(df$date,"%Y")
df$month <- format(df$date,"%m")
df$day <- format(df$date,"%d")
df <- df %>%
  mutate(day_of_week <- weekdays(df$date))

df10 <- df

# checking if we have the required column inclusions
head(df)

# cleaning column names and removing duplicates
df <- df %>%
  clean_names() %>%
  unique()

# change the column name of day_of_week_weekdays_df_date to day_of_week
colnames(df)[23] <- "day_of_week"

# exporting cleaned df to new csv
write_csv(df,'divvy-tripdata_cleaned.csv')

# loading the cleaned dataset into df
df <- read_csv('divvy-tripdata_cleaned.csv')

# viewing the cleaned dataset
View(df)

# descriptive data analysis

# descriptive analysis on trip_duration
summary(df$trip_duration)
# comparing subscribers and customers
aggregate(df$trip_duration ~ df$user_type, FUN=mean)
aggregate(df$trip_duration ~ df$user_type, FUN=median)
aggregate(df$trip_duration ~ df$user_type, FUN=max)
aggregate(df$trip_duration ~ df$user_type, FUN=min)

# see the average trip duration by each day for customers and subscribers
aggregate(df$trip_duration ~ df$user_type + df$day_of_week, FUN=mean)

# sorting the days of the week
df$day_of_week <- ordered(df$day_of_week, levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))

# error starts

# analyzing ridership data by user type and day of the week
df %>%
  mutate(weekday=wday(strptime(start_time,"%m/%d/%Y %H:%M:%S %p"), label=TRUE)) %>%
  group_by(user_type, weekday) %>%
  summarize(number_of_rides=n(), average_duration=mean(trip_duration)) %>%
arrange(user_type, weekday)

# visualizing the number of rides by user type
df %>% 
  mutate(weekday = wday(strptime(start_time,"%m/%d/%Y %H:%M:%S %p"), label = TRUE)) %>% 
  group_by(user_type, weekday) %>% 
  summarise(number_of_rides = n(), average_duration = mean(trip_duration)) %>% 
  arrange(user_type, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = user_type)) +
  geom_col(position = "dodge")

# visualizing average duration of trip by user type
df %>% 
  mutate(weekday = wday(strptime(start_time,"%m/%d/%Y %H:%M:%S %p"), label = TRUE)) %>% 
  group_by(user_type, weekday) %>% 
  summarise(number_of_rides = n(), average_duration = mean(trip_duration)) %>% 
  arrange(user_type, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = user_type)) +
  geom_col(position = "dodge")

# exporting summary file for further analysis

# total and average number of weekly rides by user type
summary_wd <- df %>% 
  mutate(weekday = wday(strptime(start_time,"%m/%d/%Y %H:%M:%S %p"), label = TRUE)) %>%  
  group_by(user_type, weekday) %>%  
  summarise(number_of_rides = n(), average_duration = mean(trip_duration)) %>%    
  arrange(user_type, weekday)
write_csv(summary_wd, "summary_ride_length_weekday.csv")

# total and average number of monthly rides by user type
summary_month <- df %>% 
  mutate(month = month(strptime(start_time,"%m/%d/%Y %H:%M:%S %p"), label = TRUE)) %>%  
  group_by(month,user_type) %>%  
  summarise(number_of_rides = n(), average_duration = mean(trip_duration)) %>%    
  arrange(month, user_type)
write_csv(summary_month, "summary_ride_length_month.csv")

# stations most used by each user group
summary_station <- df %>% 
  mutate(station = from_station_name) %>%
  drop_na(from_station_name) %>% 
  group_by(from_station_name, user_type) %>%  
  summarise(number_of_rides = n()) %>%    
  arrange(number_of_rides)
write_csv(summary_station, "summary_stations.csv")