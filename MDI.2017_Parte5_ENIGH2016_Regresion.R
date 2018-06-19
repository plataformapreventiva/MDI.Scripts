rm(list=ls())

#prelim, include=FALSE}
source("./Code/load.R.packages.R")

#0_data}
load('./Datos.Modelo/modelo_segmentacion.RData')

## Lineas de bienestar

# 0_lb_lbm}
lb_lbm <- read.csv("./Datos.Modelo/coneval_lineas_bienestar.csv", header=TRUE)
colnames(lb_lbm)
dim(lb_lbm)

#0_lb_lbm_sel}
anio_sel <- 2017
mes_sel <- "Jun"

# Lineas de bienestar
lb_rur <- lb_lbm[which(lb_lbm$anio==anio_sel &
                         lb_lbm$mes==mes_sel ), "lb.rural"]
lb_urb <- lb_lbm[which(lb_lbm$anio==anio_sel &
                         lb_lbm$mes==mes_sel ), "lb.urbano"]

# Lineas de bienestar minimo
lbm_rur <- lb_lbm[which(lb_lbm$anio==anio_sel &
                          lb_lbm$mes==mes_sel ), "lbm.rural"]
lbm_urb <- lb_lbm[which(lb_lbm$anio==anio_sel &
                          lb_lbm$mes==mes_sel ), "lbm.urbano"]

lb_rur; lb_urb
lbm_rur; lbm_urb

## Parte I - Cuantificacion de cuantiles por segmento  

## Rural

#1_cuantiles_rur}
modelo_seg_rur_tab <- table(modelo_seg_rur$finalMemb)
modelo_seg_rur_tab <- as.data.frame(modelo_seg_rur_tab)
modelo_seg_rur_tab$q_rur_lb <- NA
modelo_seg_rur_tab$q_rur_lbm <- NA
colnames(modelo_seg_rur_tab) <- c("segment_rur","frec_rur","q_rur_lb","q_rur_lbm") 

J_rur <- nrow(modelo_seg_rur_tab)
J_rur

j <- 1
for(j in 1:J_rur){
  ictpc_aux <- as.data.frame(
    as.numeric(
      hogares_agr_rur[which(hogares_agr_rur$finalMemb_rur==modelo_seg_rur_tab[j,"segment_rur"]),
                      "ictpc"]
    )
  )
  N_aux <- nrow(ictpc_aux)
  modelo_seg_rur_tab[j,"q_rur_lb"] <- sum(ictpc_aux<=lb_rur)/N_aux
  modelo_seg_rur_tab[j,"q_rur_lbm"] <- sum(ictpc_aux<=lbm_rur)/N_aux
}

modelo_seg_rur_tab

write.csv(modelo_seg_rur_tab,file="./Datos.Modelo/modelo_seg_rur_tab.csv")

## Urbano

#1_cuantiles_urb}
modelo_seg_urb_tab <- table(modelo_seg_urb$finalMemb)
modelo_seg_urb_tab <- as.data.frame(modelo_seg_urb_tab)
modelo_seg_urb_tab$q_urb_lb <- NA
modelo_seg_urb_tab$q_urb_lbm <- NA
colnames(modelo_seg_urb_tab) <- c("segment_urb","frec_urb","q_urb_lb","q_urb_lbm") 
modelo_seg_urb_tab

J_urb <- nrow(modelo_seg_urb_tab)
J_urb

j <- 1
for(j in 1:J_urb){
  ictpc_aux <- as.data.frame(
    as.numeric(
      hogares_agr_urb[which(hogares_agr_urb$finalMemb_urb==modelo_seg_urb_tab[j,"segment_urb"]),
                      "ictpc"]
    )
  )
  N_aux <- nrow(ictpc_aux)
  modelo_seg_urb_tab[j,"q_urb_lb"] <- sum(ictpc_aux<=lb_urb)/N_aux
  modelo_seg_urb_tab[j,"q_urb_lbm"] <- sum(ictpc_aux<=lbm_urb)/N_aux
}

modelo_seg_urb_tab

write.csv(modelo_seg_urb_tab,file="./Datos.Modelo/modelo_seg_urb_tab.csv")

# Parte II - Estimacion del modelo de regresion cuantilica

## Variables del modelo MUM

#2_variables_mum}
var_mum <- c(var_enighcuis_num,var_enighcuis_cat)

## Rural

#### Linea de bienestar y bienestar minimo

#2_qr_lm_rur}
## Linea de bienestar y bienestar minimo

modelo_qr_rur_lb <- list()
modelo_lm_rur <- list()
modelo_qr_rur_lbm <- list()

modelo_actual_rur <- lm( ictpc~depdemog+muj12a49+ltot_per+
                           p_esc3+p_esc5b+
                           trab_sub+trab_ind+trab_s_pago+
                           seg_alim2+seg_alim3+seg_alim_a+
                           seg_pop+ss+jtrab_ind+ssjtrabind+
                           con_remesas+viv_prop+viv_rent+
                           tot_cuar+bao13+
                           piso_fir+piso_rec+
                           combustible+
                           sin_refri+sin_vehi+sin_compu+
                           sin_vidvd+sin_telef+sin_horno, 
                         dat=hogares_agr_rur)

j <- 1
for(j in 1:J_rur){
  data_aux <- hogares_agr_rur[which(hogares_agr_rur$finalMemb_rur==modelo_seg_rur_tab[j,"segment_rur"]),]
  #                           c("ictpc","finalMemb_rur",var_mum)] 
  dim(data_aux)
  colnames(data_aux)
  modelo_qr_rur_lb[[j]] <-
    bayesQR(ictpc~depdemog+muj12a49+ltot_per+
              p_esc3+p_esc5b+
              trab_sub+trab_ind+trab_s_pago+
              seg_alim2+seg_alim3+seg_alim_a+
              seg_pop+ss+jtrab_ind+ssjtrabind+
              con_remesas+viv_prop+viv_rent+
              tot_cuar+bao13+
              piso_fir+piso_rec+
              combustible+
              sin_refri+sin_vehi+sin_compu+
              sin_vidvd+sin_telef+sin_horno, 
            dat=data_aux,
            quantile=modelo_seg_rur_tab[j,"q_rur_lb"],
            alasso=TRUE, 
            ndraw=500)
  modelo_lm_rur[[j]] <-
    lm( ictpc~depdemog+muj12a49+ltot_per+
          p_esc3+p_esc5b+
          trab_sub+trab_ind+trab_s_pago+
          seg_alim2+seg_alim3+seg_alim_a+
          seg_pop+ss+jtrab_ind+ssjtrabind+
          con_remesas+viv_prop+viv_rent+
          tot_cuar+bao13+
          piso_fir+piso_rec+
          combustible+
          sin_refri+sin_vehi+sin_compu+
          sin_vidvd+sin_telef+sin_horno, 
        dat=data_aux)
  modelo_qr_rur_lbm[[j]] <-
    bayesQR(ictpc~depdemog+muj12a49+ltot_per+
              p_esc3+p_esc5b+
              trab_sub+trab_ind+trab_s_pago+
              seg_alim2+seg_alim3+seg_alim_a+
              seg_pop+ss+jtrab_ind+ssjtrabind+
              con_remesas+viv_prop+viv_rent+
              tot_cuar+bao13+
              piso_fir+piso_rec+
              combustible+
              sin_refri+sin_vehi+sin_compu+
              sin_vidvd+sin_telef+sin_horno, 
            dat=data_aux,
            quantile=modelo_seg_rur_tab[j,"q_rur_lbm"],
            alasso=TRUE, 
            ndraw=500)
}

## Urbano

#### Linea de bienestar y bienestar minimo

#2_qr_lm_urb}
modelo_qr_urb_lb <- list()
modelo_lm_urb <- list()
modelo_qr_urb_lbm <- list()

modelo_actual_urb <- lm( ictpc~depdemog+muj12a49+ltot_per+
                           p_esc3+p_esc5b+
                           trab_sub+trab_ind+trab_s_pago+
                           seg_alim2+seg_alim3+seg_alim_a+
                           seg_pop+ss+jtrab_ind+ssjtrabind+
                           con_remesas+viv_prop+viv_rent+
                           tot_cuar+bao13+
                           piso_fir+piso_rec+
                           combustible+
                           sin_refri+sin_vehi+sin_compu+
                           sin_vidvd+sin_telef+sin_horno, 
                         dat=hogares_agr_urb)

j <- 1
for(j in 1:J_urb){
  print(j)
  data_aux <- hogares_agr_urb[which(hogares_agr_urb$finalMemb_urb==modelo_seg_urb_tab[j,"segment_urb"]),]
  #                              c("ictpc","finalMemb_urb",var_mum)] 
  dim(data_aux)
  colnames(data_aux)
  modelo_qr_urb_lb[[j]] <-
    bayesQR(ictpc~depdemog+muj12a49+ltot_per+
              p_esc3+p_esc5b+
              trab_sub+trab_ind+trab_s_pago+
              seg_alim2+seg_alim3+seg_alim_a+
              seg_pop+ss+jtrab_ind+ssjtrabind+
              con_remesas+viv_prop+viv_rent+
              tot_cuar+bao13+
              piso_fir+piso_rec+
              combustible+
              sin_refri+sin_vehi+sin_compu+
              sin_vidvd+sin_telef+sin_horno, 
            dat=data_aux,
            quantile=modelo_seg_urb_tab[j,"q_urb_lb"],
            alasso=TRUE, 
            ndraw=500)
  modelo_lm_urb[[j]] <-
    lm( ictpc~depdemog+muj12a49+ltot_per+
          p_esc3+p_esc5b+
          trab_sub+trab_ind+trab_s_pago+
          seg_alim2+seg_alim3+seg_alim_a+
          seg_pop+ss+jtrab_ind+ssjtrabind+
          con_remesas+viv_prop+viv_rent+
          tot_cuar+bao13+
          piso_fir+piso_rec+
          combustible+
          sin_refri+sin_vehi+sin_compu+
          sin_vidvd+sin_telef+sin_horno, 
        dat=data_aux)
  modelo_qr_urb_lbm[[j]] <-
    bayesQR(ictpc~depdemog+muj12a49+ltot_per+
              p_esc3+p_esc5b+
              trab_sub+trab_ind+trab_s_pago+
              seg_alim2+seg_alim3+seg_alim_a+
              seg_pop+ss+jtrab_ind+ssjtrabind+
              con_remesas+viv_prop+viv_rent+
              tot_cuar+bao13+
              piso_fir+piso_rec+
              combustible+
              sin_refri+sin_vehi+sin_compu+
              sin_vidvd+sin_telef+sin_horno, 
            dat=data_aux,
            quantile=modelo_seg_urb_tab[j,"q_urb_lbm"],
            alasso=TRUE, 
            ndraw=500)
}

# Exportacion

#exportacion}
save(modelo_actual_rur,modelo_actual_urb,
     modelo_seg_rur,modelo_seg_urb,
     modelo_seg_rur_tab,modelo_seg_urb_tab,
     hogares_agr_rur,hogares_agr_urb,
     var_mum,var_enighcuis_num,var_enighcuis_cat,
     modelo_qr_rur_lb,modelo_qr_rur_lbm,
     modelo_lm_rur,
     modelo_qr_urb_lb,modelo_qr_urb_lbm,
     modelo_lm_urb,
     lb_rur,lb_urb,
     lbm_rur,lbm_urb,
     file = "./Datos.Modelo/modelos_regresion.RData")
ls()
gc()
