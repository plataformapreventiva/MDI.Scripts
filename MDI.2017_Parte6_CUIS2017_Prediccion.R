# mid.pred_demo.R

rm(list=ls())

# Packages
if(!require('kamila')){install.packages("./Code/R.Packages/kamila_0.1.1.2.zip", 
                                        repos = NULL, type="source")}
suppressMessages(library("kamila"))
if(!require('bayesQR')){install.packages("./Code/R.Packages/bayesQR_2.3.zip", 
                                         repos = NULL, type="source")}
suppressMessages(library("bayesQR"))
if(!require('monomvn')){install.packages("./Code/R.Packages/monomvn_1.9-7.zip", 
                                         repos = NULL, type="source")}
suppressMessages(library("monomvn"))

# Codigo
source("./Code/dald.R")
source("./Code/rald.R")
source("./Code/raldm.R")
source("./Code/pregald.R")
source("./Code/pred.blasso.mdi.R")
source("./Code/pred.bayesQR.mdi.R")
source("./Code/mdi.pred.R")

# Datos CUIS
hogares_cuis_agr <- read.csv("./Bases.Cuis/hogares_cuis_agr.csv",header=TRUE)
colnames(hogares_cuis_agr)
hogares_cuis_agr$ENTIDAD <- hogares_cuis_agr$CVE_ENTIDAD_FEDERATIVA
hogares_cuis_agr$MUN <- hogares_cuis_agr$CVE_MUNICIPIO - 1000*hogares_cuis_agr$ENTIDAD
hogares_cuis_agr$LOC <- hogares_cuis_agr$CVE_LOCALIDAD - 10000000*hogares_cuis_agr$ENTIDAD - 10000*hogares_cuis_agr$MUN

colnames(hogares_cuis_agr)

# Datos modelo
load('./Datos.Modelo/modelo_segmentacion.RData')
load('./Datos.Modelo/modelos_regresion.RData')
localidades <- read.csv("./Datos.Modelo/inegi_localidades.csv",header=TRUE)
lineas_bienestar <- read.csv("./Datos.Modelo/coneval_lineas_bienestar.csv",header=TRUE)

hogares_cuis_agr <- as.data.frame(hogares_cuis_agr)
dim.hog.agr <- dim(hogares_cuis_agr)
dim.hog.agr

# Numeric 
hogares_cuis_agr[,var_enighcuis_num] <- lapply(hogares_cuis_agr[,var_enighcuis_num],as.numeric)

# Categorias
hogares_cuis_agr[,var_enighcuis_cat] <- lapply(hogares_cuis_agr[,var_enighcuis_cat],factor)

#summary(hogares_cuis_agr)

# Caso
j <- 1
caso <- as.data.frame(hogares_cuis_agr[j,])

# Prediccion (un caso a la vez)
caso.pred <- mdi.pred(caso,localidades,lineas_bienestar,
                      modelo_actual_rur,modelo_actual_urb, 
                      modelo_lm_rur,modelo_lm_urb,
                      modelo_qr_rur_lb,modelo_qr_urb_lb, 
                      modelo_qr_rur_lbm,modelo_qr_urb_lbm,
                      modelo_seg_rur,modelo_seg_rur_tab,
                      modelo_seg_urb,modelo_seg_urb_tab)
caso.pred

#
# -----------------------------------------------------------
#

# Iteraciones
j <- 2
for(j in 2:dim.hog.agr[1]){
  print(j)
  # Seleccion del caso
  caso <- as.data.frame(hogares_cuis_agr[j,])
  # Prediccion
  caso.pred.new <- mdi.pred(caso,localidades,lineas_bienestar,
                            modelo_actual_rur,modelo_actual_urb, 
                            modelo_lm_rur,modelo_lm_urb,
                            modelo_qr_rur_lb,modelo_qr_urb_lb, 
                            modelo_qr_rur_lbm,modelo_qr_urb_lbm,
                            modelo_seg_rur,modelo_seg_rur_tab,
                            modelo_seg_urb,modelo_seg_urb_tab)
  # Agrupacion
  caso.pred <- rbind(caso.pred,caso.pred.new)
}

