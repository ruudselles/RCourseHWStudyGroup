#Clear the workspace----
rm(list = ls())

#Load packagess-----
library(tidyverse)
library(here)
library(janitor)

#Load data ------
load("~/GitHub/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")
load("~/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

#Cleaning up -----
cleannames_data_long <- clean_names(Example_LongFormat)
select_data_long <- select(Example_LongFormat, behandeling, rounddescription, everything())
select_data_long <- select(select_data_long, -Patient.traject.ID)

# Pipe %>%
data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

# Sorting variables ------
summary(Example_LongFormat)
Data_desc <- Example_LongFormat %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

Data_desc_male <- Example_LongFormat %>%
  filter(Geslacht == "M") %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

 Data_desc_female <- Example_LongFormat %>%
   filter(Geslacht == "F") %>%
   arrange(desc(vasPijnGemiddeld_1)) %>%
   select(vasPijnGemiddeld_1)
 
 # Summarize ------
 Example_LongFormat %>%
   group_by(Geslacht) %>%
   summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE))

 data_summarize <- Example_LongFormat %>%
   group_by(Geslacht) %>%
   summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE),
             min_VASpain = min(vasPijnGemiddeld_1, na.rm = TRUE),
             median_VASpain = median(vasPijnGemiddeld_1, na.rm = TRUE),
             mean_VASpain = mean(vasPijnGemiddeld_1, na.rm = TRUE),
             sd_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE))
 
# Summarize pain seperately for females and males and also for left and right hand------
 PainMalesFemalesLeftRight <- Example_LongFormat %>%
   group_by(Geslacht, zijde) %>%
   summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm = TRUE),
             min_VASpain = min(vasPijnGemiddeld_1, na.rm = TRUE),
             mean_VASpain = mean(vasPijnGemiddeld_1, na.rm = TRUE),
             median_VASpain = median(vasPijnGemiddeld_1, na.rm = TRUE),
             sd_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE))

# Mutate --------
 data_long <- Example_LongFormat %>%
   mutate(pain_avarage = ((vasPijnGemiddeld_1+vasPijnRust_1+vasPijnBelasten_1)/3), na.rm = TRUE) %>%
   mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)
             