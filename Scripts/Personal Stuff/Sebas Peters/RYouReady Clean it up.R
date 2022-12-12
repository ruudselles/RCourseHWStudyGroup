#clear the workspace ------
rm(list = ls())

#Load data -----------
load("~/Library/Mobile Documents/com~apple~CloudDocs/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/Library/Mobile Documents/com~apple~CloudDocs/GitHub/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

#Load packages ----------
library(tidyverse)
library(here)
library(janitor)

#Run function clean_names-----
cleannames_data_long <- clean_names(Example_LongFormat)

#inspect result
view(cleannames_data_long)

#Create dataset with the name select_data_long
select_data_long <- select(Example_LongFormat, behandeling, rounddescription, everything())

#Remove variable Patient.traject.ID from dataset
select_data_long <- select(select_data_long, -Patient.traject.ID)

#Inspect result
view(select_data_long)

#make a Pipe %>%
data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

#Inspect variables
summary(Example_LongFormat)

#select data based on average pain
data_desc <- Example_LongFormat %>%
  arrange(-vasPijnGemiddeld_1) %>%
  select(vasPijnGemiddeld_1)

#Filter for males and females
data_desc_female <- Example_LongFormat %>%
  filter(Geslacht == "F") %>%
  arrange(-vasPijnGemiddeld_1) %>%
  select(vasPijnGemiddeld_1)

data_desc_male <- Example_LongFormat %>%
  filter(Geslacht == "M") %>%
  arrange(-vasPijnGemiddeld_1) %>%
  select(vasPijnGemiddeld_1)

#mutate
Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

Example_LongFormat <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

new_frame <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

#Assignment Group_By, summarize male/female on max, min, mean, med, and SD
data_summarize <- Example_LongFormat %>%
  group_by(Geslacht) %>%
  summarize(Max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE),
            Min_VASpain = min(vasPijnGemiddeld_1, na.rm = TRUE),
            Mean_VASpain = mean(vasPijnGemiddeld_1, na.rm = TRUE),
            Med_VASpain = median(vasPijnGemiddeld_1, na.rm = TRUE),
            SD_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE))
View(data_summarize)

data_summarize <- Example_LongFormat %>%
  group_by(Geslacht, zijde) %>%
  summarize(Max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE))

# PainMalesFemalesLeftRigth
PainMalesFemalesLeftRigth <- Example_LongFormat %>%
  group_by(Geslacht, zijde) %>%
  summarize(Max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE),
            Min_VASpain = min(vasPijnGemiddeld_1, na.rm = TRUE),
            Mean_VASpain = mean(vasPijnGemiddeld_1, na.rm = TRUE),
            Med_VASpain = median(vasPijnGemiddeld_1, na.rm = TRUE),
            SD_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE))
view(PainMalesFemalesLeftRigth)
  
#Ik ben nu bij How to mutate


            