########################################################################
## The purpose of this file is to download and format mortality data  ##
## and vaccination data.                                              ##
########################################################################


# A line that is a comment and does not affect the R-script begins with a '#'

## Load the libraries
# R uses a series of "libraries", which are pre-written code to simplify work
library(readr)  # The readr library helps import data from CSV files
library(tidyverse)  # a series of libraries to simplify data manipulation

## Import the data
# First get some weekly death rate race data (wdrr) from the NYC github site.
wdrr_location <- "https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/weekly-death-rate-race.csv"
# Read the data into a dataframe. Make sure that "week_ending" is imported
# as a "date" variable not as a "character" variable
wdrrDF <- read_csv(wdrr_location, 
                            col_types = cols(week_ending = 
                                               col_date(format = "%m/%d/%Y")))

## Reformat the data
# The data are in "wide format" which means that each row represents one
# week and the columns are the race/ethnic group rates. For many graphs and 
# analyses (but not all), you really need the data in "long format" so that each
# row represents the rate for one race/ethnic group in a specific week.  The 
# next bit transforms the dataframe from wide- to long-format
l_wdrrDF <- pivot_longer(wdrrDF, # use the wdrrDF and save result as l_wdrrDF
                         !week_ending, # exclude "weekending from the pivot
                         names_to = "ethnic", # New var (ethnic) to hold categories
                         values_to = "mr") # New var (mr) to hold the mortality rate


## Plot the data
l_wdrrDF %>% 
  filter(ethnic != "all_race_ethnicity") %>%
  ggplot(aes(x = week_ending, y = mr, color = ethnic)) +
  geom_line()
