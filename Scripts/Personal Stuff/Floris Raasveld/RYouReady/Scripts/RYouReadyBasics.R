## clear workspace----
rm(list=ls())

## install packages----
## install.packages(c())

## load in packages
## library
install.packages("skimr")

library(tidyverse)
library(here)
library(skimr)

## read in data in excel file ----

name <- read_csv(here("data", "filename.csv"))

## exploring the data ----
View()

dim()
str()
glimpse()
head()
tail()

summary() ## basic descriptive statistics
skim()

