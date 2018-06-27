rm(list=ls())

# prelim, include=FALSE}
source("MDI.Scripts/Code/load.R.packages.R")

# 0_data}
load("MDI.Scripts/Datos.Modelo/mdi_variables_modelo.RData")
load("MDI.Scripts/Datos.Modelo/mdi_segmentacion.RData")
ls()

str(hogares_agr)

# 0_lb_lbm}
lb_lbm <- read.csv("MDI.Scripts/Datos.Modelo/coneval_lineas_bienestar.csv", header=TRUE)
colnames(lb_lbm)
dim(lb_lbm)

# 0_lb_lbm_sel}
anio_sel <- 2016
mes_sel <- "Jul"

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

lbm.table <- as.data.frame(array(c(lb_rur,lb_urb,lbm_rur,lbm_urb),dim=c(2,2)))
rownames(lbm.table) <- c("rural","urbano") 
colnames(lbm.table) <- c("lb","lbm") 
lbm.table

## Rural

# 1_cuantiles_rur}
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

write.csv(modelo_seg_rur_tab,file="MDI.Scripts/Datos.Modelo/Tablas/modelo_seg_rur_tab.csv")

## Urbano

# 1_cuantiles_urb}
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

write.csv(modelo_seg_urb_tab,file="MDI.Scripts/Datos.Modelo/Tablas/modelo_seg_urb_tab.csv")

### Formula del MDI

#Definimos la formula del modelo **MDI**

# formula_mdi}
mdi.formula <- ictpc~1+depdemog+muj12a49+tot_per+
  p_esc3+p_esc5b+
  trab_sub+trab_ind+trab_s_pago+
  seg_alim2+seg_alim3+seg_alim_a+
  seg_pop+ss+jtrab_ind+ssjtrabind+
  con_remesas+viv_prop+viv_rent+
  tot_cuar+bao13+
  piso_fir+piso_rec+
  combustible+
  sin_refri+sin_vehi+sin_compu+
  sin_vidvd+sin_telef+sin_horno

# MCMC draw samples
M.sim <- 15
M.burn <- 1
M.thin <- 1

### Rural

# Modelos de regresion para **LB** y **LBM**

# 2_qr_lm_rur}
## Linea de bienestar y bienestar minimo
modelo_qr_bnp_rur_lb <- list()    # Modelo cuantilico escalar BNP con LB
modelo_qr_bnp_rur_lbm <- list()   # Modelo cuantilico escalar BNP con LBM

# Tipos de variables
hogares_agr_rur[,var_enighcuis_reg_num] <- lapply(hogares_agr_rur[,var_enighcuis_reg_num],
                                                  as.numeric)
hogares_agr_rur[,var_enighcuis_reg_cat] <- lapply(hogares_agr_rur[,var_enighcuis_reg_cat],
                                                  as.numeric)

str(hogares_agr_rur)

# Modelo Segmentado Rural
j <- 1
for(j in 1:J_rur){
  print(j)
  data_aux <- hogares_agr_rur[which(hogares_agr_rur$finalMemb_rur == 
                                      modelo_seg_rur_tab[j,"segment_rur"]), ]
  #is.data.frame(data_aux)
  data_aux[,var_enighcuis_reg_num] <- lapply(data_aux[,var_enighcuis_reg_num],
                                             as.numeric)
  data_aux[,var_enighcuis_reg_cat] <- lapply(data_aux[,var_enighcuis_reg_cat],
                                             as.numeric)
  #str(data_aux)

  # QR BNP - LB
  modelo_qr_bnp_rur_lb[[j]] <-
    GPDPQuantReg(mdi.formula, 
                dat=data_aux,
                p=modelo_seg_rur_tab[j,"q_rur_lb"],
                mcit=M.sim, 
                burn=M.burn, 
                thin=M.thin)
  summary( modelo_qr_bnp_rur_lb[[j]] )
  

  # QR - LBM
  modelo_qr_bnp_rur_lbm[[j]] <-
    GPDPQuantReg(mdi.formula, 
                 dat=data_aux,
                 p=modelo_seg_rur_tab[j,"q_rur_lbm"],
                 mcit=M.sim, 
                 burn=M.burn, 
                 thin=M.thin)
  summary( modelo_qr_bnp_rur_lbm[[j]] )
}

# ## Urbano

# Modelos de regresion para LB y LBM

# 2_qr_lm_urb}
## Linea de bienestar y bienestar minimo
modelo_qr_bnp_urb_lb <- list()    # Modelo cuantilico escalar BNP con LB
modelo_qr_bnp_urb_lbm <- list()   # Modelo cuantilico escalar BNP con LBM

# Tipos de variables
hogares_agr_urb[,var_enighcuis_reg_num] <- lapply(hogares_agr_urb[,var_enighcuis_reg_num],
                                                  as.numeric)
hogares_agr_urb[,var_enighcuis_reg_cat] <- lapply(hogares_agr_urb[,var_enighcuis_reg_cat],
                                                  as.numeric)

j <- 1
for(j in 1:J_urb){
  print(j)
  data_aux <- hogares_agr_urb[which(hogares_agr_urb$finalMemb_urb == 
                                      modelo_seg_urb_tab[j,"segment_urb"]),]
  #  is.data.frame(data_aux)
  data_aux[,var_enighcuis_reg_num] <- lapply(data_aux[,var_enighcuis_reg_num],
                                             as.numeric)
  data_aux[,var_enighcuis_reg_cat] <- lapply(data_aux[,var_enighcuis_reg_cat],
                                             factor)
  # str(data_aux)

  # QR BNP - LB
  modelo_qr_bnp_urb_lb[[j]] <-
    GPDPQuantReg(mdi.formula, 
                 dat=data_aux,
                 p=modelo_seg_urb_tab[j,"q_urb_lb"],
                 mcit=M.sim, 
                 burn=M.burn, 
                 thin=M.thin)
  summary( modelo_qr_bnp_urb_lb[[j]] )
  
  # QR - LBM
  modelo_qr_bnp_urb_lbm[[j]] <-
    GPDPQuantReg(mdi.formula, 
                 dat=data_aux,
                 p=modelo_seg_urb_tab[j,"q_urb_lbm"],
                 mcit=M.sim, 
                 burn=M.burn, 
                 thin=M.thin)
  summary( modelo_qr_bnp_urb_lbm[[j]] )
}

# Exportacion

# exportacion}
save(hogares_agr_rur,hogares_agr_urb,
     var_enighcuis_num,var_enighcuis_cat,
     var_enighcuis_seg_num,var_enighcuis_seg_cat,
     var_enighcuis_reg_num,var_enighcuis_reg_cat,
     modelo_qr_bnp_rur_lb,modelo_qr_bnp_rur_lbm,
     modelo_qr_bnp_urb_lb,modelo_qr_bnp_urb_lbm,
     file = "MDI.Scripts/Datos.Modelo/mdi_regresion_bnp.RData")
ls()
gc()
