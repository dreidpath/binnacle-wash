########################################################################
## The purpose of this file is as a scratch-pad to play with the data.##
########################################################################

# Load libraries
library(patchwork)  # A library for stitching plots together 

## Plot the mortality by ethnicity
l_wdrrDF %>% 
  filter(ethnic != "all_race_ethnicity") %>%
  ggplot(aes(x = week_ending, y = mr, color = ethnic)) +
  geom_line()

## It seems that Hispanic-MR and Black-MR is always greater than the White-MR
## so I want to plot the ratios. I will use "%>% to bundle all the steps from
## data manipulation and selection through to plotting

wdrrDF %>%
  # Create the rate ratio data using the mutate() command
  mutate(hlw_ratio = Hispanic_Latino/White, 
         bw_ratio = Black_African_American/White, 
         apiw_ratio = Asian_Pacific_Islander/White) %>%
  # Select only the variables of interest for plotting (black and hispanic ratios)
  select(week_ending, hlw_ratio, bw_ratio) %>%
  # Turn the dataframe from wide to long for plotting
  pivot_longer(!week_ending, # exclude "weekending from the pivot
               names_to = "ratios", # New var (mortality rate ratio)
               values_to = "rate_ratio") %>% # New var (mr) to hold the mortality rate) 
  # Plot the data
  ggplot(aes(x = week_ending, y = rate_ratio, color = ratios)) +
    geom_smooth(se=F) + # Smooth the weekly ratios using loess use geom_line() if you don't want it smoothed
    xlab("Date") + # X-axis label
    ylab("Mortality Rate Ratio") # Y-axis label
    

