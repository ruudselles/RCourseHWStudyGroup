#clear the workspace ------
rm(list = ls())

#Load packages ----------
library(tidyverse)
library(here)
library(janitor)
library(ggbeeswarm)
library(readr)

#Load data -----------
load("~/Library/Mobile Documents/com~apple~CloudDocs/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

#create scatterplot VAS pain average man/female
Example_LongFormat %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = Geslacht)) +
  geom_point()

#create jitterplot VAS pain average man/female
Example_LongFormat %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = Geslacht)) +
  geom_jitter()

#create quasirandom VAS pain average man/female
Example_LongFormat %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = Geslacht)) +
  geom_quasirandom()

#Scatterplot VAS pain average man/female without missing data
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = Geslacht)) +
  geom_jitter()

#Scatterplot VAS pain average measuring point and color bij gender
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = rounddescription, color = Geslacht)) +
  geom_jitter() +
  coord_flip()

#Scatterplot VAS pain average man/female facet_wraped for measuring point
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = Geslacht, color = Geslacht)) +
  geom_jitter() +
  facet_wrap(~ rounddescription)


#Assignment: %>% the plot
