#clear the workspace
rm(list = ls())

#load packages
library(tidyverse)
library(here)
library(janitor)
library(ggbeeswarm)

#get data
load("~/Erasmus/Github data dingen_Timformatie/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/Erasmus/Github data dingen_Timformatie/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

#plotting raw data ----
Example_LongFormat %>%
  ggplot(aes(x = Geslacht, y = vasPijnGemiddeld_1)) +
  geom_point()

Example_LongFormat %>%
  ggplot(aes(x = Geslacht, y = vasPijnGemiddeld_1)) +
  geom_jitter()

Example_LongFormat %>%
  ggplot(aes(x = Geslacht, y = vasPijnGemiddeld_1)) +
  geom_quasirandom()

#use of colors and more ----
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = rounddescription, y = vasPijnGemiddeld_1, color = Geslacht)) +
  geom_point() + 
  coord_flip()

#facet wraps ----
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = Geslacht, y = vasPijnGemiddeld_1, color = Geslacht)) +
  geom_point() + 
  facet_wrap(~ rounddescription)

#clean the plot
Example_LongFormat %>%
  na.omit() %>%
  filter(vasPijnGemiddeld_1 < 100) %>%
  filter(vasPijnGemiddeld_1 > 0) %>%
  ggplot(aes(x = Geslacht, y = vasPijnGemiddeld_1, color = Geslacht)) +
  geom_jitter() + 
  facet_wrap(~ rounddescription)
