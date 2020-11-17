# Load -----------------

library(tidyverse)
library(here)
install.packages("ggbeeswarm")
library(readr)
library(ggbeeswarm)

# Importeren data  -------------
data_combined <- read_csv(here("data", "data_long_clean_new.csv"))

# data long kan je gewoon gebruiken ipv data_combined. 

# Plot maken met ggplot---------
# Met ggplot moet je eerst de 'eastheics' beschrijven, dus welke variabelen wil je op 
# de x- as en welke op de y -as. Vervolgens met een + kan je aangeven welke plot je wilt gebruiken.

data_combined %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1))+
  geom_point()

data_combined %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1))+
  geom_jitter()

data_combined %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1))+
  geom_quasirandom()

# Na.omit functie------------
# Met de na.omit functie haal je de hele rij waar een missing value in zit eruit

data_combined %>%
  na.omit() %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1))+
  geom_jitter()

view(data_long)

data_long %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter()

# nu de groep verdelen intake, 3 maanden en 12maanden middels rounddescription
data_combined %>%
  ggplot(aes(x=rounddescription, y=vas_pijn_gemiddeld_1))+
  geom_jitter() +
  coord_flip()

# nu voor geslacht in deze plot een andere kleur toevoegen
data_combined %>%
  ggplot(aes(x=rounddescription, y=vas_pijn_gemiddeld_1, colour = geslacht))+
  geom_jitter() +
  coord_flip()

# Facet wrap----------------
# hiermee creeer je losse kleine grafieken voor in dit geval de verschillende meetmomenten
data_combined %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1))+
  geom_jitter() +
  facet_wrap(~rounddescription)

data_combined %>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1, colour = geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Combinatie van filter en plot -------------
data_combined %>%
  filter(vas_pijn_gemiddeld_1 <1) %>%
  filter(vas_pijn_gemiddeld_1>100)%>%
  ggplot(aes(x=geslacht, y=vas_pijn_gemiddeld_1, colour = geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Opslaan met ggsave -----------------

ggsave("vaspijngemgeslacht.png")

# Bar en colom graphs ----------

data_combined %>%
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

data_combined%>%
  ggplot(aes(x= vas_pijn_gemiddeld_1, y= vas_functie_1))+
  geom_point() +
geom_smooth()

# Kleur toevoegen voor geslacht
data_combined%>%
  ggplot(aes(x= vas_pijn_gemiddeld_1, y= vas_functie_1, colour=geslacht))+
  geom_point() +
  geom_smooth()

