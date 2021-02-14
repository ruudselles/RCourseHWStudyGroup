# VizWhiz

rm(list = ls())

# Load packages ----

library(tidyverse)
library(here)
library(janitor)
library (readr)
library(ggbeeswarm)

# Importing data --> Vanuit files rechtsonder geupload

data_combined <- Example_LongFormat

# Create scatterplot

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