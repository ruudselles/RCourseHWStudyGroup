rm(list=ls())
load("D:/HWSG/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

library(tidyverse)
library(here)
library(ggbeeswarm)
library(readr)

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_point()

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y = vasPijnGemiddeld_1)) +
  geom_jitter()

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_quasirandom()



Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x=Geslacht,y=vasPijnGemiddeld_1)) + 
  geom_jitter()

Example_LongFormat %>%
  na.omit()%>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1))+
  geom_jitter()

Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1)) +
  geom_point() +
  coord_flip()

Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  coord_flip()


Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_jitter() + 
  facet_wrap(~ rounddescription)

Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht)) +
  geom_jitter() +
  facet_wrap(~ rounddescription)

Example_LongFormat%>%
  na.omit()%>%
  filter(vasPijnGemiddeld_1<100)%>%
  filter(vasPijnGemiddeld_1>0)%>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht)) +
  geom_jitter() +
  facet_wrap(~ rounddescription)