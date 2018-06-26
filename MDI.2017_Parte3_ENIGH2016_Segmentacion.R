rm(list=ls())

source("MDI.Scripts/Code/load.R.packages.R")
load("MDI.Scripts/Datos.Modelo/mdi_variables_modelo.RData")

#0_datos}
hogares_agr <- read.csv("MDI.Scripts/Datos.Aux/hogares_enigh_agr.csv", header=TRUE)
colnames(hogares_agr)
dim(hogares_agr)

## Variables ENIGH-CUIS

# 1_variables}
# Numeric
hogares_agr[,var_enighcuis_num] <- lapply(hogares_agr[,var_enighcuis_num],
                                          as.numeric)

summary(hogares_agr[,var_enighcuis_num])

# Categoric
hogares_agr[,var_enighcuis_cat] <- lapply(hogares_agr[,var_enighcuis_cat],
                                          factor)
summary(hogares_agr[,var_enighcuis_cat])

hogares_agr <- as.data.frame(hogares_agr)

table(hogares_agr[,c("rururb","tam_loc")])
table(hogares_agr$rururb)

## Parte I - Segmentacion Rural

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
                         numClust=5,
                         numInit=10)

summary(modelo_seg_rur)
table(modelo_seg_rur$finalMemb)

# rur_segmento}
hogares_agr_rur <- hogares_agr[which(hogares_agr$rururb==1),]
dim(hogares_agr_rur)

finalMemb_rur <- as.data.frame(modelo_seg_rur$finalMemb)
dim(finalMemb_rur)
colnames(finalMemb_rur) <- c("finalMemb_rur") 

hogares_agr_rur <- cbind(hogares_agr_rur,finalMemb_rur)
colnames(hogares_agr_rur)  

100 * table(hogares_agr_rur$finalMemb_rur) / 
  sum(table(hogares_agr_rur$finalMemb_rur))

write.csv(hogares_agr_rur,file="MDI.Scripts/Datos.Modelo/Tablas/hogares_agr_rur.csv")

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
                         numClust=5,
                         numInit=10,
                         verbose=TRUE)

summary(modelo_seg_urb)
table(modelo_seg_urb$finalMemb)

# urbano_segmentacion}
hogares_agr_urb <- hogares_agr[which(hogares_agr$rururb==0),]
dim(hogares_agr_urb)

finalMemb_urb <- as.data.frame(modelo_seg_urb$finalMemb)
dim(finalMemb_urb)
colnames(finalMemb_urb) <- c("finalMemb_urb") 

hogares_agr_urb <- cbind(hogares_agr_urb,finalMemb_urb)
colnames(hogares_agr_urb)

100 * table(hogares_agr_urb$finalMemb_urb) / 
  sum(table(hogares_agr_urb$finalMemb_urb))

write.csv(hogares_agr_urb,file="MDI.Scripts/Datos.Modelo/Tablas/hogares_agr_urb.csv")

# exportacion}
save( finalMemb_rur,finalMemb_urb,
      hogares_agr,
      hogares_agr_rur,hogares_agr_urb,
      hogares_rur_cat,hogares_rur_num,
      hogares_urb_cat,hogares_urb_num,
      modelo_seg_rur,modelo_seg_urb,
      var_enighcuis_cat,var_enighcuis_num,
      var_enighcuis_reg_cat,var_enighcuis_reg_num,
      var_enighcuis_seg_cat,var_enighcuis_seg_num,
      file = "MDI.Scripts/Datos.Modelo/mdi_segmentacion.RData")
ls()
gc()