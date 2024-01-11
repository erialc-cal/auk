
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

ebd_filtered <- read.csv('data/preprocessed_1.csv')



