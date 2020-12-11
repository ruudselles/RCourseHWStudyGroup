#Clearing enviroment ------------
rm(list = ls())

#Load packages and datasets -----------
library(tidyverse)
library(here)
library(janitor)
library(ggbeeswarm)

load("~/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

#Scatter plot VAS for male and female
Example_LongFormat %>%
  na.omit() %>%
  filter(vasPijnGemiddeld_1 < 100) %>%
  filter(vasPijnGemiddeld_1 > 0) %>%
  ggplot(aes(x = Geslacht, y = vasPijnGemiddeld_1, color = Geslacht)) +
  geom_jitter() +
  facet_wrap(~rounddescription)

#VAS per measuring point
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = rounddescription, y = vasPijnGemiddeld_1, color = Geslacht)) +
  geom_jitter() +
  coord_flip()

#Add error bars

Example_LongFormat %>%
  na.omit() %>%
  group_by(Geslacht) %>%
  summarise(mean = mean(vasPijnGemiddeld_1),
            sd = sd(vasPijnGemiddeld_1),
            n = n(),
            stderr = sd/sqrt(n)) %>%
  ggplot(aes(x = Geslacht, y = mean)) + 
  geom_col() +
  geom_errorbar(aes(x= Geslacht, ymin = mean - stderr, ymax = mean + stderr))

#Scatter plot VASpain and VASfunction
Example_LongFormat %>%
  na.omit() %>%
  filter(vasFunctie_1 < 100) %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "relationship between pain and hand function", 
       x = "VAS pain (0-100)",
       y = "VAS function (0-100)")
