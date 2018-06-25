#!/usr/bin/env Rscript

rm(list=ls())
options(scipen=999)

### 00_prelim, include=TRUE}
source("Code/load.R.packages.R")
load("Datos.Modelo/mdi_variables_modelo.RData")

library(DBI)
library(dbrsocial)
library(magrittr)
library(readr)
library(dplyr)
library(parallel)
### 01_Importacion
dotenv::load_dot_env("../.env")

run_features <- function(k, k_tasa, con){
    # first
    k_i <- k * k_tasa + 1

    if (k_i + k_tasa - 1 <= max_llaves){
      k_f <- k_i + k_tasa - 1
    }else{
      k_f <- max_llaves
    }

    llaves <- llaves_all %>%  filter(row_number() %in% k_i:k_f)

    # Domicilios
    domicilio_cuis <- large_table(con, raw, cuis_historico_domicilios) %>%
              join_tables(llave_hogar_h, llaves, llave_hogar_h) %>%
              retrieve_result()
    colnames(domicilio_cuis)
    dim(domicilio_cuis)

    # encuesta_cuis
    encuesta_cuis <- large_table(con, raw, cuis_historico_encuesta) %>%
              join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
              retrieve_result()
    colnames(encuesta_cuis)
    dim(encuesta_cuis)

    # integrante_cuis
    integrante_cuis <- large_table(con, raw, cuis_historico_integrante) %>%
        join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
        retrieve_result()
    colnames(integrante_cuis)
    dim(integrante_cuis)

    # persona_cuis_filtrado
    persona_cuis_filtrado <- large_table(con, raw, cuis_historico_persona) %>%
          join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
          retrieve_result()
    colnames(persona_cuis_filtrado)
    dim(persona_cuis_filtrado)

    # se_integrante_cuis SE
    se_integrante_cuis <- large_table(con, raw, cuis_historico_se_integrante) %>%
          join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
          retrieve_result()
    colnames(se_integrante_cuis)
    dim(se_integrante_cuis)

    # se_vivienda_cuis
    se_vivienda_cuis <- large_table(con, raw, cuis_historico_se_vivienda) %>%
          join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
          retrieve_result()
    colnames(se_vivienda_cuis)
    dim(se_vivienda_cuis)

    # vivienda_cuis
    vivienda_cuis <- large_table(con, raw, cuis_historico_vivienda) %>%
      join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
      retrieve_result()
    colnames(vivienda_cuis)
    dim(vivienda_cuis)

    # 6mas1
    personas_6mas1 <- large_table(con, raw, cuis_historico_6mas1) %>%
      join_tables(llave_hogar_h, domicilio_cuis, llave_hogar_h) %>%
      retrieve_result()
    colnames(personas_6mas1)
    dim(personas_6mas1)

    # Personas

    ### 02_Personas_Composicion}
    # Trabajamos con la tabla `integrante_cuis` y `persona_cuis_filtrado`

    personas <- merge( integrante_cuis,
                       persona_cuis_filtrado,
                       by=c("llave_hogar_h", "c_integrante"))
    personas <- merge( personas,
                       personas_6mas1,
                       by=c("llave_hogar_h", "c_integrante"))
    dim(personas)

    # tot_per
    personas$tot_per <- 0
    personas[which( personas$c_con_res==1 |
                      personas$c_con_res==2 |
                      personas$c_con_res==3 |
                      personas$c_con_res==4 ),
                    "tot_per"] <- 1

    table(personas$tot_per)

    # es_jefe
    personas$es_jefe <- 0
    personas[which( personas$c_cd_parentesco==1 ),
                    "es_jefe"] <- 1
    table(personas$es_jefe)

    # es_cony (>= 12)
    personas$es_cony <- 0
    personas[which( personas$c_cd_parentesco==1 &
                      personas$edad>=12 ),
                    "es_cony"] <- 1

    table(personas$es_cony)
    table(personas[,c("es_jefe","es_cony")])

    # int0a12
    personas$int0a12 <- 0
    personas[which( personas$edad>=0 &
                    personas$edad<=12 ),
                    "int0a12"] <- 1

    table(personas$int0a12)

    # int12a64
    personas$int12a64 <- 0
    personas[which( personas$edad>=13 &
                    personas$edad<=64 ),
                    "int12a64"] <- 1

    table(personas$int12a64)

    # int65a98
    personas$int65a98 <- 0
    personas[which( personas$edad>=65 &
                    personas$edad<=98 ),
                    "int65a98"] <- 1

    table(personas$int65a98)

    # muj12a49
    personas$muj12a49 <- 0
    personas[which( personas$c_cd_sexo==2 & ( personas$edad>=13 &
                                              personas$edad<=49 ) ),
                    "muj12a49"] <- 1

    table(personas$muj12a49)

    ### 03_Personas_Escolaridad}
    # Trabajamos con la tabla `personas` y `se_integrante_cuis`

    personas <- merge( personas,
                       se_integrante_cuis,
                       by=c("llave_hogar_h","c_integrante") )
    dim(personas)

    # esc
    personas$esc <- 0
    personas[which( personas$c_ult_nivel>10 & ( personas$c_ult_gra==0 |
                                                personas$c_ult_gra!="NA" ) ),
             "esc"] <- 0
    personas[which( personas$c_ult_nivel==1 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=3 ),
              "esc"] <- 0
    personas[which( personas$c_ult_nivel==2 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=6 ),
             "esc"] <- personas[which( personas$c_ult_nivel==2 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=6 ),
                                "c_ult_gra"]
    personas[which( personas$c_ult_nivel==3 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=3 ),
             "esc"] <- personas[which( personas$c_ult_nivel==3 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=3 ),
                                "c_ult_gra"] + 6
    personas[which( personas$c_ult_nivel==4 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=4 ),
             "esc"] <- personas[which( personas$c_ult_nivel==4 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=4 ),
                                "c_ult_gra"] + 9
    personas[which( personas$c_ult_nivel==5 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=4 ),
             "esc"] <- personas[which( personas$c_ult_nivel==5 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=4 ),
                                "c_ult_gra"] + 9
    personas[which( personas$c_ult_nivel==6 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=4 ),
             "esc"] <- personas[which( personas$c_ult_nivel==6 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=4 ),
                                "c_ult_gra"] + 6
    personas[which( personas$c_ult_nivel==7 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=4 ),
             "esc"] <- personas[which( personas$c_ult_nivel==7 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=4 ),
                                "c_ult_gra"] + 9
    personas[which( personas$c_ult_nivel==8 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=4 ),
             "esc"] <- personas[which( personas$c_ult_nivel==8 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=4 ),
                                "c_ult_gra"] + 12
    personas[which( personas$c_ult_nivel==9 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=6 ),
             "esc"] <- personas[which( personas$c_ult_nivel==9 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=6 ),
                                "c_ult_gra"] + 12
    personas[which( personas$c_ult_nivel==10 & personas$c_ult_gra>=1 &
                      personas$c_ult_gra<=6 ),
             "esc"] <- personas[which( personas$c_ult_nivel==10 & personas$c_ult_gra>=1 &
                                         personas$c_ult_gra<=6 ),
                                "c_ult_gra"] + 16
    personas[which( personas$edad>=0 & personas$edad<1 ),
             "esc"] <- 0
    table(personas$esc)

    ### 04_Personas_Trabajo}
    # Trabajamos con la tabla `personas`

    # tot_ocupo (>=12)
    personas$tot_ocupo <- 0
    personas[ which( personas$edad>=12 & ( personas$c_con_tra>=1 &
                                           personas$c_con_tra<=3 ) ),"tot_ocupo"] <- 1
    personas[ which( personas$edad>=12 & ( personas$c_ver_con_trab>=1 &
                                           personas$c_ver_con_trab<=4 ) ),"tot_ocupo"] <- 1
    personas[ which( personas$edad>=12 & ( personas$c_con_trab>=4 &
                                           personas$c_con_trab<=7 ) &
                                         ( personas$c_ver_con_trab==5 &
                                           personas$c_ver_con_trab==6 ) ),"tot_ocupo"] <- 0
    personas[ which( personas$edad>=0 & personas$edad<12 ),"tot_ocupo"] <- 0
    table(personas$tot_ocupo)

    # trab_sub (>=12)
    personas$trabsub <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==1 &
                       personas$trab_no_re==1 ),"trabsub"] <- 1
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==1 &
                     personas$trab_indep=="NA" & personas$trab_no_re==2 ),"trabsub"] <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==2 &
                       personas$trab_indep==1 ),"trabsub"] <- 0
    personas[ which( personas$tot_ocupo==0 ),"trabsub"] <- 0
    personas[ which( personas$edad>=0 & personas$edad<12 ),"trabsub"] <- 0
    table(personas$trabsub)

    # trab_ind (>=12)
    personas$trabind <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==2 &
                       personas$trab_indep==1 & personas$trab_no_re==1 ),"trabind"] <- 1
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==1 &
                       personas$trab_indep=="NA" ),"trabind"] <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==2 &
                       personas$trab_indep==1 & personas$trab_no_re==2 ),"trabind"] <- 0
    personas[ which( personas$tot_ocupo==0 ),"trabind"] <- 0
    personas[ which( personas$edad>=0 & personas$edad<12 ),"trabind"] <- 0
    table(personas$trabind)

    # trab_s_pago (>=12)
    personas$trab_s_pago <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==2 &
                       personas$trab_indep==2 & personas$trab_no_re==2 ),"trab_s_pago"] <- 1
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==1 &
                       personas$trab_indep=="NA" & personas$trab_no_re==1 ),"trab_s_pago"] <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==1 &
                       personas$trab_indep=="NA" & personas$trab_no_re==2 ),"trab_s_pago"] <- 1
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==2 &
                       personas$trab_indep==1 & personas$trab_no_re==1 ),"trab_s_pago"] <- 0
    personas[ which( personas$tot_ocupo==1 & personas$trab_subor==2 &
                       personas$trab_indep==1 & personas$trab_no_re==2 ),"trab_s_pago"] <- 1
    personas[ which( personas$tot_ocupo==0 ),"trab_s_pago"] <- 0
    personas[ which( personas$edad>=0 & personas$edad<12 ),"trab_s_pago"] <- 0
    table(personas$trab_s_pago)

    # jtrab_ind (>=12)
    personas$jtrab_ind <- 0
    personas[ which( personas$es_jefe==1 ),"jtrab_ind"] <-
      personas[ which( personas$es_jefe==1 ),"trabind"]
    table(personas$jtrab_ind)

    # jubiladof (>=12)
    personas$jubiladof <- 0
    personas[ which( personas$edad>=12 & ( (personas$c_con_tra>=4 & personas$c_con_tra<=7) &
                                           (personas$c_ver_con_tra==5 | personas$c_ver_con_trab==6) ) &
                       (personas$c_raz_no_trab==2) ) ,"jubiladof"] <- 1
    personas[ which( personas$edad>=12 & ( (personas$c_con_tra>=4 & personas$c_con_tra<=7) &
                                           (personas$c_ver_con_tra==5 | personas$c_ver_con_trab==6) ) &
                       (personas$c_raz_no_trab!=2 & personas$c_raz_no_trab!=0) ) ,"jubiladof"] <- 0
    personas[ which( personas$edad>=12 & ( personas$c_con_tra>=1 & personas$c_con_tra<=3) &
                       personas$c_ver_con_trab=="NA" ) ,"jubiladof"] <- 0
    personas[ which( personas$edad>=12 & ( personas$c_con_tra>=4 & personas$c_con_tra<=7) &
                       (personas$c_ver_con_trab>=1 & personas$c_ver_con_trab<=4) ),"jubiladof"] <- 0
    personas[ which( personas$edad>=12 & personas$jubilado==1 ),"jubiladof"] <- 1
    personas[ which( personas$edad>=12 & personas$jubilado==2 ),"jubiladof"] <- 0
    personas[ which( personas$edad>=12 & personas$jubilado=="NA" &
                       (personas$jubilado_1==1 | personas$jubilado_2==1)),"jubiladof"] <- 1
    personas[ which( personas$edad>=12 & personas$jubilado=="NA" &
                       (personas$jubilado_1>=2 | personas$jubilado_2>=2)),"jubiladof"] <- 0
    personas[ which( personas$edad>=0 & personas$edad<12 ),"jubiladof"] <- 0
    table(personas$jubiladof)

    # segsoc1 ()
    personas$segsoc1 <- 0
    personas[which( (personas$c_instsal_a>=2 & personas$c_instsal_a<=5) &
                    (personas$c_afilsal_a >=1 & personas$c_afilsal_a<=3 ) ), "segsoc1"] <- 1
    personas[which( (personas$c_instsal_b>=2 & personas$c_instsal_b<=5) &
                      (personas$c_afilsal_b >=1 & personas$c_afilsal_b<=3 ) ), "segsoc1"] <- 1
    personas[which( ( (personas$c_instsal_a>=1 & personas$c_instsal_a<=5) &
                      (personas$c_afilsal_a>=4 & personas$c_afilsal_a<=9) ) &
                    ( (personas$c_instsal_b>=1 & personas$c_instsal_b<=5) &
                      (personas$c_afilsal_b>=4 & personas$c_afilsal_b<=9) ) ), "segsoc1"] <- 0
    personas[which( ( (personas$c_instsal_a>=1 & personas$c_instsal_a<=5) &
                      (personas$c_afilsal_a>=4 & personas$c_afilsal_a<=9) ) &
                     personas$c_instsal_b=="NA" ), "segsoc1"] <- 0
    personas[which( personas$c_instsal_a==1 & personas$c_instsal_b=="NA" ), "segsoc1"] <- 0
    personas[which( personas$c_instsal_a==99 & personas$c_instsal_a=="NA" &
                    personas$c_instsal_b==99 & personas$c_instsal_b=="NA" ), "segsoc1"] <- 0
    personas[which( personas$c_instsal_a==1 & ( (personas$c_instsal_b>=2 & personas$c_instsal_b<=5) &
                                                (personas$c_afilsal_b>=4 & personas$c_afilsal_b<=99) )
                    ), "segsoc1"] <- 0
    table(personas$segsoc1)

    # seg_pop
    personas$seg_pop <- 0
    personas[which( personas$c_instsal_a==1 | personas$c_instsal_b==1 ),"seg_pop"] <- 1
    personas[which( personas$c_instsal_a>=2 & personas$c_instsal_a<=5 ),"seg_pop"] <- 0
    personas[which( personas$c_instsal_a==99 & personas$c_afilsal_a=="NA" &
                    personas$c_instsal_b=="NA" & personas$c_afilsal_b=="NA" ),"seg_pop"] <- 0
    table(personas$seg_pop)
    table(personas$segsoc1)
    ## recodificaion `segsoc1`
    #personas[which( personas$seg_pop==1 & personas$tot_per==1 &
    #                (personas$tot_ocupo==0 | personas$tot_ocupo=="NA") &
    #                (personas$jubiladof==0 | personas$jubiladof=="NA") ),"segsoc1"] <- "NA"
    #table(personas$segsoc1)

    # j_esc
    personas$j_esc <- 0
    personas[which(personas$es_jefe==1),"j_esc"] <- personas[which(personas$es_jefe==1),"esc"]

    # c_esc
    personas$c_esc <- 0
    personas[which(personas$es_cony==1),"c_esc"] <- personas[which(personas$es_cony==1),"c_esc"]

    #write.csv(personas,file="Bases.Cuis/analisis_personas.csv")

    ### 05_Personas_AgreHogar}
    # Trabajamos con la tabla `personas`

    aux_ind <- which(personas$tot_per==1)
    length(aux_ind)
    table(personas$tot_per)

    aux_var <- c("tot_per","muj12a49","int0a12","int12a64","int65a98",
                 "trabsub","trabind","trab_s_pago","segsoc1","seg_pop")
    dim(personas[aux_ind,c("llave_hogar_h","c_integrante",aux_var)])

    aux_personas <- personas[aux_ind,c("llave_hogar_h","c_integrante",aux_var)]

    hogares_agr_per <- aggregate(x = aux_personas[,aux_var],
                         by = list(aux_personas$llave_hogar_h),
                         FUN = sum )
    dim(hogares_agr_per)
    colnames(hogares_agr_per) <- c( "llave_hogar_h","tot_per","muj12a49","int0a12","int12a64","int65a98",
                                    "trabsub","trabind","trab_s_pago","segsoc1","seg_pop")

    rm(aux_personas,aux_ind,aux_var)

    #write.csv(hogares_agr_per,file="Bases.Cuis/analisis_hogares_agr_per.csv")
    table(hogares_agr_per$seg_pop)

    ### 07_Jefe_AgreHogar}
    # Trabajamos con la tabla `personas`

    aux_ind <- which(personas$es_jefe==1)
    length(aux_ind)

    aux_var <- c("es_jefe")
    dim(personas[aux_ind,c("llave_hogar_h","c_integrante",aux_var)])

    aux_personas <- personas[aux_ind,c("llave_hogar_h","c_integrante",aux_var)]

    hogares_agr_jefe <- aggregate(x = aux_personas[,aux_var],
                                 by = list(aux_personas$llave_hogar_h),
                                 FUN = length )
    dim(hogares_agr_jefe)
    colnames(hogares_agr_jefe)
    colnames(hogares_agr_jefe) <- c("llave_hogar_h","es_jefe")
    table(hogares_agr_jefe$es_jefe)

    hogares_agr_jefe <- merge(hogares_agr_jefe,
                              personas[,c("llave_hogar_h","es_jefe","j_esc","jtrab_ind")],
                              by=c("llave_hogar_h","es_jefe"),
                              all.x = TRUE,
                              sort = TRUE)

    rm(aux_personas,aux_ind,aux_var)

    #write.csv(hogares_agr_jefe,file="Bases.Cuis/analisis_hogares_agr_jefe.csv")

    ### 08_Jefe_AgreHogar_ConyuUnico}
    # Trabajamos con la tabla `personas`

    aux_ind <- which(personas$tot_per==1 & personas$es_cony==1)
    length(aux_ind)

    aux_var <- c("es_cony")
    dim(personas[aux_ind,c("llave_hogar_h","c_integrante",aux_var)])

    aux_personas <- personas[aux_ind,c("llave_hogar_h","c_integrante",aux_var)]

    hogares_agr_cony <- aggregate(x = aux_personas[,aux_var],
                                  by = list(aux_personas$llave_hogar_h),
                                  FUN = length )

    dim(hogares_agr_cony)
    colnames(hogares_agr_cony)
    colnames(hogares_agr_cony) <- c("llave_hogar_h","es_cony")
    table(hogares_agr_cony$es_cony)

    hogares_agr_cony <- merge(hogares_agr_cony,
                              personas[,c("llave_hogar_h","es_cony","c_esc")],
                              by=c("llave_hogar_h","es_cony"),
                              all.x = TRUE,
                              sort = TRUE)

    rm(aux_personas,aux_ind,aux_var)

    #write.csv(hogares_agr_cony,file="Bases.Cuis/analisis_hogares_agr_cony.csv")

    ### 09_AgreHogarPer_Merge}
    # Trabajamos con la tabla `personas

    hogares_agr <- hogares_agr_per
    colnames(hogares_agr)

    hogares_agr <- merge(hogares_agr,
                         hogares_agr_jefe,
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    hogares_agr <- merge(hogares_agr,
                         hogares_agr_cony,
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    colnames(hogares_agr)

    # Viviendas

    vivienda_agr <- merge(se_vivienda_cuis,
                          vivienda_cuis,
                          by=c("llave_hogar_h"),
                          all = TRUE,
                          sort = TRUE)
    dim(vivienda_agr)
    colnames(vivienda_agr)

    # Calculo de variables para modelacion

    ### v01_indice_de_dependencia_demografica}
    # v01 depdemog
    # Trabajamos con la tabla `personas

    hogares_agr$depdemog <- 0
    hogares_agr[which(hogares_agr$int12a64!=0),"depdemog"] <-
      ( hogares_agr[which(hogares_agr$int12a64!=0),"int0a12"] +
        hogares_agr[which(hogares_agr$int12a64!=0),"int65a98"] ) /
      hogares_agr[which(hogares_agr_per$int12a64!=0),"int12a64"]

    summary(hogares_agr[which(hogares_agr$int12a64!=0),"depdemog"])

    ## v02_numero_mujeres_12y49}
    # v02 muj12a49
    # Trabajamos con la tabla `personas

    summary(hogares_agr$muj12a49)

    ## v03_total_personas}
    # v03 ltot_per
    # Trabajamos con la tabla `personas

    hogares_agr$ltot_per <- log(hogares_agr$tot_per)
    summary(hogares_agr$tot_per)
    summary(hogares_agr$ltot_per)
    #plot(hogares_agr[,c("tot_per","ltot_per")])

    ## v04_educacion_jefe}
    # v04 p_esc3, p_esc4 and p_esc5
    # Trabajamos con la tabla `personas

    hogares_agr$p_esc <- 0
    hogares_agr[which(hogares_agr$j_esc!="NA" & hogares_agr$c_esc!="NA"),"p_esc"] <-
      ( hogares_agr[which(hogares_agr$j_esc!="NA" & hogares_agr$c_esc!="NA"),"j_esc"] +
        hogares_agr[which(hogares_agr$j_esc!="NA" & hogares_agr$c_esc!="NA"),"c_esc"] ) / 2
    hogares_agr[which(hogares_agr$j_esc=="NA"),"p_esc"] <-
      hogares_agr[which(hogares_agr$j_esc=="NA"),"c_esc"]
    hogares_agr[which(hogares_agr$c_esc=="NA"),"p_esc"] <-
      hogares_agr[which(hogares_agr$c_esc=="NA"),"j_esc"]

    hogares_agr$p_esc3 <- 0
    hogares_agr[which(hogares_agr$p_esc>=6 & hogares_agr$p_esc<9),"p_esc3"] <- 1
    table(hogares_agr$p_esc3)

    hogares_agr$p_esc4 <- 0
    hogares_agr[which(hogares_agr$p_esc>=9 & hogares_agr$p_esc<12),"p_esc4"] <- 1
    table(hogares_agr$p_esc4)

    hogares_agr$p_esc5 <- 0
    hogares_agr[which(hogares_agr$p_esc>=12),"p_esc5"] <- 1
    table(hogares_agr$p_esc5)

    ## v05_educacion_jefecony_prom}
    # v05 p_esc5b

    hogares_agr$p_esc5b <- 0
    hogares_agr[which(hogares_agr$p_esc4==1 | hogares_agr$p_esc5==1),"p_esc5b"] <- 1
    table(hogares_agr$p_esc5b)

    ## v06_trabajo_subordinado}
    # v06 trab_sub (numero)

    hogares_agr_per$trab_sub <- 0
    hogares_agr_per[which(hogares_agr_per$trabsub>0),"trab_sub"] <-
      hogares_agr_per[which(hogares_agr_per$trabsub>0),"trabsub"]
    hogares_agr_per[which(hogares_agr_per$trabsub==0 &
                          hogares_agr_per$tot_per==0),"trab_sub"] <- 0

    hogares_agr <- merge(hogares_agr,
                         hogares_agr_per[,c("llave_hogar_h","trab_sub")],
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    colnames(hogares_agr)
    summary(hogares_agr_per$trabsub)
    summary(hogares_agr$trab_sub)
    gc()

    ## v07_trabajo_independiente}
    # v07 trab_ind (numero)

    hogares_agr_per$trab_ind <- 0
    hogares_agr_per[which(hogares_agr_per$trabind>0),"trab_ind"] <-
      hogares_agr_per[which(hogares_agr_per$trabind>0),"trabind"]
    hogares_agr_per[which(hogares_agr_per$trabind==0 &
                          hogares_agr_per$tot_per==0),"trab_ind"] <- 0

    hogares_agr <- merge(hogares_agr,
                         hogares_agr_per[,c("llave_hogar_h","trab_ind")],
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    colnames(hogares_agr)
    summary(hogares_agr_per$trabind)
    summary(hogares_agr$trabind)

    ## v08_trabajo_subordinado_sinpago}
    # v08 trab_s_pag (numero)
    hogares_agr_per$trab_s_pag <- 0
    hogares_agr_per[which(hogares_agr_per$trab_s_pago>0),"trab_s_pag"] <-
      hogares_agr_per[which(hogares_agr_per$trab_s_pago>0),"trab_s_pago"]
    hogares_agr_per[which(hogares_agr_per$trab_s_pago==0 &
                          hogares_agr_per$tot_per==0),"trab_s_pago"] <- 0

    hogares_agr <- merge(hogares_agr,
                         hogares_agr_per[,c("llave_hogar_h","trab_s_pag")],
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    colnames(hogares_agr)
    summary(hogares_agr_per$trab_s_pago)
    summary(hogares_agr$trab_s_pag)

    # Acceso alimentación

    ## v09_seguridad_alimentaria_1}
    # v09 seg_alim2 (indicadora)
    vivienda_agr$seg_alim2 <- 0
    vivienda_agr[which(vivienda_agr$seg_alim_2==1),"seg_alim2"] <- 1

    hogares_agr <- merge(hogares_agr,
                         vivienda_agr[,c("llave_hogar_h","seg_alim2")],
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    colnames(hogares_agr)
    table(vivienda_agr$seg_alim_2)
    table(hogares_agr$seg_alim2)

    ## v10_Seguridad_alimentaria_a}
    # v10 seg_alim3 (indicadora)
    vivienda_agr$seg_alim3 <- 0
    vivienda_agr[which(vivienda_agr$seg_alim_a==1),"seg_alim3"] <- 1

    hogares_agr <- merge(hogares_agr,
                         vivienda_agr[,c("llave_hogar_h","seg_alim3")],
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    colnames(hogares_agr)
    table(vivienda_agr$seg_alim_a)
    table(hogares_agr$seg_alim3)

    ## v11_seguridad_alimentaria_conjunta}
    # v11 seg_alim_a (indicadora)
    hogares_agr$seg_alim_a <- 0
    hogares_agr[which(hogares_agr$seg_alim2==1 |
                      hogares_agr$seg_alim3==1 ),"seg_alim_a"] <- 1

    colnames(hogares_agr)
    table(hogares_agr$seg_alim_a)

    # Servicios de Salud

    ## v12_seguro_popular}
    # v12 seg_pop (numero)
    table(hogares_agr$seg_pop)
    hogares_agr[which(hogares_agr$seg_pop==0 & hogares_agr$tot_per>0),"seg_pop"] <- 0
    table(hogares_agr$seg_pop)

    ## v13_servicio_medico}
    # v13 ss (indicadora)
    table(hogares_agr$segsoc1)
    hogares_agr[which(hogares_agr$segsoc1>0),"ss"] <- 1
    hogares_agr[which(hogares_agr$segsoc1==0 & hogares_agr$tot_per>0),"ss"] <- 0
    table(hogares_agr$ss)

    ## v14_trab_ind_ss}
    # v14 ssjtrab_ind (indicadora)
    table(hogares_agr[,c("ss","jtrab_ind")])
    hogares_agr$ssjtrabind <- hogares_agr$ss * hogares_agr$jtrab_ind
    table(hogares_agr$ssjtrabind)

    ## v15_accotros_ingresos}
    # v15 con_remesas (indicadora)
    table(vivienda_agr$con_remesa)
    vivienda_agr$con_remesas <- 0
    vivienda_agr[which(vivienda_agr$con_remesa==2),"con_remesas"] <- 1
    table(vivienda_agr$con_remesas)

    hogares_agr <- merge(hogares_agr,
                         vivienda_agr[,c("llave_hogar_h","con_remesas")],
                         by=c("llave_hogar_h"),
                         all.x = TRUE,
                         sort = TRUE)
    table(hogares_agr$con_remesas)

    gc()

    # Características de la Vivienda

    ## v16_vivenda_propia}
    # v16 viv_prop (indicadora)
    table(vivienda_agr$c_sit_viv)
    vivienda_agr$viv_prop <- 0
    vivienda_agr[which(vivienda_agr$c_sit_viv==1 |
                       vivienda_agr$c_sit_viv==2 |
                       vivienda_agr$c_sit_viv==3 ),"viv_prop"] <- 1

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","viv_prop")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(vivienda_agr$c_sit_viv)
    table(hogares_agr$viv_prop)

    ## v17_vivenda_rantada}
    # v17 viv_rent (indicadora)
    table(vivienda_agr$c_sit_viv)
    vivienda_agr$viv_rent <- 0
    vivienda_agr[which(vivienda_agr$c_sit_viv==4 ),"viv_rent"] <- 1

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","viv_rent")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(vivienda_agr$c_sit_viv)
    table(hogares_agr$viv_rent)

    ## v18_tot_cuartos}
    # v18 tot_cuar (numero)
    table(vivienda_agr[,c("coc_duer", "cuart")])
    vivienda_agr$tot_cuar <- 0
    vivienda_agr[which(vivienda_agr$coc_duer==2 &
                       vivienda_agr$cuart>1),"tot_cuar"] <-
      vivienda_agr[which(vivienda_agr$coc_duer==2 &
                       vivienda_agr$cuart>1),"cuart"]-1
    vivienda_agr[which(vivienda_agr$coc_duer==2 &
                       vivienda_agr$cuart==1),"tot_cuar"] <-
      vivienda_agr[which(vivienda_agr$coc_duer==2 &
                       vivienda_agr$cuart==1),"cuart"]
    vivienda_agr[which(vivienda_agr$coc_duer==1),"tot_cuar"] <-
      vivienda_agr[which(vivienda_agr$coc_duer==1),"cuart"]
    table(vivienda_agr[,c("coc_duer", "cuart")])
    table(vivienda_agr$tot_cuar)

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","tot_cuar")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(vivienda_agr[,c("coc_duer", "cuart")])
    table(hogares_agr$tot_cuar)

    ## v19_tipo_banio}
    # v19 bao1, bao2 and bao3 (indicadoras)
    vivienda_agr$bao1 <- 0
    vivienda_agr$bao2 <- 0
    vivienda_agr$bao3 <- 0

    table(vivienda_agr$c_escusado)

    vivienda_agr[which( (vivienda_agr$c_escusado==1 |
                         vivienda_agr$c_escusado==2 |
                         vivienda_agr$c_escusado==3 |
                         vivienda_agr$c_escusado==4 ) &
                          vivienda_agr$uso_exc==2 ),"bao1"] <- 1
    vivienda_agr[which( vivienda_agr$c_escusado==97 ),"bao1"] <- 1

    vivienda_agr[which( (vivienda_agr$c_escusado==2 |
                         vivienda_agr$c_escusado==3 |
                         vivienda_agr$c_escusado==4 ) &
                          vivienda_agr$uso_exc==1 ),"bao2"] <- 1

    vivienda_agr[which( vivienda_agr$c_escusado==1 &
                          vivienda_agr$uso_exc==1 ),"bao3"] <- 1

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","bao1","bao2","bao3")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr[,c("bao1","bao2")])
    table(hogares_agr[,c("bao1","bao3")])
    table(hogares_agr[,c("bao2","bao3")])

    ## v20_banio_exclusivo}
    # v20 bao13 (indicadoras)
    hogares_agr$bao13 <- 0
    hogares_agr[which(hogares_agr$bao3==1),"bao13"] <- 1

    table(hogares_agr$bao13)

    ## v21_piso_firme}
    # v21 piso_fir & piso_rec (indicadoras)
    table(vivienda_agr$c_piso_viv)
    vivienda_agr$piso_fir <- 0
    vivienda_agr[which(vivienda_agr$c_piso_viv==2),"piso_fir"] <- 1

    vivienda_agr$piso_rec <- 0
    vivienda_agr[which(vivienda_agr$c_piso_viv==3),"piso_rec"] <- 1

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","piso_fir","piso_rec")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr[,c("piso_fir","piso_rec")])

    # Servicios básicos de la vivienda

    ## v22_combustible}
    # v22 combustible (indicadoras)
    table(vivienda_agr$c_combus_cocin)
    vivienda_agr$combustible <- 0
    vivienda_agr[which(vivienda_agr$c_combus_cocin==4 |
                       vivienda_agr$c_combus_cocin==5 ),"combustible"] <- 1

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","combustible")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$combustible)

    gc()

    # Posesión de bienes

    ## v23_sin_refrigerador}
    # v23 sin_refri (indicadoras)
    table(vivienda_agr$ts_refri)
    vivienda_agr$sin_refri <- 0
    vivienda_agr[which( vivienda_agr$ts_refri==22 |
                        vivienda_agr$ts_refri==12 ),"sin_refri"] <- 1
    vivienda_agr[which( vivienda_agr$ts_refri==11 ),"sin_refri"] <- 0

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","sin_refri")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$sin_refri)

    ## v24_sin_vehiculo}
    # v24 sin_vehi (indicadoras)
    table(vivienda_agr$ts_vehi)
    vivienda_agr$sin_vehi <- 0
    vivienda_agr[which( vivienda_agr$ts_vehi==22 |
                        vivienda_agr$ts_vehi==12 ),"sin_vehi"] <- 1
    vivienda_agr[which( vivienda_agr$ts_vehi==11 ),"sin_vehi"] <- 0

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","sin_vehi")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$sin_vehi)

    ## v25_sin_compu}
    # v25 sin_compu (indicadoras)
    table(vivienda_agr$ts_compu)
    vivienda_agr$sin_compu <- 0
    vivienda_agr[which( vivienda_agr$ts_compu==22 |
                        vivienda_agr$ts_compu==12 ),"sin_compu"] <- 1
    vivienda_agr[which( vivienda_agr$ts_compu==11 ),"sin_compu"] <- 0

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","sin_compu")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$sin_compu)

    ## v26_sin_vhs_dvd}
    # v26 sin_vidvd (indicadoras)
    table(vivienda_agr$ts_vhs_dvd_br)
    vivienda_agr$sin_vidvd <- 0
    vivienda_agr[which( vivienda_agr$ts_vhs_dvd_br==22 |
                        vivienda_agr$ts_vhs_dvd_br==12 ),"sin_vidvd"] <- 1
    vivienda_agr[which( vivienda_agr$ts_vhs_dvd_br==11 ),"sin_vidvd"] <- 0

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","sin_vidvd")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$sin_vidvd)

    ## v27_sin_telefono}
    # v27 sin_telef (indicadoras)
    table(vivienda_agr$ts_telefon)
    vivienda_agr$sin_telef <- 0
    vivienda_agr[which( vivienda_agr$ts_telefon==22 |
                        vivienda_agr$ts_telefon==12 ),"sin_telef"] <- 1
    vivienda_agr[which( vivienda_agr$ts_telefon==11 ),"sin_telef"] <- 0

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","sin_telef")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$sin_telef)

    colnames(hogares_agr)

    ## v28_sin_horno}
    # v28 sin_horno (indicadoras)
    table(vivienda_agr$ts_micro)
    vivienda_agr$sin_horno <- 0
    vivienda_agr[which( vivienda_agr$ts_micro==22 |
                        vivienda_agr$ts_micro==12 ),"sin_horno"] <- 1
    vivienda_agr[which( vivienda_agr$ts_micro==11 ),"sin_horno"] <- 0

    hogares_agr <- merge(hogares_agr,
                       vivienda_agr[,c("llave_hogar_h","sin_horno")],
                       by=c("llave_hogar_h"),
                       all.x = TRUE,
                       sort = TRUE)

    table(hogares_agr$sin_horno)

    # Variables numericas y categoricas (p/ modelo)

    #num_cat}
    hogares_agr[,var_enighcuis_num] <- lapply(hogares_agr[,var_enighcuis_num],as.numeric)

    hogares_agr[,var_enighcuis_cat] <- lapply(hogares_agr[,var_enighcuis_cat],factor)

    # Exportacion de tabla de trabajo
    hogares_agr <- merge(hogares_agr, domicilio_cuis,
                         by=c("llave_hogar_h"))

    #exportacion
    filename = paste0('Bases.Cuis/hogares_cuis_agr', as.character(k_i), '_', as.character(k_f), '.csv')
    write.table(hogares_agr, file=filename, sep='|', row.names=FALSE)
    print(filename)
    rm(list=ls())
    gc()
}


dmain <- function(k){
    con <- prev_connect()
    run_features(k, k_tasa, con)
    discon_db(con)
}

# read llaves
llaves_all <- read_csv('../llaves_hogar_sifode.csv')
# parameters
k_i <- 1
k_tasa <- 100000
max_llaves <- nrow(llaves_all)
max_it <- round((max_llaves / k_tasa), 0)

# Calculate the number of cores
no_cores <- 6

# Initiate cluster
cl <- makeCluster(no_cores)
# run function
mclapply(0:max_it, dmain)

stopCluster(cl)
