#clear workspace
rm(list = ls())

#load packages -------------
library(tidyverse)
library(here)
library(janitor)

#load data -----------
load("~/R/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/R/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

#Run function clean_names---
cleannames_data_long <- clean_names(Example_LongFormat)

#Inspect the result
view(cleannames_data_long)

#Create a data frame with the name select_data_long
select_data_long<- select(Example_LongFormat, behandeling, rounddescription, everything())

#Remove from the data the variables Patient.traject.ID)
select_data_long<- select(select_data_long, -Patient.traject.ID)

#inspect the result
view(select_data_long)

#Make a pipe in which you take data_long and create a new data frame with the name data_long_clean----
data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)


#Remember that because of applying clean_names(),Patient.traject.ID is now named patient_traject_id


#RYOUREADYCLEANING2 ------------

#Inspect variables
summary(Example_LongFormat)

#Sort data based on average pain
data_desc <- Example_LongFormat  %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

#Filter for females and males
data_desc_female <- Example_LongFormat%>%
  filter(Geslacht == "Vrouw") %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

data_desc_male<- Example_LongFormat %>%
  filter(Geslacht == 'Man') %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)


#Calculate maximum pain reported by males and females using group_by function
data_summarize <- Example_LongFormat %>%
  group_by(Geslacht) %>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE))

view(data_summarize)

#Use the summarize construct to calculate maximum, minimum, average and median average pain for both males and females.

data_summarize <- Example_LongFormat %>%
  group_by(Geslacht) %>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm=TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1,na.rm=TRUE),
            median_VASpain = median(vasPijnGemiddeld_1,na.rm=TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1,na.rm=TRUE))

view(data_summarize)


#comparing three ways of dealing with a new variable:
Example_LongFormat%>% 
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

Example_LongFormat <- Example_LongFormat%>% 
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

new_frame <- Example_LongFormat%>% 
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)



#Analyse maximum reported pain seperately for males and females, and patients operated on ther left and on their right side
data_summarize <- Example_LongFormat %>%
  group_by(Geslacht, zijde) %>%
    summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE))



#use the summarize construct shown in the video to calculate maximum, minimum, average and median average pain for both males and females operated on either left or right hand. Save the results in a new data frame called PainMalesFemalesLeftRigth.
PainMalesFemalesLeftRight <- Example_LongFormat %>%
  group_by(Geslacht, zijde) %>% 
    summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm=TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1,na.rm=TRUE),
            median_VASpain = median(vasPijnGemiddeld_1,na.rm=TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1,na.rm=TRUE))


#Create variable pain_average, by averaging the three separate items scored by the patients ("vasPijnGemiddeld_1","vasPijnRust_1", "vasPijnBelasten_1")
data_long <- Example_LongFormat %>%
  mutate(pain_average = ((vasPijnGemiddeld_1 + vasPijnRust_1 + vasPijnBelasten_1)/3),na.rm = TRUE)

#Add to the same pipe a variables that defines if the vasPijnGemiddeld_1 is higher than 50
data_long <- Example_LongFormat %>%
  mutate(pain_average = ((vasPijnGemiddeld_1 + vasPijnRust_1 + vasPijnBelasten_1)/3),na.rm = TRUE) %>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1 > 50)

