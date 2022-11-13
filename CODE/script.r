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
df$date <- as.Date(df$`START TIME`)
df$year <- format(as.Date(df$`START TIME`),"%Y")
df$month <- format(as.Date(df$`START TIME`),"%m")
df$day <- format(as.Date(df$`START TIME`),"%d")
df <- df %>%
  mutate(day_of_week <- weekdays(as.Date(df$`START TIME`)))

# checking if we have the required column inclusions
head(df)

