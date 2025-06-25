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

#save the plot
ggsave(here("vaspijngem.png"))

#using bar and column graphs
Example_LongFormat %>%
  na.omit() %>%
  group_by(Geslacht) %>%
  summarise(sd = sd(vasPijnGemiddeld_1),
            n = n(),
            mean = mean(vasPijnGemiddeld_1),
            stderr = sd/sqrt(n)) %>%
  ggplot(aes(x = Geslacht, y = mean)) +
  geom_col() +
  geom_errorbar(aes(x = Geslacht, ymin = mean-stderr, ymax = mean+stderr))

#fit a line
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth()

#graph lay out
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "Relationship between pain and hand functon",
       x = "VAS pain (0-10)",
       y = "VAS function (0-10)")
