#Load dataset
load("D:/USO RTW data voor artikel/Pols_lang20200505.Rdata")

#Load package: tidyverse
library(tidyverse)

#Load RTW function written bij MJW van der Oest
#In this function the answers to the RTW questionnaires are transformed to an easy analyzable dataframe
RTW_bewerking_50 <- function(DF){
  #DF = RTW dataframe
  for(i in 1:nrow(DF)){
    if(is.na(DF$werkzaam[i])){
      DF$werkzaam[i] <- "Nee, als gevolg van de hand/polsklacht waarvoor u wordt behandeld"
    }
  }
  
  DF_short <- DF %>% 
    select(c(Patient.traject.ID,
             werkzaam,
             aangepastWerk, 
             urenNormaal, 
             urenNu, 
             normaalWerk, 
             rounddescription)) %>%
    filter(urenNormaal > 0) %>%
    filter(urenNormaal < 80) %>%
    filter(werkzaam != "Nee, als gevolg van iets anders") %>%
    select(-werkzaam)
  
  DF_short <- DF_short %>% 
    mutate(Percentage_werk = urenNu/urenNormaal)
  DF_short <- DF_short %>% 
    mutate(Event = ifelse(is.na(aangepastWerk),0,
                          ifelse(aangepastWerk == "Oorspronkelijke werkzaamheden",
                                 ifelse(Percentage_werk > 0.50 , 1,0), 0))) %>%
    mutate(EventTime = normaalWerk)
  
  for(i in 1:nrow(DF_short)){
    if(is.na(DF_short$EventTime[i])){
      if(DF_short$rounddescription[i] == "6 weken"){
        DF_short$EventTime[i] <- 6
      }
      if(DF_short$rounddescription[i] == "3 maanden"){
        DF_short$EventTime[i] <- 13
      }
      if(DF_short$rounddescription[i] == "6 maanden"){
        DF_short$EventTime[i] <- 26
      }
      if(DF_short$rounddescription[i] == "12 maanden"){
        DF_short$EventTime[i] <- 52
      }
    }
  }
  
  DF_wide_6 <- DF_short %>% 
    filter(rounddescription == "6 weken") %>% 
    select(-rounddescription)
  
  DF_wide_6_w <- DF_wide_6 %>% 
    filter(Event == 1)
  DF_wide_6_gw <- DF_wide_6 %>% 
    filter(Event == 0)
  
  
  DF_wide_13 <- DF_short %>% 
    filter(rounddescription == "3 maanden") %>% 
    select(-rounddescription) %>%
    anti_join(DF_wide_6_w, by = "Patient.traject.ID")
  
  DF_wide_13_w <- DF_wide_13 %>%
    filter(Event == 1)
  DF_wide_13_gw <- DF_wide_13 %>% 
    filter(Event == 0)
  
  
  DF_wide_26 <- DF_short %>% 
    filter(rounddescription == "6 maanden") %>% 
    select(-rounddescription) %>%
    anti_join(DF_wide_6_w, by = "Patient.traject.ID") %>%
    anti_join(DF_wide_13_w, by = "Patient.traject.ID")
  
  DF_wide_26_w <- DF_wide_26 %>%
    filter(Event == 1)
  DF_wide_26_gw <- DF_wide_26 %>% 
    filter(Event == 0)
  
  
  DF_wide_52 <- DF_short %>% 
    filter(rounddescription == "12 maanden") %>% 
    select(-rounddescription) %>%
    anti_join(DF_wide_6_w, by = "Patient.traject.ID") %>%
    anti_join(DF_wide_13_w, by = "Patient.traject.ID") %>% 
    anti_join(DF_wide_26_w, by = "Patient.traject.ID")
  
  DF_wide_52_w <- DF_wide_52 %>%
    filter(Event == 1)
  DF_wide_52_gw <- DF_wide_52 %>% 
    filter(Event == 0)
  
  
  DF_wide_gw <- DF_wide_52_gw
  
  PtID <- DF_wide_gw %>% 
    select(`Patient.traject.ID`)
  DF_wide_26_gw <- anti_join(DF_wide_26_gw, PtID) %>%
    anti_join(DF_wide_52_w, by = "Patient.traject.ID")
  DF_wide_gw <- rbind(DF_wide_gw, DF_wide_26_gw)
  
  PtID <- DF_wide_gw %>% 
    select(`Patient.traject.ID`)
  DF_wide_13_gw <- anti_join(DF_wide_13_gw, PtID) %>%
    anti_join(DF_wide_52_w, by = "Patient.traject.ID") %>%
    anti_join(DF_wide_26_w, by = "Patient.traject.ID")
  DF_wide_gw <- rbind(DF_wide_gw, DF_wide_13_gw)
  
  PtID <- DF_wide_gw %>% 
    select(`Patient.traject.ID`)
  DF_wide_6_gw <- anti_join(DF_wide_6_gw, PtID) %>%
    anti_join(DF_wide_52_w, by = "Patient.traject.ID") %>%
    anti_join(DF_wide_26_w, by = "Patient.traject.ID") %>%
    anti_join(DF_wide_13_w, by = "Patient.traject.ID")
  DF_wide_gw <- rbind(DF_wide_gw, DF_wide_6_gw)
  
  DF_new <- rbind(DF_wide_6_w, DF_wide_13_w, DF_wide_26_w, DF_wide_52_w, DF_wide_gw)
  DF_new_a <- DF_new %>% filter(EventTime <= 52) #remove missing
  DF_new_a$Event[is.na(DF_new_a$Event)] <- 0
  
  rm(DF_wide_13, DF_wide_13_gw, DF_wide_13_w, DF_wide_26, DF_wide_26_gw, DF_wide_26_w, DF_wide_6, DF_wide_6_gw, DF_wide_6_w, DF_wide_52, DF_wide_52_gw, DF_wide_52_w, DF_wide_gw)
  return(DF_new_a)
}

#Choose the treatment that you want tot analyse
Study_population <- Pols_lang$InV_Pols_lang %>%
  filter(behandeling == "Ulna verkorting") %>%  
  mutate(zwaarteBeroep = ifelse(zwaarteBeroep == "Geen betaalde arbeid (o.a. uitkering gepensioneerd: return to work vragenlijst vervalt)", "Geen",
                                ifelse(zwaarteBeroep == "Licht fysieke arbeid (bijv. kantoorwerk)", "Licht",
                                       ifelse(zwaarteBeroep == "Matig fysieke arbeid (bijv. werken in een winkel)", "Matig",
                                              ifelse(zwaarteBeroep == "Zwaar fysieke arbeid (bijv. in de bouw, stratenmaker)", "Zwaar", "Error")))))%>%
  select(Patient.traject.ID, Respondent.ID, zijde, zwaarteBeroep, hoeLangKlacht, Geslacht, Leeftijd)

#Exclude patients that did not have (a paid) employment before surgery
Study_population <- Study_population%>%
  filter(zwaarteBeroep != "Geen")

#Apply the RTW function to the RTW questionnaire in the dataset
RTW_50 <- RTW_bewerking_50(Pols_lang$RTW)

#Merge this datset to the patients that you want tot analyse
data <- Study_population %>%
  inner_join(RTW_50, by = c("Patient.traject.ID")) 

#Now your dataframe is ready for RTW/Survival analysis

#Categorical data: e.g. logrank test
#Continuous data: e.g. Cox proportional hazard regression
#Check whether the assumptions of the model that you used hold 
#More information on survival analysis can be found in google


#RTW for categorical variables can be visualized using Kaplan-Meier curves (MJW van der Oest made a video on this topic)








