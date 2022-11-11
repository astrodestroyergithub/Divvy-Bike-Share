# update Working directory to this script path
library(rstudioapi)
script_dir = rstudioapi::getActiveDocumentContext()$path
setwd('F:/Programming/OneDrive/Documents/')

# load Packages
library(readr)
library(tidyverse)
library(dplyr)
library(lubridate)
library(skimr)
library(janitor)