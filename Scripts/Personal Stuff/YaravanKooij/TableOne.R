# Now  load the right file with the trajectory data in the console
library(tidyverse)
library("openxlsx")
R_data_drf_wide_jhs <- read.xlsx("YOUR DATA")

#Recommended package
library(tableone)

#Specify the factors that you want to include in Table 1
my_vars <- c("Leeftijd","Geslacht","hoeLangKlacht", 
             "zwaarteBeroep","dominant_behandeld","pijnscore_intake",
             "functiescore_intake")

#Tell R which variables are factors
my_factorvars <- c("Geslacht","zwaarteBeroep","dominant_behandeld")

#Tell R what variables do not have a "normal distribution"
hist(R_data_drf_wide_jhs$hoeLangKlacht)
my_nonnormal <- c("hoeLangKlacht", "pijnscore_intake", "functiescore_intake")

table1 <- CreateTableOne(vars = my_vars,
                         factorVars = my_factorvars,
                         data = R_data_drf_wide_jhs)

table1 <- print(table1, 
                nonnormal = my_nonnormal,
                showAllLevels = FALSE, 
                printToggle = FALSE, 
                noSpaces = TRUE)

#Tidy the table1
table1 <- broom::tidy(table1) 

#Export to excel
write.xlsx(table1, "C:/Rcourse/table1.xlsx")
