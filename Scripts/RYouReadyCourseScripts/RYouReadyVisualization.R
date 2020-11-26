#empty global environment
rm(list = ls())

# Load libraries-----------------
library(tidyverse)
library(here)
library(readr)
library(ggbeeswarm)

# Import data  -------------
load(here("data", "Example_LongFormatHashed.RData"))

# !! Hier staat op de website data_long en data_combined
# !! Hier staat in antwoord nog data_combined en stap_om week aantal

# Create scatterplot ------------------
Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y= vasPijnGemiddeld_1))+
  geom_point()

# Create geom_jitter plot ------------------
Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter()

# Create geom_quasi random plot ------------------
Example_LongFormat %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_quasirandom()

#  Na.omit. Distribution VAS pain by gender and remove missing data with na.omit --------
# !! Hier staat op de website data_long en data_combined
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter()

# Different time point-------- rounddescription
# !! Hier staat op de website data_long en data_combined
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1))+
  geom_jitter() +

# Add  coordinate flip  and colour---------
# !! Hier staat op de website data_long en data_combined

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1))+
  geom_point() +
  coord_flip()

# Add  coordinate flip  and colour based on gender---------
#!! Hier staat in antwoord nog twee keer colour colour
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=rounddescription, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_point() +
  coord_flip()

# Facet wrap---------------- 
# !! In het antwoord wordt ook nog verwezen naar data_combined

Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Add colour based on gender
Example_LongFormat %>%
  na.omit() %>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() +
  facet_wrap(~rounddescription)

# Combinaton filter and plot ------------- 
#!! Hier staat het antwoord nog fout op de website (>100 en <0) . Volgens mij klopt het in onderstaand script
# !! In het antwoord wordt ook nog verwezen naar data_combined

Example_LongFormat %>%
  na.omit() %>% 
  filter(vasPijnGemiddeld_1 >1) %>%
  filter(vasPijnGemiddeld_1<100)%>%
  ggplot(aes(x=Geslacht, y=vasPijnGemiddeld_1, colour = Geslacht))+
  geom_jitter() + facet_wrap(~rounddescription)

# Save with ggsave -----------------

ggsave("VASpain.png")

# Bar and colom graphs ----------

#!! Er wordt nog verwezen naar dataset data_combined
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
#!! Er wordt nog verwezen naar dataset data_combined
Example_LongFormat%>%
  na.omit()%>%
  ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1))+
  geom_point() +
  geom_smooth()

# Add colour for gender
Example_LongFormat%>%
  na.omit() %>%
  ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
  geom_point() +
  geom_smooth()

#VizWhiz 4 
# Change background with theme ----------
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

  # Layout graph title and axis ---------
  #! Er wordt nog verwezen naar dataset data_combined
  Example_LongFormat%>%
    na.omit() %>%
    ggplot(aes(x= vasPijnGemiddeld_1, y= vasFunctie_1, colour=Geslacht))+
    theme_classic()+
    geom_point() +
    geom_smooth() +
    labs(title = "Relationship between pain and hand function", 
         x = "VAS pain (0-10)",
         y = "VAS function (0-10)")
  