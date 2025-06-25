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

#make a pipe
data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

#sorting variables
summary(Example_LongFormat)
Example_LongFormat %>% arrange(-vasPijnGemiddeld_1)
Males_pain <- Example_LongFormat %>% filter(Geslacht == "M") %>%
  select(Geslacht, vasPijnGemiddeld_1) %>%
  arrange(-vasPijnGemiddeld_1)
Females_pain <- Example_LongFormat %>% filter(Geslacht == "F") %>%
  select(Geslacht, vasPijnGemiddeld_1) %>%
  arrange(-vasPijnGemiddeld_1)

#group by
PainMalesFemalesLeftRight <- Example_LongFormat %>% group_by(Geslacht, zijde) %>%
  summarise(max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE),
            min_VASpain = min(vasPijnGemiddeld_1, na.rm = TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1, na.rm = TRUE),
            median_VASpain = median(vasPijnGemiddeld_1, na.rm = TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE))

#MUTATE
Example_LongFormat <- Example_LongFormat %>%
  mutate(pain_average = ((vasPijnGemiddeld_1 + vasPijnRust_1 + vasPijnBelasten_1)/3), na.rm = TRUE) %>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1 > 50)
