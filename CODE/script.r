# update Working directory to this script path
library(rstudioapi)
script_dir = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(script_dir))
getwd()

# load Packages
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
