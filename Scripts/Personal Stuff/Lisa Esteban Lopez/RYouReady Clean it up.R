# RCOURSE OEFENSESSIE --------------
# Load packages -------

library(tidyverse)
library(here)

# Clear the workspace -------------

rm(list = ls())

# Load data --------

load("~/R-course/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")
load("~/R-course/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

# Instal Janitor package -------

install.packages("janitor")

# Load packages -------

library(janitor)

# Clean and rename the data -------

cleannames_data_long <- clean_names(Example_LongFormat)

#Inspect results -----

view(cleannames_data_long)

# New data frame with behandeling, rounddescription and everything else -------

select_data_long <- select(Example_LongFormat, behandeling, rounddescription, everything())

# Remove from new data frame variable patient.traject.id -----------

select_data_long <- select(select_data_long, -Patient.traject.id)

# View results -----------
view(select_data_long)

# Clean it up with Pipes -----

data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

  
  