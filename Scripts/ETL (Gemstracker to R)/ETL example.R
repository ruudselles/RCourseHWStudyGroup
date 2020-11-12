# ETL script demo
# Author:  Jeanne Bakx
# Updated: 10-11-2020

# Required documents --------------------------------------------------------------------------------------------------
# Available in //data/ETL folder
# Codebook_example_73.xlsx
# Codebook_example_81.xlsx
# Example survey 73.xlsx
# Example survey 81.xlsx
# Ref_codebook.xlsx
# Ref_codebook_added_question.xlsx (optional)
# Ref_codebook_removed_question.xlsx (optional)



rm(list = ls())

# Load library
library(readxl)
library(here)
library(tidyverse)
library(lubridate)
library(tidyr)



# CHECK CODEBOOKS FOR ADDED/REMOVED QUESTIONS ---------------------------------------------------------------------------

# Load the codebooks for all surveys
Codebook_73 <-
  read_excel("~/R/RCourseHWStudyGroup/data/ETL/Codebook_example_73.xlsx")

Codebook_81 <-
  read_excel("~/R/RCourseHWStudyGroup/data/ETL/Codebook_example_81.xlsx")

# Merge the codebooks into one large codebook and create the variable "rowID"
Codebook <- rbind(Codebook_73, Codebook_81)  %>%
  unite(id, title, col = "rowID", sep = "_", remove = FALSE)

# Load the reference Codebook
Ref_Codebook <- read_excel("~/R/RCourseHWStudyGroup/data/ETL/Ref_codebook.xlsx")

#Uncomment the line below if you want to check the behavior when a question is added compared to the reference
#Ref_Codebook <-  read_excel("C:/Users/Jeanne/Documents/Equipe/Rcourse/Reference codebooks/Ref_codebook_added_question.xlsx")

#Uncomment the line below if you want to check the behavior when a question is deleted compared to the reference
#Ref_Codebook <-  read_excel("C:/Users/Jeanne/Documents/Equipe/Rcourse/Reference codebooks/Ref_codebook_removed_question.xlsx")

Ref_ID <- Ref_Codebook %>%
  select(rowID)
CheckID <- Codebook %>%
  select(rowID)

# Compare the codebook with its reference to check for missing/new questions
if (dplyr::setequal(Ref_ID, CheckID)) {
  Codebook2 <- Ref_Codebook %>%
    select(rowID, title) %>%
    left_join(Codebook, by = c("rowID"))
  
  message("Perfect match in Codebook! Continue to loading GemsTracker-data...")
  continue <- TRUE
  
} else{
  if (nrow(dplyr::setdiff(CheckID, Ref_ID)) != 0) {
    newID <- dplyr::setdiff(CheckID, Ref_ID)
    
    newQuestions <- Codebook %>%
      inner_join(newID, by = "rowID")
    
  }
  if (nrow(dplyr::setdiff(Ref_ID, CheckID)) != 0) {
    missingID <- dplyr::setdiff(Ref_ID, CheckID)
    
    missingQuestions <- Ref_Codebook %>%
      inner_join(missingID, by = "rowID")
    
  }
  continue <- FALSE
  stop(
    "Mismatch in Codebook! \n   See data-object \"newQuestion\" and/or \"missingQuestion\" for changes compared to reference codebook"
  )
  
}

if (continue) {
  # LOADING RAW DATA -------------------------------------------------------------------------------------------------
  
  #Select directory which contains survey data
  Survey_73 <-
    as.data.frame(read_excel("C:/Users/Jeanne/Documents/Equipe/Rcourse/Data/Example survey 73.xlsx"))
  Survey_81 <-
    as.data.frame(read_excel("C:/Users/Jeanne/Documents/Equipe/Rcourse/Data/Example survey 81.xlsx"))
  
  
 
  #Rewrite answer codes from survey 73 into answers and create factor variables --------------------------------------
  for (k in 1:nrow(Codebook_73)) {
    temp_codebook <- Codebook_73[k, ]
    
    Variable <- temp_codebook$title
    Answer_codes <- temp_codebook$answer_codes %>% str_split("\\|")
    Answers <- temp_codebook$answers %>% str_split("\\|")
    
    if (is.na(Answer_codes)) {
    } else {
      Survey_73[,colnames(Survey_73) == Variable] <- factor(Survey_73[,colnames(Survey_73) == Variable],   
                                                            levels = unlist(Answer_codes),
                                                            labels = unlist(Answers))
    }
  }
      
  
  #Rewrite answer codes from survey 81 into answers and create factor variables ----------------------------------------
  for (k in 1:nrow(Codebook_81)) {
    temp_codebook <- Codebook_81[k, ]
    
    Variable <- temp_codebook$title
    Answer_codes <- temp_codebook$answer_codes %>% str_split("\\|")
    Answers <- temp_codebook$answers %>% str_split("\\|")
    
    if (is.na(Answer_codes)) {
    } else {
      Survey_81[,colnames(Survey_81) == Variable] <- factor(Survey_81[,colnames(Survey_81) == Variable],   
                                                            levels = unlist(Answer_codes),
                                                            labels = unlist(Answers))
    }
  }
  

#Merge the two surveys into one dataframe ------------------------------------------------------------------------------
Data <- data.frame()
Data <- full_join(Survey_73, Survey_81,
    by = c("respondentid", "gtr_track_name", "gto_round_description"),
    suffix = c("_73", "_81")
  )


#Calculation examples --------------------------------------------------------------------------------------------------
Data$completion_days_73 <- round(Data$gto_completion_time_73 - Data$gr2t_track_info_73) #number of days between start of track and completion of survey 73
Data$completion_days_81 <- round(Data$gto_completion_time_81 - Data$gr2t_track_info_81) #number of days between start of track and completion of survey 81



}


