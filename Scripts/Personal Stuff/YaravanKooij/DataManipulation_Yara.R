#Empty global environment --------
rm(list = ls())

# Load library --------
library(tidyverse)
library(here)
library(readr)
library(ggbeeswarm)
library(ggplot2)
library(dplyr)

# Calculate the number of days between---------

as.Date("2020-12-28") - as.Date("2020-06-21")

# Load dataset
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")

## Een wide format dataset heeft van 1 patient alle metingen in een rij staan. Dus elk meetmoment is een kolom. DIt kan je gebruiken bij summary statistics (SD, means) en regressie analyse
## Een long format heeft voor elk tijdsmoment een rijd (dus meerdere rijen per pt). Dit kan je gebruiken om figuren over de tijd weer te geven en bijvoorbeeld voor een lineair mixed models.

# !! In de antwoorden wordt verwezen naar data_long, maar ik heb tot nu toe steeds Example_LongFormat gebruikt als dataframe.
Example_LongFormat$behandelingDatum %>%str()
Example_LongFormat$behandelingDatum %>%View()

# Installe Lubridate ---------------------

install.packages("lubridate")
library(lubridate)

# Change the date to format ymd -----------

Example_LongFormat$behandelingDatum%>%ymd()

# Plot number of treatments ---------

ggplot(Example_LongFormat, aes(x = behandelingDatum))+
  geom_histogram(color="blue", fill="grey")

# Select treatment between 01-01-2018 to 01-01-2019

ggplot(Example_LongFormat, aes(x = behandelingDatum))+
  geom_histogram(color="blue", fill="grey")+
  xlim(as.Date("2018-01-01"), as.Date("2019-01-01"))


# Select only the two variables that we need for this analysis: After watching the screencast and the code for this plot, try to apply this code to the example dataset:
# Ceate a similar plot to see if the pain scores during a summer differ from a winter
# Hier mis ik het antwoord, welk ik hard nodig had ;-) 

Painsummerwinter<-Example_LongFormat %>%
  select(vasPijnRust_1, behandelingDatum)

#dataset 2020
Painsummerwinter2020 <- Painsummerwinter %>%
  filter(behandelingDatum >= "2020-01-01" & behandelingDatum <= "2020-12-31") %>%
  mutate(MeasurementYear = as.factor(2020)) 

#dataset 2019
Painsummerwinter2019 <- Painsummerwinter %>%
  filter(behandelingDatum >= "2019-01-01" & behandelingDatum <= "2019-12-31") %>%
  mutate(MeasurementYear = as.factor(2020)) 

#dataset 2018
Painsummerwinter2018 <- Painsummerwinter %>%
  filter(behandelingDatum >= "2018-01-01" & behandelingDatum <= "2018-12-31") %>%
  mutate(MeasurementYear = as.factor(2020)) 

#dataset 2017
Painsummerwinter2017 <- Painsummerwinter %>%
  filter(behandelingDatum >= "2017-01-01" & behandelingDatum <= "2017-12-31") %>%
  mutate(MeasurementYear = as.factor(2020)) 

#combine the four datasets that we just created
summerwinter_all <- rbind(Painsummerwinter2017, Painsummerwinter2018, Painsummerwinter2019, Painsummerwinter2020)

# Hoe maak ik onderscheid in winter en zomer per jaar? 
# als voorbeeld dataset 2019
Painsummer2019 <- Painsummerwinter %>%
  filter(behandelingDatum >= "2019-06-21" & behandelingDatum <= "2019-09-21") %>%
  mutate(MeasurementYear = as.factor(2020)) 

Painwinter2019 <- Painsummerwinter %>%
  filter(behandelingDatum >= "2019-12-21" & behandelingDatum <= "2020-03-21") %>%
  mutate(MeasurementYear = as.factor(2020)) 

summerwinter_2019 <- rbind(Painsummer2019, Painwinter2019)

#plot VAS pain with facets ---------
VASpainsummerwinter2019 <- ggplot(summerwinter_2019, aes(x= behandelingDatum, y= vasPijnRust_1)) +
  facet_wrap(summerwinter_2019$MeasurementYear) +
  labs(x="Days during year", y="VASpainRust") +
  geom_jitter(color = "black") +
  geom_smooth(method = 'lm') +
  #? scale_y_continuous(limits = c(-0.05,1.05), breaks = seq(0,1.0,0.1)) +
  #? scale_x_continuous(limits = c(-0.05,1.05), breaks = seq(0,1.0,0.1)) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 9), axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 12, face = "bold"), axis.title.y = element_text(size = 12, face = "bold"), legend.title = element_text(size = 12, face = "bold"), legend.text =element_text(size= 10))

#Save the plot
ggsave("VASpainsummerwinter2019")
