# VizWhiz

rm(list = ls())

# Load packages ----

library(tidyverse)
library(here)
library(janitor)
library(readr)
library(ggbeeswarm)

# Importing data --> Vanuit files rechtsonder geupload

data_combined <- Example_LongFormat

# Create scatterplot ----

data_combined %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_point()

# Create geom_jitter

data_combined %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_jitter()

# Create geom_quasirandom

data_combined %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_quasirandom()

# Use of colors and more -----

data_combined %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1)) +
  geom_jitter()

data_combined %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1)) +
  geom_jitter() +
  coord_flip()

data_combined %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1, color = Geslacht)) +
  geom_jitter() +
  coord_flip()

# Facet Wraps (meerdere plots in 1) ----

data_combined %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, color = rounddescription)) +
  geom_jitter() +
  facet_wrap(~ rounddescription)

# %>% the plot

data_combined %>%
  na.omit() %>%
  filter(vasPijnGemiddeld_1 >0) %>%
  filter(vasPijnGemiddeld_1 <100) %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, color = rounddescription)) +
  geom_jitter() +
  facet_wrap(~ rounddescription)

# Save your plot - Last plot

# VizWhiz module 2 filmpjes voor histograms

# Error bars ----

data_combined %>%
  na.omit() %>%
  group_by(Geslacht) %>%
  summarise(mean = mean(vasPijnGemiddeld_1),
            sd = sd(vasPijnGemiddeld_1),
            n = n(),
            stderr = sd/sqrt(n)) %>%
  ggplot(aes(x=Geslacht, y= mean))+
  geom_col()+
  geom_errorbar(aes(x= Geslacht, ymin = mean-stderr, ymax = mean+stderr))

# Correlations/scatter plots----

data_combined %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y= vasFunctie_1))+
  geom_point()+
  geom_smooth()

data_combined %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y= vasFunctie_1, color = Geslacht))+
  geom_point()+
  geom_smooth()

# Graph Lay-out ----

data_combined %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y= vasFunctie_1, color = Geslacht))+
  geom_point()+
  geom_smooth()+
  theme_classic()

data_combined %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y= vasFunctie_1, color = Geslacht))+
  geom_point()+
  geom_smooth()+
  theme_minimal()

# Add titles en modify names

data_combined %>%
  na.omit()%>%
  ggplot(aes(x = vasPijnGemiddeld_1, y= vasFunctie_1, color = Geslacht))+
  geom_point()+
  geom_smooth()+
  theme_classic()+
  labs(title= "Relationship between pain and hand function", 
       x= "VAS pain 0-100",
       y= "VAS function 0-100")
