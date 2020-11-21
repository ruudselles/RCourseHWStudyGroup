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

#reorganizing name tables from long format-------
cleannames_data_long <- clean_names(Example_LongFormat)

#inspect the results-------
view (cleannames_data_long)

#create new data with re-organise collums-----
select_data_long <- select(Example_LongFormat, behandeling, rounddescription, everything())

#create new data with deleting a collum-----
select_data_long <- select(select_data_long, -Patient.traject.ID)

#create new data with pipe function %>%------
data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything ()) %>%
  select(-patient_traject_id)