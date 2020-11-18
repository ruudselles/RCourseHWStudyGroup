# Load packages ------------------------
library(tidyverse)
library(here)
library(janitor)

#Clear the workspace ---------------
rm(list = ls())

# Load data --------
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_LongFormatHashed.RData")
load("~/Documents/GitHub/RCourseHWStudyGroup/data/Example_WideFormatHashed.RData")

# Run function clean names ----------------
cleannames_data_long <- clean_names(Example_LongFormat)

# View dataframe--------------
view(cleannames_data_long)

# Create new dataframe ----------------

# Waarbij je de volgorde kan aanpassen of bepaalde variabelen kan selecteren.
# Waarbij select_data_long de naam is van het nieuwe dataframe. 
# En je na select eerst aangeeft vanuit welke dataset deze informatie moet worden genomen en daarna welke variabelen je wilt selecteren
select_data_long <-select(Example_LongFormat, behandeling, rounddescription, everything())
                     
# Delete variables with -
select_data_long <- select(select_data_long, -Patient.traject.ID)

# Pipe function -------------

# Pipe function %>%, daarmee kan je meerdere functies achter elkaar zetten en stel je direct 
# al vast uit welke dataset dit gehaald moet worden en hoef je dat dus niet meer te specificeren
data_long_clean <-Example_LongFormat %>%
  clean_names() %>%
  select(behandeling, rounddescription, everything()) %>%
  select(-patient_traject_id)

# Met de summary function kan je samenvatting krijgen van de data in een bepaalde dataframe
summary(Example_LongFormat)

# Data op gemiddelde pijn sorteren, dan maak je eerst nieuwe dataset aan 
# en laat je eerst zien uit welke data set je dit haalt (hier data_long)
# dan sorteer je middels arrange en kan je specifiek alleen vas pijn gemiddeld selecteren
data_desc <- Example_LongFormat%>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)
  

summary(data_desc)
  
# Data filter  -------------

# Data filteren voor alleen vrouwen in een nieuwe dataframe
data_desc_female <- Example_LongFormat%>%
  filter(Geslacht == "Vrouw") %>%
arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)

# Data filteren voor alleen mannen
data_desc_male <- Example_LongFormat%>%
  filter(Geslacht == "Man") %>%
  arrange(desc(vasPijnGemiddeld_1))%>%
  select(vasPijnGemiddeld_1)         

#It is important to realize the difference in are when you are considering these three almost similar sets of 2 lines of code in R:

# 1) 
Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

#These two lines just print the result in the console but does not store the data.

#2) 
Example_LongFormat <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

# These lines add a variable to the data frame Example_LongFormat. 

view(Example_LongFormat)
#You can check this with the comment view (Example_LongFormat),the last variable should now by the variable vasPijnGemiddeld_50. 

#Or you can use names(Example_LongFormat) to just check all variables in the data frame.
names(Example_LongFormat)  

#3)
new_vasgemiddeld50 <- Example_LongFormat%>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)

#These lines of code leave the data frame vasPijnGemiddeld_50 unchanged, but creates a new data frame called new_vasgemiddeld that has all variables from Example_LongFormat and with the 
#variable vasPijnGemiddeld_50 added. Again, you can view(new_frame) or use names(new_frame)

# Group by functie ----------- 
data_summarize<-Example_LongFormat%>%
  group_by(Geslacht)%>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm=TRUE))

# om een filter toe te voegen, in dit voorbeeld voor geslacht. De summarise functie kan je gebruiken om vervolgens deze gegevens te tonen. 
# Je geeft daarbij een naam aan de variabele (dus bv max_VASpain, dat is als het ware een nieuwe kolom) en met een komma ga je naar de volgende lijn voor een nieuwe optie
data_summarize<-Example_LongFormat%>%
  group_by(Geslacht) %>%
  summarize(max_VASpain = max(vasPijnGemiddeld_1, na.rm =TRUE),
  min_VASpain = min(vasPijnGemiddeld_1,na.rm = TRUE),
  mean_VASpain= mean(vasPijnGemiddeld_1,na.rm = TRUE),
  median_VASpain= median(vasPijnGemiddeld_1, na.rm =TRUE),
  sd_VASpain=sd(vasPijnGemiddeld_1, na.rm = TRUE))

view(data_summarize)

# Je kan dit ook voor meerdere variabelen doen, dus bv geslacht en aangedane hand
data_summarize<-Example_LongFormat%>%
  group_by(Geslacht, zijde) %>%
  summarise(max_VASpain = max(vasPijnGemiddeld_1, na.rm =TRUE))
  
# Je kan deze data opslaan in een nieuwe data-frame door dit aan het begin toe te voegen
PainMalesFemalesLeftRight <- Example_LongFormat%>%
  group_by(Geslacht, zijde) %>%
  summarise(max_VASpain = max(vasPijnGemiddeld_1, na.rm =TRUE),
            min_VASpain = min(vasPijnGemiddeld_1,na.rm = TRUE),
            mean_VASpain= mean(vasPijnGemiddeld_1,na.rm = TRUE),
            sd_VASpain = sd(vasPijnGemiddeld_1, na.rm = TRUE),
            median_VASpain= median(vasPijnGemiddeld_1, na.rm =TRUE))

# Mutate-------------

# met mutate voeg je een nieuwe variabele/ kolom toe. Ook hier doe je voor het ( de nieuwe 
# naam schrijven van de variabele/kolom
# let op hierbij moet je wel eerst data_long <- data_long%>% schrijven zodat het duidelijk is
data_long <-Example_LongFormat%>%
  mutate(pain_avarage = mean((vasPijnGemiddeld_1+vasPijnRust_1+vasPijnBelasten_1)/3), na.rm = TRUE)

# is een bepaalde variabele hoger dan 50, zet die in een nieuwe kolom
data_long <- Example_LongFormat%>%
  mutate(pain_avarage = mean((vasPijnGemiddeld_1+vasPijnRust_1+vasPijnBelasten_1)/3), na.rm = TRUE) %>%
  mutate(vasPijnGemiddeld_50 = vasPijnGemiddeld_1>50)




