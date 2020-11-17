#empty global environment
rm(list = ls())

# Load libraries-----------------
library(tidyverse)
library(here)
library(readr)
library(ggbeeswarm)

# Importeren data  -------------
load(here("data", "Example_LongFormatHashed.RData"))

# data long kan je gewoon gebruiken ipv Example_LongFormat. 
# Plot maken met ggplot---------
# Met ggplot moet je eerst de 'eastheics' beschrijven, dus welke variabelen wil je op 
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

view(data_long)

data_long %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter()

# nu de groep verdelen intake, 3 maanden en 12maanden middels rounddescription
Example_LongFormat %>%
  ggplot(aes(x=rounddescription, y=vas_pijn_gemiddeld_1))+
  geom_jitter() +
  coord_flip()

# nu voor geslacht in deze plot een andere kleur toevoegen
Example_LongFormat %>%
  ggplot(aes(x=rounddescription, y=vas_pijn_gemiddeld_1, colour = geslacht))+
  geom_jitter() +
  coord_flip()

# Facet wrap----------------
# hiermee creeer je losse kleine grafieken voor in dit geval de verschillende meetmomenten
Example_LongFormat %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1))+
  geom_jitter() +
  facet_wrap(~rounddescription)

Example_LongFormat %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1, colour = geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Combinatie van filter en plot -------------
Example_LongFormat %>%
  filter(vas_pijn_gemiddeld_1 <1) %>%
  filter(vas_pijn_gemiddeld_1>100)%>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1, colour = geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Opslaan met ggsave -----------------

ggsave("vaspijngemgeslacht.png")

# Bar en colom graphs ----------

Example_LongFormat %>%
  group_by(geslacht)%>%
  na.omit()%>%
  summarise(mean = mean(vas_pijn_gemiddeld_1),
    sd = sd(vas_pijn_gemiddeld_1),
    n = n(),
    stderr=sd/sqrt(n))%>%
  ggplot(aes(x=geslacht, y=mean))+
  geom_col() +
  geom_errorbar(aes(x=geslacht, ymin = mean-stderr, xmax = mean+stderr))

# Correlation and scatterplot -------------

Example_LongFormat%>%
  ggplot(aes(x= vas_pijn_gemiddeld_1, y= vas_functie_1))+
  geom_point() +
geom_smooth()

# Kleur toevoegen voor geslacht
Example_LongFormat%>%
  ggplot(aes(x= vas_pijn_gemiddeld_1, y= vas_functie_1, colour=geslacht))+
  geom_point() +
  geom_smooth()

