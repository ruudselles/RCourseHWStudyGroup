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
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1))+
  geom_jitter() +
  coord_flip()

# nu voor geslacht in deze plot een andere kleur toevoegen
Example_LongFormat %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  coord_flip()

# Facet wrap----------------
# hiermee creeer je losse kleine grafieken voor in dit geval de verschillende meetmomenten
Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter() +
  facet_wrap(~rounddescription)

Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Combinatie van filter en plot ------------- Hier krijg ik een witvlak als plot met foutmelding: Error: Faceting variables must have at least one value
Example_LongFormat %>%
  filter(vasPijnGemiddeld_1 < 100)

  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)


Example_LongFormat %>%
  filter(vasPijnGemiddeld_1 >1) %>%
  filter(vasPijnGemiddeld_1<100)%>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() + facet_wrap(~rounddescription)

# Opslaan met ggsave -----------------

ggsave("vaspijngemgeslacht.png")

# Bar en colom graphs ----------

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

Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1))+
  geom_point() +
geom_smooth()

# Kleur toevoegen voor geslacht
Example_LongFormat%>%
  ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
  geom_point() +
  geom_smooth()

