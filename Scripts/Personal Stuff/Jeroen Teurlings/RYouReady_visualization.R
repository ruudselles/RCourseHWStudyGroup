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


Example_LongFormat %>%
  na.omit()%>%
  group_by(Geslacht)%>%
  summarize(mean = mean(vasPijnGemiddeld_1),
            sd = sd(vasPijnGemiddeld_1),
            n = n(),
            stderr = sd/sqrt(n))%>%
  ggplot(aes(x=Geslacht, y = mean)) +
  geom_col()+
  geom_errorbar(aes(x=Geslacht, ymin = mean-stderr, ymax = mean+stderr))


Example_LongFormat %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1)) + 
  geom_point()+
  geom_smooth()


Example_LongFormat %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, colour = Geslacht)) +
  geom_point() +
  geom_smooth() +
  theme_minimal()

