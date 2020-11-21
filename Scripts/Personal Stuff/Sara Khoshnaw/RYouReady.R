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

#reorganizing names from long format-------
cleannames_data_long <- clean_names(Example_LongFormat)

#inspect the results-------
view (cleannames_data_long)

#create new data with re-organise collums-----
select_data_long <- select(Example_LongFormat, behandeling, rounddescription, everything())

#create new data with deleting a collum-----
select_data_long <- select(select_data_long, -Patient.traject.ID)

#create new data with pipe function %>% (alles in1)------
data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything ()) %>%
  select(-patient_traject_id)

#inspect data (krijg je data te zien)-----
summary(Example_LongFormat)

#Data sorted based on average pain---
data_desc<- Example_LongFormat %>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)

#filter for female and males
Female<- Example_LongFormat %>%
  filter( Geslacht == 'F') %>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)

Male<- Example_LongFormat %>%
  filter( Geslacht == 'M') %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

Test<- Example_LongFormat %>%
  mutate(vanPijnGemiddeld_50=vasPijnGemiddeld_1>50)
    
