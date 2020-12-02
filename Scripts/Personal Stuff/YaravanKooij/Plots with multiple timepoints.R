# Plots with multiple timepoints--------------

#make sure you have a dataset in long format, with a uniform name for rounddescription for all timepoints you want to plot
# see example below
# data_alles_long_status <- data_alles_long %>% # wide data on alle timepoints
#   inner_join(data_alles_status_wide %>% 
#                select(Patient.traject.ID)) %>% # only with patients you included
#   mutate(rounddescription = rounddescription.x) # with a uniform rounddesriptoin column
#load packages and functions from Mark
source("......../PulseR/Personal stuff/Mark O/Functions_mark.R")
#used the agg_data_graph function
#the inputs are:
#   outcome: name of your outcome mesure, will be on the y axis
#   time_points: select the timpoints you want, will be on de x axis
#   labels: assigns labels to the x axis
#   make aggregated datasets for different timepoints

data_totaal <-  agg_data_graph(outcome = "totaalscore", 
                               time_points = c("Intake", "3 maanden", "12 maanden"), 
                               labels = c("pre-operative", "3 months post-operative", "12 months post-operative"), data_long = data_alles_long_status )
data_pijn <-  agg_data_graph(outcome = "pijnscore", 
                             time_points = c("Intake", "3 maanden", "12 maanden"), 
                             labels = c("pre-operative", "3 months post-operative", "12 months post-operative"), data_long = data_alles_long_status )
data_functie <-  agg_data_graph(outcome = "functiescore", 
                                time_points = c("Intake", "3 maanden", "12 maanden"), 
                                labels = c("pre-operative", "3 months post-operative", "12 months post-operative"), data_long = data_alles_long_status )

# combine into 1 dataframe
data_graph <- data_totaal %>%
  rbind(data_functie) %>%
  rbind(data_pijn) %>%
  mutate(scale = c(rep("Total score", 3), 
                   rep("Function score", 3),
                   rep("Pain score", 3)))
data_graph$scale <- factor(data_graph$scale, levels = c("Total score", "Pain score", "Function score"))

# Make the plot
ggplot(data_graph, aes(x = rounddescription, y = mean)) +
  geom_line(aes(group = scale, colour = scale), size = 1.5) +
  geom_errorbar(width=.1, aes(ymin=min, ymax=max, colour = scale)) +
  geom_point(aes(colour = scale), shape=21, size=1.7) +
  geom_label(aes(label = paste("N = ", N, sep ="")), nudge_y = -10, data = data_functie) +
  ylab("mean PRWE score") + 
  ylim(0,75) +
  xlab("") +
  scale_color_grey() +
  theme_classic() +
  theme(axis.text = element_text(size = 12),
        text = element_text(size = 12))
