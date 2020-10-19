#load packages --------------------
library(tidyverse)
library(ggplot2)


#manually load the following data file: ------------------
load("E:/HWStudyGroup/Post Selection/data_analysis COVID study EQ5D.RData")

#select only the two variables that we need for this analysis
data_analyses <- data_analyses %>% 
  select(Invuldatum_EQ5D, EQ5D_index)

#dataset for lockdown in 2020
data_analyses_2020 <- data_analyses %>%
  filter(Invuldatum_EQ5D >= "2020-03-23"& Invuldatum_EQ5D <= "2020-05-04")  %>%
  mutate(MeasurementYear = as.factor(2020)) %>% 
  mutate(DaysFromLockdown = Invuldatum_EQ5D-as.Date(c("2020-03-23")))

#dataset for lockdown in 2018
data_analyses_2018 <- data_analyses %>%
  filter(Invuldatum_EQ5D >= "2018-03-23" & Invuldatum_EQ5D <= "2018-05-04") %>% 
  mutate(MeasurementYear = as.factor(2018)) %>% 
  mutate(DaysFromLockdown = Invuldatum_EQ5D-as.Date(c("2018-03-23"))) 

#dataset for lockdown in 2019
data_analyses_2019 <- data_analyses %>%
  filter(data_analyses$Invuldatum_EQ5D >= "2019-03-23" & data_analyses$Invuldatum_EQ5D <= "2019-05-04") %>% 
  mutate(MeasurementYear = as.factor(2019)) %>% 
  mutate(DaysFromLockdown = Invuldatum_EQ5D-as.Date(c("2019-03-23"))) 

#combine the three datasets that we just created
data_analyses_all <- rbind(data_analyses_2020, data_analyses_2018,data_analyses_2019)

#plot Q5D with facets ---------
EQ5D_facets <- ggplot(data_analyses_all, aes(x = DaysFromLockdown, y= EQ5D_index)) +
  facet_wrap(data_analyses_all$MeasurementYear) + 
  labs(x="Days since March 23", y="EQ5D index score") +
  geom_point(color = "black") +
  geom_smooth(degree = 2, se= TRUE) +
  #geom_smooth(method = lm) +
  scale_y_continuous(limits = c(-0.05,1.05), breaks = seq(0,1.0,0.1)) +
  scale_x_continuous(limits = c(-0.5,60), breaks = seq(0,10,60)) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 9), axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 12, face = "bold"), axis.title.y = element_text(size = 12, face = "bold"), legend.title = element_text(size = 12, face = "bold"), legend.text =element_text(size= 10)) 
EQ5D_facets
ggsave("EQ5DTimefacets.png")
