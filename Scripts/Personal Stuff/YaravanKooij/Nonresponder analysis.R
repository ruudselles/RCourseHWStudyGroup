# Load the packages that we often use
library(tidyverse)
library("plyr")
library(lubridate)
library(tableone)
library(broom)
library("Rmisc")
library(rJava)
select <- dplyr::select #define the library from which the select function needs to be used

# Load the specific functions written by Lisa Hoogendam needed for this script ----------
Process_intake_vervolg <- function(InV){
  InV_3 <- filter(InV, rounddescription == "3 maanden")
  InV_OK <- filter(InV, rounddescription == "OK check")
  InV_0 <- filter(InV, rounddescription == "Intake")
  InV <- InV_3
  PtID <- InV %>% select(`Patient.traject.ID`)
  InV_OK <- anti_join(InV_OK, PtID)
  InV <- rbind(InV, InV_OK)
  PtID <- InV %>% select(`Patient.traject.ID`)
  InV_0 <- anti_join(InV_0, PtID)
  InV <- rbind(InV, InV_0)
}

col.number <- function(keyword, questionnaire){
  if(length(keyword) == 1){
    number.return <- grep(paste("^(?=.*", keyword[1], ").*$", sep = ""), colnames(questionnaire), ignore.case = TRUE, perl = TRUE)
  } else if(length(keyword) == 2){
    number.return <- grep(paste("^(?=.*", keyword[1], ")(?=.*", keyword[2], ").*$", sep = ""), colnames(questionnaire), ignore.case = TRUE, perl = TRUE)
  } else if(length(keyword) == 3){
    number.return <- grep(paste("^(?=.*", keyword[1], ")(?=.*", keyword[2], ")(?=.*", keyword[3], ").*$", sep = ""), colnames(questionnaire), ignore.case = TRUE, perl = TRUE)
  } else if(length(keyword) == 4){
    number.return <- grep(paste("^(?=.*", keyword[1], ")(?=.*", keyword[2], ")(?=.*", keyword[3], ")(?=.*", keyword[4], ").*$", sep = ""), colnames(questionnaire), ignore.case = TRUE, perl = TRUE)
  } else if(length(keyword) == 5){
    number.return <- grep(paste("^(?=.*", keyword[1], ")(?=.*", keyword[2], ")(?=.*", keyword[3], ")(?=.*", keyword[4], ")(?=.*", keyword[5], ").*$", sep = ""), colnames(questionnaire), ignore.case = TRUE, perl = TRUE)
  } else { stop("Teveel of te weinig keywords. Minimaal 1, maximaal 5.")}
  return(number.return)
}
Intake_func_2 <- function(dataset){
  Intake_num <- grep("Intake", names(eval(parse(text = dataset))))
  
  #selecteren intake/vervolg
  Intake <- eval(parse(text = paste(dataset, "$",
                                    names(eval(parse(text = dataset)))[Intake_num], sep = ""))) %>%
    select(Respondent.ID, Patient.traject.ID, bmi, gewicht, lengte, alcohol, roken, eerderOK,
           medGeschiedenis_reuma, medGeschiedenis_hartBloedvaten, medGeschiedenis_tromboseVasculitis, medGeschiedenis_diabetes, medGeschiedenis_longenLuchtwegen, medGeschiedenis_leverNieren,
           medGeschiedenis_hersenenZenuwen, medGeschiedenis_bottenSpieren, medGeschiedenis_aambeienSpataders, medGeschiedenis_hematomen,
           werkWeek,
           # Hoeveel uren werkt u op dit moment per week?
           ziekteDuur,
           # Hoeveel weken bent u tot nu toe ziekgemeld geweest als gevolg van de klacht waarvoor u behandeld wilt worden?
           letselschade) %>%
    mutate(Comorbiditeit = ifelse(medGeschiedenis_hartBloedvaten == "Ja", "Ja",
                                  ifelse(medGeschiedenis_tromboseVasculitis == "Ja", "Ja",
                                         ifelse(medGeschiedenis_longenLuchtwegen == "Ja", "Ja",
                                                ifelse(medGeschiedenis_leverNieren == "Ja", "Ja",
                                                       ifelse(medGeschiedenis_hersenenZenuwen == "Ja", "Ja", "Nee"))))))
  return(Intake)
}
start_script_3 <- function(dataset, aandoening){
  if(length(dataset) != 1){stop("Deze functie werkt maar met een dataset tegelijk")}else
    InV_num <- grep("InV", names(eval(parse(text = dataset))))
  #selecteren intake/vervolg
  InV <- eval(parse(text = paste(dataset, "$",
                                 names(eval(parse(text = dataset)))[InV_num], sep = ""))) %>%
    Process_intake_vervolg()
  
  # Behandeldatum <- eval(parse(text = paste(dataset, "Behandeldatum", sep = "$"))) %>%
  # select(Patient.traject.ID, Respondent.ID, behandelingDatum)
  InV$behandelingDatum <- as.Date(InV$behandelingDatum, format = "%Y-%m-%d")
  if(length(aandoening) == 1){
    if(!aandoening %in% unique(InV$behandeling)){stop("Deze behandeling komt niet voor in deze dataset")}
    InV_aandoening <- InV %>%
      filter(behandeling == aandoening) #%>%
    # inner_join(Behandeldatum, by=c("Respondent.ID", "Patient.traject.ID"))
  }
  else{
    if(any(!aandoening %in% unique(InV$behandeling))){stop("(Ten minste een van deze behandelingen komt niet voor in deze dataset")}
    InV_aandoening <- InV %>%
      filter(behandeling == aandoening[1]) # %>%
    # inner_join(Behandeldatum, by=c("Respondent.ID", "Patient.traject.ID"))
    for(i in 2:length(aandoening)){
      InV_nieuw <- InV %>%
        filter(behandeling == aandoening[i]) # %>%
      # inner_join(Behandeldatum, by=c("Respondent.ID", "Patient.traject.ID"))
      InV_aandoening <- InV_aandoening %>%
        rbind(InV_nieuw)
    }
  }
  InV_aandoening <- InV_aandoening %>%
    filter(!is.na(behandelingDatum))
  return(InV_aandoening)
}

#Load the dataset (should be saved at an encrypted USB)
load("D:/USO drf data voor artikel/Pols_lang20200808.Rdata")
#Choose patient who underwent the treatment of interest: in this case ulna shortening
Intake_patients <- start_script_3("Pols_lang", "Ulna verkorting") %>%
  select(Patient.traject.ID, Respondent.ID, zijde, dominant, zwaarteBeroep, hoeLangKlacht, secondOpinion, Leeftijd, Geslacht, behandelingDatum)%>%
  mutate(zwaarteBeroep = ifelse(zwaarteBeroep == "Geen betaalde arbeid (o.a. uitkering gepensioneerd: return to work vragenlijst vervalt)", "Geen",
                                ifelse(zwaarteBeroep == "Licht fysieke arbeid (bijv. kantoorwerk)", "Licht",
                                       ifelse(zwaarteBeroep == "Matig fysieke arbeid (bijv. werken in een winkel)", "Matig",
                                              ifelse(zwaarteBeroep == "Zwaar fysieke arbeid (bijv. in de bouw, stratenmaker)", "Zwaar", "Error")))))%>%
  filter(behandelingDatum < "2019-08-01") #Patients treated after this date had a follow-up time less than a year at the time of the data export
#Choose your outcome of interest: in this case Patient Rated Wrist Hand Evaluation (PRWHE)
PRWHE_intake_wide <- Pols_lang$PRWHE %>%
  filter(rounddescription == "Intake") %>% #filter your outcome on rounddescription (timepoint) "intake"
  mutate(functiescore = functiescore*2)%>%
  select(c(Patient.traject.ID, Respondent.ID,
           totaalscore, pijnscore, functiescore)) %>%
  dplyr::rename_all(function(x) paste0(x, "_intake"))%>%
  mutate(Patient.traject.ID = as.double(Patient.traject.ID_intake),
         Respondent.ID = as.double(Respondent.ID_intake),
         Patient.traject.ID_intake = NULL,
         Respondent.ID_intake = NULL) %>%
  distinct(Patient.traject.ID, .keep_all = T)
PRWHE_12m_wide <- Pols_lang$PRWHE %>%
  filter(rounddescription == "12 maanden") %>% #filter your outcome on the follow-up moment of interest:in this case 3 months
  select(c(Patient.traject.ID, Respondent.ID,
           totaalscore, pijnscore, functiescore)) %>%
  mutate(functiescore = functiescore*2)%>%
  dplyr::rename_all(function(x) paste0(x, "_12m"))%>%
  mutate(Patient.traject.ID = as.double(Patient.traject.ID_12m),
         Respondent.ID = as.double(Respondent.ID_12m),
         Patient.traject.ID_12m = NULL,
         Respondent.ID_12m = NULL) %>%
  distinct(Patient.traject.ID, .keep_all = T)

#Keep only the patients that filled in the intake questionnaire
rdata <- Intake_patients %>%
  inner_join(PRWHE_intake_wide, by = c("Respondent.ID", "Patient.traject.ID"))

#Define responders: in this case responders are patients that filled in the questionnaire at intake AND after 12 months
responders <- rdata%>%
  inner_join(PRWHE_12m_wide, by = c("Respondent.ID", "Patient.traject.ID")) %>% #use inner_join()
  mutate(Level = "Responder")

#Define nonresponders: in this case nonresponders are patients that filled in the questionnaire at intake but NOT after 12 months
nonresponders <- rdata %>%
  anti_join(PRWHE_12m_wide, by = c("Respondent.ID", "Patient.traject.ID"))%>%
  mutate(Level = "Non-responder")

#Combine the responders and nonresponders in one dataframe
data_resp_analyse <- responders %>%
  rbind.fill(nonresponders)

#Choose the variables which you want to compare between responders and nonresponders
my_vars <- c("Leeftijd","Geslacht","hoeLangKlacht", "zwaarteBeroep",
             "pijnscore_intake", "functiescore_intake")

#Tell R which variables are factors
my_factorvars <- c("Geslacht","zwaarteBeroep")

#Tell R which continious variables should be treated as not normally distributed
hist(data_resp_analyse$hoeLangKlacht)
my_nonnormal <- c("hoeLangKlacht")

#Do the responder analysis using the CreateTableOne function
table_resp_analyse <- CreateTableOne(data = data_resp_analyse,
                                     strata = "Level", #The strata arguments is where you define based on which factor groups are compared
                                     vars = my_vars,
                                     factorVars = my_factorvars)
table_resp_analyse <- print(table_resp_analyse,
                            showAllLevels = TRUE,
                            printToggle = FALSE,
                            noSpaces = TRUE,
                            nonnormal = my_nonnormal)
table_resp_analyse <- broom::tidy(table_resp_analyse)