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


#We see that the date of treatment is already formatted as a date, but let's pretend this is a string variable that we would like to change to a date using the lubridate package. First, check the format of the date of treatment.
data$Behandeldatum %>% view()

#Use the lubridate package to change date of treatment to a date.
data$Behandeldatum %>% ymd()

#Create a simple histogram (geom_histogram) to see the number of treatments conducted over time in the dataset. Set the color of the histogram to blue and the fill to grey.
ggplot(data, aes(x = Behandeldatum)) + geom_histogram(color = "blue", fill = "grey")

ggplot(data, aes(x = Behandeldatum)) + geom_histogram(color = "blue", fill = "grey") + xlim(as.Date("2022-01-01"), as.Date("2022-06-30"))

#load data-----
token <- get_token()

data <- cloud_read("Gonio_ICHOM_gc_sample_20230112_54239979cdfc41cc9de4bd02b1b55054.csv", bucket = "pulse_cloud_prod")

#Check if the date of the treatment in the example dataset is correctly configured as a date or not.
data$Behandeldatum %>% str()

#clean names
data <- clean_names(data)

#select relevant variables------
data_date <- select(data, respondent_track_id, respondent_id, track_name, track_info_x, respondent_track_start_date, respondent_track_end_date, behandeldatum, start_time, completion_time, valid_from, valid_until)

#Change variable classes----
data_date$respondent_track_id <- as.numeric(data_date$respondent_track_id)
data_date$respondent_id <- as.numeric(data_date$respondent_id)

data_date$track_name <- as.factor(data_date$track_name)
data_date$track_info_x <- as.factor(data_date$track_info_x)

data_date$respondent_track_start_date <- ymd_hms(data_date$respondent_track_start_date)
data_date$respondent_track_end_date <- ymd_hms(data_date$respondent_track_end_date)

data_date$behandeldatum <- as.Date(data_date$behandeldatum)

data_date$start_time <- ymd_hms(data_date$start_time)
data_date$completion_time <- ymd_hms(data_date$completion_time)
data_date$valid_from <- ymd_hms(data_date$valid_from)
data_date$valid_until <- ymd_hms(data_date$valid_until)

#make variables completion_week, completion_year and duration_questionnaire in seconds
data_date$duration_questionnaire_sec <- interval(start = data_date$start_time, end = data_date$completion_time)
data_date$duration_questionnaire_sec <- seconds(data_date$duration_questionnaire_sec)

data_date$completion_date <- as.Date(data_date$completion_time)
data_date$completion_week <- week(data_date$completion_time)
data_date$completion_year <- year(data_date$completion_time)

#Select dataset for analyses-----
data_analyses <- data_date %>% select(completion_date, completion_week, duration_questionnaire_sec, track_name)


