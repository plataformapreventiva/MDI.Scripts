rm(list=ls())

source("./Code/load.R.packages.R")

#0_datos}
hogares_agr <- read.csv("../Bases.Enigh/2016_a_hogares_enigh.csv", header=TRUE)
colnames(hogares_agr)
dim(hogares_agr)

## Variables ENIGH-CUIS

#1_variables}
# Tipo Numerico
var_enighcuis_num <- c("int0a12","int12a64","int65a98",
                       "depdemog","muj12a49","tot_per",
                       "tot_cuar")

# Tipo Categorico
var_enighcuis_cat <- c("p_esc3","p_esc5b",
                       "trab_sub","trab_ind","trab_s_pago",
                       "seg_alim2","seg_alim3","seg_alim_a",
                       "seg_pop","ss","jtrab_ind",
                       "ssjtrabind","con_remesas",
                       "viv_prop","viv_rent",
                       "bao13",
                       "piso_fir","piso_rec",
                       "combustible","sin_refri",
                       "sin_vehi","sin_compu","sin_vidvd",
                       "sin_telef","sin_horno")
hogares_agr[,c("p_esc3")] <- as.factor(hogares_agr[,c("p_esc3")])
hogares_agr[,c("p_esc5b")] <- as.factor(hogares_agr[,c("p_esc5b")])
hogares_agr[,c("trab_sub")] <- as.factor(hogares_agr[,c("trab_sub")])
hogares_agr[,c("trab_ind")] <- as.factor(hogares_agr[,c("trab_ind")])
hogares_agr[,c("trab_s_pago")] <- as.factor(hogares_agr[,c("trab_s_pago")])
hogares_agr[,c("seg_alim3")] <- as.factor(hogares_agr[,c("seg_alim3")])
hogares_agr[,c("seg_alim_a")] <- as.factor(hogares_agr[,c("seg_alim_a")])
hogares_agr[,c("seg_pop")] <- as.factor(hogares_agr[,c("seg_pop")])
hogares_agr[,c("ss")] <- as.factor(hogares_agr[,c("ss")])
hogares_agr[,c("jtrab_ind")] <- as.factor(hogares_agr[,c("jtrab_ind")])
hogares_agr[,c("ssjtrabind")] <- as.factor(hogares_agr[,c("ssjtrabind")])
hogares_agr[,c("con_remesas")] <- as.factor(hogares_agr[,c("con_remesas")])
hogares_agr[,c("viv_prop")] <- as.factor(hogares_agr[,c("viv_prop")])
hogares_agr[,c("viv_rent")] <- as.factor(hogares_agr[,c("viv_rent")])
hogares_agr[,c("bao13")] <- as.factor(hogares_agr[,c("bao13")])
hogares_agr[,c("piso_fir")] <- as.factor(hogares_agr[,c("piso_fir")])
hogares_agr[,c("piso_rec")] <- as.factor(hogares_agr[,c("piso_rec")])
hogares_agr[,c("combustible")] <- as.factor(hogares_agr[,c("combustible")])
hogares_agr[,c("sin_refri")] <- as.factor(hogares_agr[,c("sin_refri")])
hogares_agr[,c("sin_vehi")] <- as.factor(hogares_agr[,c("sin_vehi")])
hogares_agr[,c("sin_compu")] <- as.factor(hogares_agr[,c("sin_compu")])
hogares_agr[,c("sin_vidvd")] <- as.factor(hogares_agr[,c("sin_vidvd")])
hogares_agr[,c("sin_telef")] <- as.factor(hogares_agr[,c("sin_telef")])
hogares_agr[,c("sin_horno")] <- as.factor(hogares_agr[,c("sin_horno")])

hogares_agr <- as.data.frame(hogares_agr)

table(hogares_agr[,c("rururb","tam_loc")])
table(hogares_agr$rururb)

## Parte I - Segmentacion Rural

#1_segmentacion_rural}
# Numerical
hogares_rur_num <- hogares_agr[which(hogares_agr$rururb==1), var_enighcuis_num]
hogares_rur_num <- as.data.frame(hogares_rur_num)
dim(hogares_rur_num)
colnames(hogares_rur_num) <- var_enighcuis_num

# Categorical
hogares_rur_cat <- hogares_agr[which(hogares_agr$rururb==1), 
                               c("p_esc3","p_esc5b","trab_sub","trab_ind")]
hogares_rur_cat <- as.data.frame(hogares_rur_cat)
dim(hogares_rur_cat)
colnames(hogares_rur_cat) <- c("p_esc3","p_esc5b","trab_sub","trab_ind")

# Segmentacion rural

modelo_seg_rur <- kamila(hogares_rur_num, 
                         hogares_rur_cat, 
                         #numClust=6:10, 
                         numClust=9,
                         numInit=10,
                         verbose=TRUE)

summary(modelo_seg_rur)
table(modelo_seg_rur$finalMemb)

#rur_segmento}
hogares_agr_rur <- hogares_agr[which(hogares_agr$rururb==1),]
dim(hogares_agr_rur)

finalMemb_rur <- as.data.frame(modelo_seg_rur$finalMemb)
dim(finalMemb_rur)
colnames(finalMemb_rur) <- c("finalMemb_rur") 

hogares_agr_rur <- cbind(hogares_agr_rur,finalMemb_rur)
colnames(hogares_agr_rur)  

100 * table(hogares_agr_rur$finalMemb_rur) / 
  sum(table(hogares_agr_rur$finalMemb_rur))

write.csv(hogares_agr_rur,file="../Datos.Modelo/hogares_agr_rur.csv")

# Parte II - Segmentacion Urbano

#1_segmentacion_urbana}
# Numerical
hogares_urb_num <- hogares_agr[which(hogares_agr$rururb==0), var_enighcuis_num]
hogares_urb_num <- as.data.frame(hogares_urb_num)
dim(hogares_urb_num)
colnames(hogares_urb_num) <- var_enighcuis_num

# Categorical
hogares_urb_cat <- hogares_agr[which(hogares_agr$rururb==0), 
                               c("p_esc3","p_esc5b","trab_sub","trab_ind")]
hogares_urb_cat <- as.data.frame(hogares_urb_cat)
dim(hogares_urb_cat)
colnames(hogares_urb_cat) <- c("p_esc3","p_esc5b","trab_sub","trab_ind")

# Segmentacion urbano

modelo_seg_urb <- kamila(hogares_urb_num, 
                         hogares_urb_cat, 
                         #numClust=6:10, 
                         numClust=7,
                         numInit=10,
                         verbose=TRUE)

summary(modelo_seg_urb)
table(modelo_seg_urb$finalMemb)
modelo_seg_urb$verbose

## Unimos los clasificaciones

#urbano_segmentacion}
hogares_agr_urb <- hogares_agr[which(hogares_agr$rururb==0),]
dim(hogares_agr_urb)

finalMemb_urb <- as.data.frame(modelo_seg_urb$finalMemb)
dim(finalMemb_urb)
colnames(finalMemb_urb) <- c("finalMemb_urb") 

hogares_agr_urb <- cbind(hogares_agr_urb,finalMemb_urb)
colnames(hogares_agr_urb)

100 * table(hogares_agr_urb$finalMemb_urb) / 
  sum(table(hogares_agr_urb$finalMemb_urb))

write.csv(hogares_agr_urb,file="../Datos.Modelo/hogares_agr_urb.csv")

## Exportacion

#exportacion}
save(modelo_seg_rur,
     hogares_agr_rur,
     modelo_seg_urb, 
     hogares_agr_urb,
     var_enighcuis_num,
     var_enighcuis_cat,
     file = "../Datos.Modelo/modelo_segmentacion.RData")
