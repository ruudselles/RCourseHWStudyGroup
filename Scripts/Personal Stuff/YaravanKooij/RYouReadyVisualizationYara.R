#empty global environment
rm(list = ls())

# Load libraries-----------------
library(tidyverse)
library(here)
library(readr)
library(ggbeeswarm)

# Import data  -------------
load(here("data", "Example_LongFormatHashed.RData"))

# Plot maken met ggplot---------
# Met ggplot moet je eerst de 'easthetics' beschrijven, dus welke variabelen wil je op 
# de x- as en welke op de y -as. Vervolgens met een + kan je aangeven welke plot je wilt gebruiken.

#!! Hier staat in antwoord nog data_combined en stap_om week aantal!!

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y= vasPijnGemiddeld_1))+
  geom_point()

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter()

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_quasirandom()

# Na.omit functie------------
# Met de na.omit functie haal je de hele rij waar een missing value in zit eruit

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter()

view(Example_LongFormat)

# nu de groep verdelen intake, 3 maanden en 12maanden middels rounddescription
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1))+
  geom_jitter() +
  coord_flip()

# nu voor geslacht in deze plot een andere kleur toevoegen
#!! Hier staat in antwoord nog twee keer colour colour

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  coord_flip()

# Facet wrap----------------
# hiermee creeer je losse kleine grafieken voor in dit geval de verschillende meetmomenten

# !! In het antwoord wordt ook nog verwezen naar data_combined

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter() +
  facet_wrap(~rounddescription)

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Combinatie van filter en plot ------------- 
#!! Hier staat het antwoord nog fout op de website

Example_LongFormat %>%
  na.omit() %>% 
  filter(vasPijnGemiddeld_1 >1) %>%
  filter(vasPijnGemiddeld_1<100)%>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() + facet_wrap(~rounddescription)

# Opslaan met ggsave -----------------

ggsave("VASpain.png")

# Bar en colom graphs ----------
#! Er wordt nog verwezen naar dataset data_combined
Example_LongFormat %>%
  na.omit()%>%
  group_by(Geslacht)%>%
  summarise(mean = mean(vasPijnGemiddeld_1),
            sd = sd(vasPijnGemiddeld_1),
            n = n(),
            stderr=sd/sqrt(n))%>%
  ggplot(aes(x=Geslacht, y=mean))+
  geom_col() +
  geom_errorbar(aes(x=Geslacht, ymin = mean-stderr, ymax = mean+stderr))

# Correlation and scatterplot -------------
#! Er wordt nog verwezen naar dataset data_combined
Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1))+
  geom_point() +
  geom_smooth()

# Kleur toevoegen voor geslacht
Example_LongFormat%>%
  na.omit() %>%
  ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
  geom_point() +
  geom_smooth()

#VizWhiz 4 ------- veranderen van de achtergrond
#! Er wordt nog verwezen naar dataset data_combined
Example_LongFormat%>%
    na.omit() %>%
    ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
    theme_classic()+
    geom_point() +
    geom_smooth()
   
  Example_LongFormat%>%
    na.omit() %>%
    ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
    theme_minimal()+
    geom_point() +
    geom_smooth()

  # Titel toeovegen en assen benoemen
  Example_LongFormat%>%
    na.omit() %>%
    ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
    theme_classic()+
    geom_point() +
    geom_smooth() +
    labs(title = "Relationship between pain and hand function", 
         x = "VAS pain (0-10)",
         y = "VAS function (0-10)")
  