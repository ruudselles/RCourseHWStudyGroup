#install packages
install.packages('tidyverse')
install.packages('here')
install.packages('janitor')

#load packages ---------
library(tidyverse)
library(here)
library(janitor)

#clear the workspace ---------
'rm(list = ls())'

#load data
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

#reorganizing tables long format-------
cleannames_data_long <- clean_names(Example_LongFormat)

#inspect the results
view (cleannames_data_long)

