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

# Inspect Example_LongFormat ---- 
summary(Example_LongFormat)

# SOrt average pain from high to low -----
Example_LongFormat %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)
  
#hoogste 104, laagste 86? ----- Klopt niet, daarom hierboven select toegevoegd

# Filter for females and males ---------
femalepain <- (Example_LongFormat) %>%
  filter(Geslacht == "F") %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

malepain <- (Example_LongFormat) %>%
  filter(Geslacht == "M") %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

# Verschil tussen codes -----
Example_LongFormat%>%
    mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

Example_LongFormat <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

new_frame <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

# Group by females and males + new dataframe-----

data_summarize <- Example_LongFormat%>%
  group_by(Geslacht)%>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1,na.rm=TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm= TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1,na.rm = TRUE),
            median_VASpain = median(vasPijnGemiddeld_1,na.rm = TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1,na.rm=TRUE))
view(data_summarize)

# Group by patients operated on left or right side

PainMalesFemalesLeftRight <- Example_LongFormat %>%
  group_by(Geslacht, zijde)%>%
  summarize(max_VASpijn = max(vasPijnGemiddeld_1, na.rm = TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm= TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1,na.rm = TRUE),
            median_VASpain = median(vasPijnGemiddeld_1,na.rm = TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1,na.rm=TRUE))

view(PainMalesFemalesLeftRight)

# Mutate , create variable average -----

data_long <- Example_LongFormat %>%
  mutate(pain_average = ((vasPijnGemiddeld_1 + vasPijnRust_1 + vasPijnBelasten_1)/3), na.rm=TRUE) %>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1 > 50)

# Vizualisation
