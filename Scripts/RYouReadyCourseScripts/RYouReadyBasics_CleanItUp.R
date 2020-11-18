# Load packages ------------------------
library(tidyverse)
library(here)
library(janitor)

#Clear the workspace ---------------
rm(list = ls())

# Load data --------
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

# Run function clean names ----------------
cleannames_data_long <- clean_names(Example_LongFormat)

# View dataframe--------------
view(cleannames_data_long)

# Create new dataframe ----------------

select_data_long <-select(Example_LongFormat, behandeling, rounddescription, everything())
                     
# Delete variables with -
select_data_long <- select(select_data_long, -Patient.traject.ID)

# Pipe function -------------
data_long_clean <-Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

# Summarize
summary(Example_LongFormat)

# Select variables
data_desc <- Example_LongFormat%>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)
  
# Summarize
summary(data_desc)
  
# Data filter  -------------
# Vrouw
data_desc_female <- Example_LongFormat%>%
  filter(Geslacht == "Vrouw") %>%
arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)

#Man
data_desc_male <- Example_LongFormat%>%
  filter(Geslacht == "Man") %>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)         

#It is important to realize the difference in are when you are considering these three almost similar sets of 2 lines of code in R:

# 1) 
Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

#These two lines just print the result in the console but does not store the data.

#2) 
Example_LongFormat <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

# These lines add a variable to the data frame Example_LongFormat. 

view(Example_LongFormat)
#You can check this with the comment view (Example_LongFormat),the last variable should now by the variable vasPijnGemiddeld_50. 

#Or you can use names(Example_LongFormat) to just check all variables in the data frame.
names(Example_LongFormat)  

#3)
new_vasgemiddeld50 <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

#These lines of code leave the data frame vasPijnGemiddeld_50 unchanged, but creates a new data frame called new_vasgemiddeld that has all variables from Example_LongFormat and with the 
#variable vasPijnGemiddeld_50 added. Again, you can view(new_frame) or use names(new_frame)

# Group by functie ----------- 
data_summarize<-Example_LongFormat%>%
  group_by(Geslacht)%>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE))

# Group by
data_summarize<-Example_LongFormat%>%
  group_by(Geslacht) %>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm =TRUE),
  min_VASpain = min(vasPijnGemiddeld_1,na.rm = TRUE),
  mean_VASpain= mean(vasPijnGemiddeld_1,na.rm = TRUE),
  median_VASpain= median(vasPijnGemiddeld_1, na.rm =TRUE),
  sd_VASpain=sd(vasPijnGemiddeld_1, na.rm = TRUE))

#view 
view(data_summarize)

#view summarize
data_summarize<-Example_LongFormat%>%
  group_by(Geslacht, zijde) %>%
  summarise(max_VASpain = max(vasPijnGemiddeld_1, na.rm =TRUE))
  
# Save in a new dataframe
PainMalesFemalesLeftRight <- Example_LongFormat%>%
  group_by(Geslacht, zijde) %>%
  summarise(max_VASpain = max(vasPijnGemiddeld_1, na.rm =TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm = TRUE),
            mean_VASpain= mean(vasPijnGemiddeld_1,na.rm = TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE),
            median_VASpain= median(vasPijnGemiddeld_1, na.rm =TRUE))

# Mutate-------------

data_long <-Example_LongFormat%>%
  mutate(pain_avarage = mean((vasPijnGemiddeld_1+vasPijnRust_1+vasPijnBelasten_1)/3), na.rm = TRUE)

data_long <- Example_LongFormat%>%
  mutate(pain_avarage = mean((vasPijnGemiddeld_1+vasPijnRust_1+vasPijnBelasten_1)/3), na.rm = TRUE) %>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)




