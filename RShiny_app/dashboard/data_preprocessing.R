
#### INSTALLATION AND PACKAGES ####
# cran release
if (!require("dplyr")) {
  install.packages("auk")
  library(auk)
}

if (!require("dplyr")) {  
  install.packages("dplyr")
  library(dplyr)
}



#### CLEANING AND PROCESSING ####

ebd_filtered <- read.csv('/Users/clairehe/Documents/GitHub/auk/RShiny_app/data/preprocessed_2.csv')

# need to clean the state names

state_dict <- sort(unique(ebd_filtered$state))
# problematic states: Provence-Alpes-Cote d'Azur, Bourgogne-Franche-Comte, Auvergne-Rhone-Alpes
