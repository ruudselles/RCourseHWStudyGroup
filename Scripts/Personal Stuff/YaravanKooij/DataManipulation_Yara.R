#empty global environment
rm(list = ls())

# Calculate the number of days between---------

as.Date("2020-12-28") - as.Date("2020-06-21")

# load dataset
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

# !! In de antwoorden wordt verwezen naar data_long, maar ik heb tot nu toe steeds Example_LongFormat 
# gebruikt als dataframe. Ik zie in beide datasets overigens geen behandelingDatum als variabele staan (krijg als antwoord ook NULL).
names(Example_LongFormat)

view(data_long)

data_long$behandelingDatum %>% str()

Example_LongFormat$behandelingDatum %>% str()
