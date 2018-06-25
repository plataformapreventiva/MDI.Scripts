#!/usr/bin/env Rscript
# mid.pred_demo.R
library(parallel)
library(readr)
library(optparse)
library(purrr)
options(scipen=999)

# Packages
if(!require('kamila')){install.packages("Code/R.Packages/kamila_0.1.1.2.zip",
                                        repos = NULL, type="source")}
suppressMessages(library("kamila"))
if(!require('bayesQR')){install.packages("Code/R.Packages/bayesQR_2.3.zip",
                                         repos = NULL, type="source")}
suppressMessages(library("bayesQR"))
if(!require('monomvn')){install.packages("Code/R.Packages/monomvn_1.9-7.zip",
                                         repos = NULL, type="source")}
suppressMessages(library("monomvn"))

# Codigo
source("Code/dald.R")
source("Code/rald.R")
source("Code/raldm.R")
source("Code/pregald.R")
source("Code/pred.blasso.mdi.R")
source("Code/pred.bayesQR.mdi.R")
source("Code/mdi.pred.R")
load("Datos.Modelo/mdi_variables_modelo.RData")
load('Datos.Modelo/mdi_segmentacion.RData')
load('Datos.Modelo/mdi_regresion.RData')

option_list = list(
  make_option(c("--filename"), type="character", default="",
              help="file name", metavar="character"))

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

#opt <- tryCatch(
#  {
#    parse_args(opt_parser)
#  },
#  error=function(cond) {
#    message("Error: Provide file correctly.")
#    message(cond)
#    print_help(opt_parser)
#    return(NA)
#  },
#  warning=function(cond) {
#    message("Warning:")
#    message(cond)
#    return(NULL)
#  },
#  finally={
#    message("Finished attempting to parse arguments.")
#  }
#)


run_batch_prediction <- function(filename){

    ## first
    #k_i <- k * k_tasa + 1
    #if (k_i + k_tasa - 1 <= max_llaves){
    #  k_f <- k_i + k_tasa - 1
    #}else{
    #  k_f <- max_llaves
    #}

    input_filename = paste0('Bases.Cuis/', filename)
    # Datos CUIS
    hogares_cuis_agr <- read.csv(input_filename, sep='|', header=TRUE)
    hogares_cuis_agr$ENTIDAD <- hogares_cuis_agr$cve_entidad_federativa
    hogares_cuis_agr$MUN <- hogares_cuis_agr$cve_municipio - 1000*hogares_cuis_agr$ENTIDAD
    hogares_cuis_agr$LOC <- hogares_cuis_agr$cve_localidad - 10000000*hogares_cuis_agr$ENTIDAD - 10000*hogares_cuis_agr$MUN

    # Datos modelo
    localidades <- read.csv("Datos.Modelo/inegi_localidades.csv",header=TRUE)
    lineas_bienestar <- read.csv("Datos.Modelo/coneval_lineas_bienestar.csv",header=TRUE)

    hogares_cuis_agr <- as.data.frame(hogares_cuis_agr)
    dim.hog.agr <- dim(hogares_cuis_agr)
    dim.hog.agr

    # Numeric
    hogares_cuis_agr[,var_enighcuis_num] <- lapply(hogares_cuis_agr[,var_enighcuis_num],as.numeric)

    # Categorias
    hogares_cuis_agr[,var_enighcuis_cat] <- lapply(hogares_cuis_agr[,var_enighcuis_cat],factor)

    #summary(hogares_cuis_agr)
    make_prediction <- function(j){
      caso <- as.data.frame(hogares_cuis_agr[j,])
      caso.pred.new <- mdi.pred(caso,localidades,lineas_bienestar,
                                modelo_actual_rur,modelo_actual_urb,
                                modelo_lm_rur,modelo_lm_urb,
                                modelo_qr_rur_lb,modelo_qr_urb_lb,
                                modelo_qr_rur_lbm,modelo_qr_urb_lbm,
                                modelo_seg_rur,modelo_seg_rur_tab,
                                modelo_seg_urb,modelo_seg_urb_tab)
    }

    caso.pred <- 1:100000 %>%
      map_dfr(make_prediction)
    #caso.pred <- do.call(rbind,lapply(1:dim.hog.agr[1], make_prediction))
    output_filename = paste0('Predicciones.Cuis/', filename)
    write.table(hogares_agr, file=output_filename, sep='|', row.names=FALSE)
    print(filename)
    rm(list=ls())
    gc()

}

## read llaves
## llaves_all <- read_csv('../llaves_hogar_sifode.csv')
## parameters
#k_i <- 1
#k_tasa <- 100000
#max_llaves <- 13547848
#max_it <- round((max_llaves / k_tasa), 0)
#
## Calculate the number of cores
#no_cores <- 10
#
## Initiate cluster
#cl <- makeCluster(no_cores)
## run function
#mclapply(0:max_it, run_batch_prediction)
#
#stopCluster(cl)
if(length(opt) > 1){

  if (opt$filename==""){
    print_help(opt_parser)
    stop("Filename not correct", call.=FALSE)
  }else{
    filename <- opt$filename
  }
  run_batch_prediction(filename)

}
