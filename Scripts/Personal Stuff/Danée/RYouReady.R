#clear the workspace
rm(list = ls())

#load packages
library(tidyverse)
library(here)
library(janitor)

#get data
load("~/Erasmus/Github data dingen_Timformatie/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/Erasmus/Github data dingen_Timformatie/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

#clean up the data
cleannames_data_long <- clean_names(Example_LongFormat)
view(cleannames_data_long)
select_data_long <- select(cleannames_data_long, behandeling, rounddescription, everything())
select_data_long <- select(cleannames_data_long, -patient_traject_id)
