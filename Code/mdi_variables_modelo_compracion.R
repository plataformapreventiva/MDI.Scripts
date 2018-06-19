rm(list=ls())

load("../Datos.Modelo/mdi_variables_modelo.RData")

# CUIS
hogares_cuis_agr <- read.csv("../Bases.Cuis/hogares_cuis_agr.csv", 
                             header=TRUE)
head(hogares_cuis_agr)


# ENIGH
hogares_enigh_agr <- read.csv("../Bases.Enigh/hogares_enigh_agr.csv", 
                             header=TRUE)
head(hogares_enigh_agr)

# Numericas y Categoricas

hogares_cuis_agr[,var_enighcuis_num] <- lapply(hogares_cuis_agr[,var_enighcuis_num],as.numeric)
hogares_cuis_agr[,var_enighcuis_cat] <- lapply(hogares_cuis_agr[,var_enighcuis_cat],factor)

hogares_enigh_agr[,var_enighcuis_num] <- lapply(hogares_enigh_agr[,var_enighcuis_num],as.numeric)
hogares_enigh_agr[,var_enighcuis_cat] <- lapply(hogares_enigh_agr[,var_enighcuis_cat],factor)

# Comparacion

summary(hogares_cuis_agr)

summary(hogares_enigh_agr)
