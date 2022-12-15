#clear the workspace ------
rm(list = ls())

#Load packages ----------
library(tidyverse)
library(here)
library(janitor)
library(ggbeeswarm)
library(readr)

#Set theme--------
theme_set(theme_classic())

#Load data -----------
load("~/Library/Mobile Documents/com~apple~CloudDocs/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

#create scatterplot VAS pain average man/female-----
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


#Assignment: %>% the plot --> fout in code op Rcourse------
Example_LongFormat %>%
  filter(vasPijnGemiddeld_1 < 100) %>%
  filter(vasPijnGemiddeld_1 > 0) %>%
  ggplot(aes(y = vasPijnGemiddeld_1, x = Geslacht, color = Geslacht)) +
  geom_jitter() + facet_wrap(~ rounddescription)

#save plot------
ggsave("VASpain_ggsave.png")

#Histogram --> VizWhiz lesson 2 buiten Rcourse nog wel een keer doen-----

##Make a plot, analogous to  the video, with the average VAS pain for men 
#and women, and with error bars for the standard error.
Example_LongFormat %>%
  na.omit() %>%
  group_by(Geslacht) %>%
  summarise(mean = mean(vasPijnGemiddeld_1),
                        sd = sd(vasPijnGemiddeld_1),
                        n = n(),
                        stderr = sd/sqrt(n)) %>%
  ggplot(aes(x = mean, y = Geslacht)) +
  geom_col() +
  geom_errorbar(aes(y = Geslacht, xmin = mean-stderr, xmax = mean+stderr))

#Make a scatter plot in which you can show to what extent VAS pain correlates with VAS function.----
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1)) +
  geom_point() +
  geom_smooth()

#Add color
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth()

#Graph layout----
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth() +
  theme_classic()

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth() +
  theme_minimal()

#add titles and change axis tabels ----
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x = vasPijnGemiddeld_1, y = vasFunctie_1, color = Geslacht)) +
  geom_point() +
  geom_smooth() +
  theme_classic() +
  labs(title = "relationship between pain and hand functon",
       x = "VAS pain (0-10)", 
       y = "VAS function (0-10)")
