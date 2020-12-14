#load packages -----------

library(tidyverse);
library(here);
library(skimr);
library(janitor);

#read data --------------

rm(list=ls());

load("D:/HWSG/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("D:/HWSG/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

cleannames_data_long <- clean_names(Example_LongFormat)

select_data_long <- select(cleannames_data_long, behandeling, rounddescription, everything())
select_data_long <- select(select_data_long, -patient_traject_id)

data_long_clean <- Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

summary(Example_LongFormat)
data_desc <- Example_LongFormat %>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)

data_desc_female <- Example_LongFormat %>%
  filter(Geslacht == "F")%>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)

data_desc_male <- Example_LongFormat %>%
  filter(Geslacht == "M")%>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)



data_summarize <- Example_LongFormat%>%
  group_by(Geslacht) %>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE))

view(data_summarize)


data_summarize <- Example_LongFormat%>%
  group_by(Geslacht)%>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1,na.rm=TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm=TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1,na.rm=TRUE),
            median_VASpain = median(vasPijnGemiddeld_1,na.rm=TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1,na.rm=TRUE))

view(data_summarize)



data_summarize <- Example_LongFormat%>%
  group_by(Geslacht,zijde) %>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE))

PainMalesFemalesLeftRight <- Example_LongFormat%>%
  group_by(Geslacht, zijde)%>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1,na.rm=TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm=TRUE),
            mean_VASpain = mean(vasPijnGemiddeld_1,na.rm=TRUE),
            median_VASpain = median(vasPijnGemiddeld_1,na.rm=TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1,na.rm=TRUE))



data_long <- Example_LongFormat %>%
  mutate(pain_average = ((vasPijnGemiddeld_1 + vasPijnRust_1 + vasPijnBelasten_1)/3),na.rm = TRUE)

data_long <- Example_LongFormat %>%
  mutate(pain_average = ((vasPijnGemiddeld_1 + vasPijnRust_1 + vasPijnBelasten_1)/3),na.rm = TRUE)%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

# Write cleaned data to .csv ---------
write_csv()
