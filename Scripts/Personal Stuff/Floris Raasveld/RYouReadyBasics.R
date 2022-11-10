## clear workspace----
rm(list=ls())

## set work directory to load and save files in
setwd("C:/Users/flori/Dropbox (Personal)/PhD/GitHub/RCourseHWStudyGroup/RCourseHWStudyGroup/Scripts/Personal Stuff/Floris Raasveld")

## install packages----
install.packages(janitor)


## load in packages ----
## library

library(tidyverse) ## data rendring package in user friendly way
library(here)
library(skimr)
library(janitor) ## cleaning packages

## read in data in excel file ----

## testfile <- read_csv(here("Scripts/Personal Stuff/Floris Raasveld", "testdata.csv"))
                 View(testfile) ## way to load in by code, speccy folders from "master folder"
 load("C:/Users/flori/Dropbox (Personal)/PhD/GitHub/RCourseHWStudyGroup/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")


## exploring the data ----
View(Example_LongFormat)
View(Example_WideFormat)

dim(Example_WideFormat)
str(Example_WideFormat)
glimpse()
head()
tail()

## summary(dataset$var1) ## basic descriptive statistics
summary(Example_WideFormat$Leeftijd)
mean(Example_WideFormat$Leeftijd)
skim(Example_WideFormat)

t.test(Example_WideFormat$Leeftijd, conf.level=0.05, alternative="two.sided")

## clean up variable names (columns) ----


select_all(Example_WideFormat, toupper)
select_all(Example_WideFormat, tolower)
clean_names(Example_LongFormat)

names(Example_LongFormat)
names(Example_WideFormat)

## codes do execute, but I don see it??
## need to make a new dataset and assign the command to it, then view

new_longformat <- clean_names(Example_LongFormat)
View(new_longformat)

names(new_longformat)

rename(new_longformat, dominant = DOMINANT)

new_longformatCAPS <- rename(new_longformat, DOMINANT= dominant) ## new name first!)

View(new_longformatCAPS)
names(new_longformatCAPS) ## you can see dominant is changed to DOMINANT

cleannames_data_long <- clean_names(Example_LongFormat)
View(cleannames_data_long)
## overwrite the datasets by using the same name to which it is assigned

##clean_names(dat, case) ----
# S3 method for default
# clean_names(dat, case = c("snake", "lower_camel","upper_camel", "screaming_snake", "lower_upper", "upper_lower",
   ##                       "all_caps", "small_camel", "big_camel", "old_janitor", "parsed", "mixed",
    ##                      "none"))

Example_LongFormat %>% clean_names(., "all_caps")

## re-order variables ----
select(cleannames_data_long, dominant, zijde)

## first your selected variables, then the rest
select(cleannames_data_long, dominant, zijde, everything()) 

select_data_long <- select(cleannames_data_long, behandeling, rounddescription,
                           everything())
View(select_data_long)
select_data_long <- select(select_data_long, -patient_traject_id )

summary(select_data_long$patient_traject_id) ## output indicats var does not excist

## make a pipe ----

data_long_clean <- Example_LongFormat %>% 
  clean_names(., "snake") %>%
   select(behandeling, rounddescription, everything())%>%
  select(-patient_traject_id)

setwd("C:/Users/flori/Dropbox (Personal)/PhD/GitHub/RCourseHWStudyGroup/RCourseHWStudyGroup/Scripts/Personal Stuff/Floris Raasveld")
write_csv(data_long_clean, "testdata.csv")

## arrange, filter, select ----

summary(Example_LongFormat )

newframe_female <- Example_LongFormat %>%
  filter(Geslacht=="F") %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

newframe_male <- Example_LongFormat %>%
  filter(Geslacht=="M") %>%
  arrange(desc(vasPijnGemiddeld_1)) %>%
  select(vasPijnGemiddeld_1)

Example_LongFormat%>%
    mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

Example_LongFormat <- Example_LongFormat%>%
    mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

new_frame <- Example_LongFormat%>%
    mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)


## does not work somehow
##new_frame %>%
##  summary(hoeLangKlacht)
summary(new_frame$hoeLangKlacht)

## group_by, descriptives by group ----

data_summarise <- Example_LongFormat %>%
  group_by(Geslacht) %>% 
  summarize(max_VASpain=max(vasPijnGemiddeld_1, na.rm = TRUE),
            min_VASpain=min(vasPijnGemiddeld_1, na.rm = TRUE),
            mean_VASpain=mean(vasPijnGemiddeld_1, na.rm = TRUE),
            median_VASpain=median(vasPijnGemiddeld_1, na.rm = TRUE),
            sd_VASpain=sd(vasPijnGemiddeld_1, na.rm = TRUE))
            
view(data_summarise)
Example_LongFormat %>% distinct(Geslacht)

PainMalesFemalesLeftRigth <- Example_LongFormat %>%
  group_by(Geslacht, zijde) %>% 
  summarize(max_VASpain=max(vasPijnGemiddeld_1, na.rm = TRUE),
            min_VASpain=min(vasPijnGemiddeld_1, na.rm = TRUE),
            mean_VASpain=mean(vasPijnGemiddeld_1, na.rm = TRUE),
            median_VASpain=median(vasPijnGemiddeld_1, na.rm = TRUE),
            sd_VASpain=sd(vasPijnGemiddeld_1, na.rm = TRUE)) 

## create new variables using mutate ----

Example_LongFormat %>% mutate(y=command(x))


data_long  <- Example_LongFormat %>%
  mutate(pain_average=((vasPijnGemiddeld_1+vasPijnRust_1+vasPijnBelasten_1)/3), na.rm=TRUE) %>%
  mutate(vasPijnGemiddeld_50=vasPijnGemiddeld_1>50)

         
         %>%
  mutate(pain_average_rust =mean(vasPijnRust_1)) %>%
  mutate(pain_average_belasten =mean(vasPijnBelasten_1) ) %>%
  mutate(pain_gemiddeld50 = vasPijnGemiddeld_1>50)

View(data_long)


