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
