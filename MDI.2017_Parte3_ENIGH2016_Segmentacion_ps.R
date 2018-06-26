
rm(list=ls())

# 0_prelim}
source("MDI.Scripts/Code/load.R.packages.R")
load("MDI.Scripts/Datos.Modelo/mdi_variables_modelo.RData")

# 0_datos}
hogares_agr <- read.csv("Bases.Enigh/hogares_enigh_agr.csv", header=TRUE)
colnames(hogares_agr)
dim(hogares_agr)

# 0_ict include=FALSE}
plot(hogares_agr[,c("ing_cor","ict")])
cor(hogares_agr[,c("ing_cor","ict")])

# 1_variables}
# Numeric
hogares_agr[,var_enighcuis_num] <- lapply(hogares_agr[,var_enighcuis_num],
                                          as.numeric)

# Categoric
hogares_agr[,var_enighcuis_cat] <- lapply(hogares_agr[,var_enighcuis_cat],
                                          as.numeric)

hogares_agr <- as.data.frame(hogares_agr)

table(hogares_agr[,c("rururb","tam_loc")])
table(hogares_agr$rururb)

# Parte I - Segmentacion Rural

# 1_segmentacion_rural}
# Numerical
hogares_rur_num <- hogares_agr[which(hogares_agr$rururb==1),
                               var_enighcuis_seg_num]
hogares_rur_num <- lapply(hogares_rur_num,as.numeric)
hogares_rur_num <- as.data.frame(hogares_rur_num)

# Categorical
hogares_rur_cat <- hogares_agr[which(hogares_agr$rururb==1),
                               var_enighcuis_seg_cat]
hogares_rur_cat <- lapply(hogares_rur_cat,factor)
hogares_rur_cat <- as.data.frame(hogares_rur_cat)

# Segmentacion rural
modelo_seg_rur <- kamila(hogares_rur_num, 
                         hogares_rur_cat,
                         numClust=3:20,
                         numInit=10,
                         maxIter=25,
                         calcNumClust="ps",
                         verbose=TRUE)

summary(modelo_seg_rur)
table(modelo_seg_rur$finalMemb)


# Parte II - Segmentacion Urbano

# 1_segmentacion_urbana}
# Numerical
hogares_urb_num <- hogares_agr[which(hogares_agr$rururb==0), 
                               var_enighcuis_seg_num]
hogares_urb_num <- lapply(hogares_urb_num,as.numeric)
hogares_urb_num <- as.data.frame(hogares_urb_num)

# Categorical
hogares_urb_cat <- hogares_agr[which(hogares_agr$rururb==0), 
                               var_enighcuis_seg_cat]
hogares_urb_cat <- lapply(hogares_urb_cat,factor)
hogares_urb_cat <- as.data.frame(hogares_urb_cat)

# Segmentacion urbano
modelo_seg_urb <- kamila(hogares_urb_num, 
                         hogares_urb_cat,
                         numClust=3:20,
                         numInit=10,
                         maxIter=25,
                         calcNumClust="ps",
                         verbose=TRUE)

summary(modelo_seg_urb)
table(modelo_seg_urb$finalMemb)

# exportacion}
save(hogares_agr, hogares_rur_cat, hogares_rur_num,
     hogares_urb_cat, hogares_urb_num, modelo_seg_rur,
     modelo_seg_urb, var_enighcuis_cat, var_enighcuis_num,
     var_enighcuis_reg_cat, var_enighcuis_reg_num, 
     var_enighcuis_seg_cat, var_enighcuis_seg_num,
     file = "MDI.Scripts/Datos.Modelo/mdi_segmentacion_ps_4.RData")
ls()
gc()
