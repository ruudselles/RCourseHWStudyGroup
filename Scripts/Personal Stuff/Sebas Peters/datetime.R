#clear the workspace ------
rm(list = ls())



#Load packages ----------
library(tidyverse)
library(here)
library(janitor)
library(pulseCloud)
library(lubridate)

#Check how many days there are between June 21 and December 28 in the year 2020.
as.Date("2020-12-28")-as.Date("2020-06-21")


#load data-----
token <- get_token()

data <- cloud_read("Gonio_ICHOM_gc_sample_20230112_54239979cdfc41cc9de4bd02b1b55054.csv", bucket = "pulse_cloud_prod")

#Check if the date of the treatment in the example dataset is correctly configured as a date or not.
data$Behandeldatum %>% str()

data$Behandeldatum <- as.Date(data$Behandeldatum)

#We see that the date of treatment is already formatted as a date, but let's pretend this is a string variable that we would like to change to a date using the lubridate package. First, check the format of the date of treatment.
data$Behandeldatum %>% view()

#Use the lubridate package to change date of treatment to a date.
data$Behandeldatum %>% ymd()

#Create a simple histogram (geom_histogram) to see the number of treatments conducted over time in the dataset. Set the color of the histogram to blue and the fill to grey.
ggplot(data, aes(x = Behandeldatum)) + geom_histogram(color = "blue", fill = "grey")

ggplot(data, aes(x = Behandeldatum)) + geom_histogram(color = "blue", fill = "grey") + xlim(as.Date("2022-01-01"), as.Date("2022-06-30"))

data$start_time <- dmy_hms(data$start_time)

data$start_time <- hour(data$start_time), minute(data$start_time), second(data$start_time)

data$interval <- interval(start = data$start_time, end = data$completion_time)
data$interval <- is.interval(data$interval)
