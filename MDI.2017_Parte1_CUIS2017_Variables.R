
rm(list=ls())

### 00_prelim, include=TRUE}
source("../Code/load.R.packages.R")
load("../Datos.Modelo/mdi_variables_modelo.RData")

### 01_Importacion}
# Sample
hogares4analisis <- read.csv("../Bases.Cuis/hogares_cuis_4_analysis.csv", head = TRUE)
colnames(hogares4analisis)
dim(hogares4analisis)

# encuesta_cuis
domicilio_cuis <- read.csv("../Bases.Cuis/domicilio_cuis.csv", head = TRUE)
colnames(domicilio_cuis)
dim(domicilio_cuis)

# encuesta_cuis
encuesta_cuis <- read.csv("../Bases.Cuis/encuesta_cuis.csv", head = TRUE)
colnames(encuesta_cuis)
dim(encuesta_cuis)

# integrante_cuis
integrante_cuis <- read.csv("../Bases.Cuis/integrante_cuis.csv", head = TRUE)
colnames(integrante_cuis)
dim(integrante_cuis)

# persona_cuis_filtrado
persona_cuis_filtrado <- read.csv("../Bases.Cuis/persona_cuis_filtrado.csv", head = TRUE)
colnames(persona_cuis_filtrado)
dim(persona_cuis_filtrado)

# se_integrante_cuis SE
se_integrante_cuis <- read.csv("../Bases.Cuis/se_integrante_cuis.csv", head = TRUE)
colnames(se_integrante_cuis)
dim(se_integrante_cuis)

# se_vivienda_cuis
se_vivienda_cuis <- read.csv("../Bases.Cuis/se_vivienda_cuis.csv", head = TRUE)
colnames(se_vivienda_cuis)
dim(se_vivienda_cuis)

# v_encuestador_cuis SE
v_encuestador_cuis <- read.csv("../Bases.Cuis/v_encuestador_cuis.csv", head = TRUE)
colnames(v_encuestador_cuis)
dim(v_encuestador_cuis)

# vivienda_cuis
vivienda_cuis <- read.csv("../Bases.Cuis/vivienda_cuis.csv", head = TRUE)
colnames(vivienda_cuis)
dim(vivienda_cuis)

# Personas

### 02_Personas_Composicion}
# Trabajamos con la tabla `integrante_cuis` y `persona_cuis_filtrado`

personas <- merge( integrante_cuis, 
                   persona_cuis_filtrado,
                   by=c("LLAVE_HOGAR_H","C_INTEGRANTE") )

dim(personas)

# tot_per
personas$tot_per <- 0
personas[which( personas$C_CON_RES==1 | 
                  personas$C_CON_RES==2 |
                  personas$C_CON_RES==3 |
                  personas$C_CON_RES==4 ),
                "tot_per"] <- 1

table(personas$tot_per)

# es_jefe
personas$es_jefe <- 0
personas[which( personas$C_CD_PARENTESCO==1 ),
                "es_jefe"] <- 1

table(personas$es_jefe)

# es_cony (>= 12)
personas$es_cony <- 0
personas[which( personas$C_CD_PARENTESCO==1 &
                  personas$EDAD>=12 ),
                "es_cony"] <- 1

table(personas$es_cony)
table(personas[,c("es_jefe","es_cony")])

# int0a12
personas$int0a12 <- 0
personas[which( personas$EDAD>=0 &
                personas$EDAD<=12 ),
                "int0a12"] <- 1

table(personas$int0a12)

# int13a64
personas$int13a64 <- 0
personas[which( personas$EDAD>=13 &
                personas$EDAD<=64 ),
                "int13a64"] <- 1

table(personas$int13a64)

# int65a98
personas$int65a98 <- 0
personas[which( personas$EDAD>=65 &
                personas$EDAD<=98 ),
                "int65a98"] <- 1

table(personas$int65a98)

# muj12a49
personas$muj12a49 <- 0
personas[which( personas$C_CD_SEXO==2 & ( personas$EDAD>=13 &
                                          personas$EDAD<=49 ) ),
                "muj12a49"] <- 1

table(personas$muj12a49)

### 03_Personas_Escolaridad}
# Trabajamos con la tabla `personas` y `se_integrante_cuis`

personas <- merge( personas, 
                   se_integrante_cuis,
                   by=c("LLAVE_HOGAR_H","C_INTEGRANTE") )
dim(personas)

# esc
personas$esc <- 0
personas[which( personas$C_ULT_NIVEL>10 & ( personas$C_ULT_GRA==0 |
                                            personas$C_ULT_GRA!="NA" ) ),
         "esc"] <- 0
personas[which( personas$C_ULT_NIVEL==1 & personas$C_ULT_GRA>=1 & 
                  personas$C_ULT_GRA<=3 ),
          "esc"] <- 0
personas[which( personas$C_ULT_NIVEL==2 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=6 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==2 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=6 ),
                            "C_ULT_GRA"]
personas[which( personas$C_ULT_NIVEL==3 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=3 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==3 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=3 ),
                            "C_ULT_GRA"] + 6
personas[which( personas$C_ULT_NIVEL==4 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=4 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==4 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=4 ),
                            "C_ULT_GRA"] + 9
personas[which( personas$C_ULT_NIVEL==5 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=4 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==5 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=4 ),
                            "C_ULT_GRA"] + 9
personas[which( personas$C_ULT_NIVEL==6 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=4 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==6 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=4 ),
                            "C_ULT_GRA"] + 6
personas[which( personas$C_ULT_NIVEL==7 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=4 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==7 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=4 ),
                            "C_ULT_GRA"] + 9
personas[which( personas$C_ULT_NIVEL==8 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=4 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==8 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=4 ),
                            "C_ULT_GRA"] + 12
personas[which( personas$C_ULT_NIVEL==9 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=6 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==9 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=6 ),
                            "C_ULT_GRA"] + 12
personas[which( personas$C_ULT_NIVEL==10 & personas$C_ULT_GRA>=1 &
                  personas$C_ULT_GRA<=6 ),
         "esc"] <- personas[which( personas$C_ULT_NIVEL==10 & personas$C_ULT_GRA>=1 &
                                     personas$C_ULT_GRA<=6 ),
                            "C_ULT_GRA"] + 16
personas[which( personas$EDAD>=0 & personas$EDAD<1 ),
         "esc"] <- 0
table(personas$esc)

### 04_Personas_Trabajo}
# Trabajamos con la tabla `personas`

# tot_ocupo (>=12)
personas$tot_ocupo <- 0
personas[ which( personas$EDAD>=12 & ( personas$C_CON_TRA>=1 &
                                       personas$C_CON_TRA<=3 ) ),"tot_ocupo"] <- 1
personas[ which( personas$EDAD>=12 & ( personas$C_VER_CON_TRAB>=1 &
                                       personas$C_VER_CON_TRAB<=4 ) ),"tot_ocupo"] <- 1
personas[ which( personas$EDAD>=12 & ( personas$C_CON_TRAB>=4 &
                                       personas$C_CON_TRAB<=7 ) &
                                     ( personas$C_VER_CON_TRAB==5 &
                                       personas$C_VER_CON_TRAB==6 ) ),"tot_ocupo"] <- 0
personas[ which( personas$EDAD>=0 & personas$EDAD<12 ),"tot_ocupo"] <- 0
table(personas$tot_ocupo)

# trabsub (>=12)
personas$trabsub <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==1 & 
                 personas$TRAB_INDEP=="NA" & personas$TRAB_NO_RE==1 ),"trabsub"] <- 1
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==1 & 
                 personas$TRAB_INDEP=="NA" & personas$TRAB_NO_RE==2 ),"trabsub"] <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==2 & 
                   personas$TRAB_INDEP==1 ),"trabsub"] <- 0
personas[ which( personas$tot_ocupo==0 ),"trabsub"] <- 0
personas[ which( personas$EDAD>=0 & personas$EDAD<12 ),"trabsub"] <- 0
table(personas$trabsub)

# trabind (>=12)
personas$trabind <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==2 & 
                   personas$TRAB_INDEP==1 & personas$TRAB_NO_RE==1 ),"trabind"] <- 1
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==1 & 
                   personas$TRAB_INDEP=="NA" ),"trabind"] <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==2 & 
                   personas$TRAB_INDEP==1 & personas$TRAB_NO_RE==2 ),"trabind"] <- 0
personas[ which( personas$tot_ocupo==0 ),"trabind"] <- 0
personas[ which( personas$EDAD>=0 & personas$EDAD<12 ),"trabind"] <- 0
table(personas$trabind)

# trab_s_pago (>=12)
personas$trab_s_pago <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==2 & 
                   personas$TRAB_INDEP==2 & personas$TRAB_NO_RE==2 ),"trab_s_pago"] <- 1
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==1 & 
                   personas$TRAB_INDEP=="NA" & personas$TRAB_NO_RE==1 ),"trab_s_pago"] <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==1 & 
                   personas$TRAB_INDEP=="NA" & personas$TRAB_NO_RE==2 ),"trab_s_pago"] <- 1
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==2 & 
                   personas$TRAB_INDEP==1 & personas$TRAB_NO_RE==1 ),"trab_s_pago"] <- 0
personas[ which( personas$tot_ocupo==1 & personas$TRAB_SUBOR==2 & 
                   personas$TRAB_INDEP==1 & personas$TRAB_NO_RE==2 ),"trab_s_pago"] <- 1
personas[ which( personas$tot_ocupo==0 ),"trab_s_pago"] <- 0
personas[ which( personas$EDAD>=0 & personas$EDAD<12 ),"trab_s_pago"] <- 0
table(personas$trab_s_pago)

# jtrab_ind (>=12)
personas$jtrab_ind <- 0
personas[ which( personas$es_jefe==1 ),"jtrab_ind"] <- 
  personas[ which( personas$es_jefe==1 ),"trabind"]
table(personas$jtrab_ind)

# jubiladof (>=12)
personas$jubiladof <- 0
personas[ which( personas$EDAD>=12 & ( (personas$C_CON_TRA>=4 & personas$C_CON_TRA<=7) & 
                                       (personas$C_VER_CON_TRA==5 | personas$C_VER_CON_TRAB==6) ) &
                   (personas$C_RAZ_NO_TRAB==2) ) ,"jubiladof"] <- 1
personas[ which( personas$EDAD>=12 & ( (personas$C_CON_TRA>=4 & personas$C_CON_TRA<=7) & 
                                       (personas$C_VER_CON_TRA==5 | personas$C_VER_CON_TRAB==6) ) &
                   (personas$C_RAZ_NO_TRAB!=2 & personas$C_RAZ_NO_TRAB!=0) ) ,"jubiladof"] <- 0
personas[ which( personas$EDAD>=12 & ( personas$C_CON_TRA>=1 & personas$C_CON_TRA<=3) &
                   personas$C_VER_CON_TRAB=="NA" ) ,"jubiladof"] <- 0
personas[ which( personas$EDAD>=12 & ( personas$C_CON_TRA>=4 & personas$C_CON_TRA<=7) &
                   (personas$C_VER_CON_TRAB>=1 & personas$C_VER_CON_TRAB<=4) ),"jubiladof"] <- 0
personas[ which( personas$EDAD>=12 & personas$JUBILADO==1 ),"jubiladof"] <- 1
personas[ which( personas$EDAD>=12 & personas$JUBILADO==2 ),"jubiladof"] <- 0
personas[ which( personas$EDAD>=12 & personas$JUBILADO=="NA" &
                   (personas$JUBILADO_1==1 | personas$JUBILADO_2==1)),"jubiladof"] <- 1
personas[ which( personas$EDAD>=12 & personas$JUBILADO=="NA" &
                   (personas$JUBILADO_1>=2 | personas$JUBILADO_2>=2)),"jubiladof"] <- 0
personas[ which( personas$EDAD>=0 & personas$EDAD<12 ),"jubiladof"] <- 0
table(personas$jubiladof)

# segsoc1 ()
personas$segsoc1 <- 0
personas[which( (personas$C_INSTSAL_A>=2 & personas$C_INSTSAL_A<=5) &
                (personas$C_AFILSAL_A >=1 & personas$C_AFILSAL_A<=3 ) ), "segsoc1"] <- 1
personas[which( (personas$C_INSTSAL_B>=2 & personas$C_INSTSAL_B<=5) &
                  (personas$C_AFILSAL_B >=1 & personas$C_AFILSAL_B<=3 ) ), "segsoc1"] <- 1
personas[which( ( (personas$C_INSTSAL_A>=1 & personas$C_INSTSAL_A<=5) &
                  (personas$C_AFILSAL_A>=4 & personas$C_AFILSAL_A<=9) ) &
                ( (personas$C_INSTSAL_B>=1 & personas$C_INSTSAL_B<=5) &
                  (personas$C_AFILSAL_B>=4 & personas$C_AFILSAL_B<=9) ) ), "segsoc1"] <- 0
personas[which( ( (personas$C_INSTSAL_A>=1 & personas$C_INSTSAL_A<=5) &
                  (personas$C_AFILSAL_A>=4 & personas$C_AFILSAL_A<=9) ) &
                 personas$C_INSTSAL_B=="NA" ), "segsoc1"] <- 0
personas[which( personas$C_INSTSAL_A==1 & personas$C_INSTSAL_B=="NA" ), "segsoc1"] <- 0
personas[which( personas$C_INSTSAL_A==99 & personas$C_INSTSAL_A=="NA" &
                personas$C_INSTSAL_B==99 & personas$C_INSTSAL_B=="NA" ), "segsoc1"] <- 0
personas[which( personas$C_INSTSAL_A==1 & ( (personas$C_INSTSAL_B>=2 & personas$C_INSTSAL_B<=5) &
                                            (personas$C_AFILSAL_B>=4 & personas$C_AFILSAL_B<=99) ) 
                ), "segsoc1"] <- 0
table(personas$segsoc1)

# seg_pop
personas$seg_pop <- 0
personas[which( personas$C_INSTSAL_A==1 | personas$C_INSTSAL_B==1 ),"seg_pop"] <- 1
personas[which( personas$C_INSTSAL_A>=2 & personas$C_INSTSAL_A<=5 ),"seg_pop"] <- 0
personas[which( personas$C_INSTSAL_A==99 & personas$C_AFILSAL_A=="NA" &
                personas$C_INSTSAL_B=="NA" & personas$C_AFILSAL_B=="NA" ),"seg_pop"] <- 0
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

write.csv(personas,file="../Bases.Cuis/analisis_personas.csv")

### 05_Personas_AgreHogar}
# Trabajamos con la tabla `personas`

aux_ind <- which(personas$tot_per==1)
length(aux_ind)
table(personas$tot_per)

aux_var <- c("tot_per","muj12a49","int0a12","int13a64","int65a98",
             "trabsub","trabind","trab_s_pago","segsoc1","seg_pop")
dim(personas[aux_ind,c("LLAVE_HOGAR_H","C_INTEGRANTE",aux_var)])

aux_personas <- personas[aux_ind,c("LLAVE_HOGAR_H","C_INTEGRANTE",aux_var)]

hogares_agr_per <- aggregate(x = aux_personas[,aux_var],
                     by = list(aux_personas$LLAVE_HOGAR_H),
                     FUN = sum )
dim(hogares_agr_per)
colnames(hogares_agr_per) <- c( "LLAVE_HOGAR_H","tot_per","muj12a49","int0a12","int13a64","int65a98",
                                "trabsub","trabind","trab_s_pago","segsoc1","seg_pop")

rm(aux_personas,aux_ind,aux_var)

write.csv(hogares_agr_per,file="../Bases.Cuis/analisis_hogares_agr_per.csv")
table(hogares_agr_per$seg_pop)

### 07_Jefe_AgreHogar}
# Trabajamos con la tabla `personas`

aux_ind <- which(personas$es_jefe==1)
length(aux_ind)

aux_var <- c("es_jefe")
dim(personas[aux_ind,c("LLAVE_HOGAR_H","C_INTEGRANTE",aux_var)])

aux_personas <- personas[aux_ind,c("LLAVE_HOGAR_H","C_INTEGRANTE",aux_var)]

hogares_agr_jefe <- aggregate(x = aux_personas[,aux_var],
                             by = list(aux_personas$LLAVE_HOGAR_H),
                             FUN = length )
dim(hogares_agr_jefe)
colnames(hogares_agr_jefe)
colnames(hogares_agr_jefe) <- c("LLAVE_HOGAR_H","es_jefe")
table(hogares_agr_jefe$es_jefe)

hogares_agr_jefe <- merge(hogares_agr_jefe,
                          personas[,c("LLAVE_HOGAR_H","es_jefe","j_esc","jtrab_ind")],
                          by=c("LLAVE_HOGAR_H","es_jefe"),
                          all.x = TRUE,
                          sort = TRUE)

rm(aux_personas,aux_ind,aux_var)

write.csv(hogares_agr_jefe,file="../Bases.Cuis/analisis_hogares_agr_jefe.csv")

### 08_Jefe_AgreHogar_ConyuUnico}
# Trabajamos con la tabla `personas`

aux_ind <- which(personas$tot_per==1 & personas$es_cony==1)
length(aux_ind)

aux_var <- c("es_cony")
dim(personas[aux_ind,c("LLAVE_HOGAR_H","C_INTEGRANTE",aux_var)])

aux_personas <- personas[aux_ind,c("LLAVE_HOGAR_H","C_INTEGRANTE",aux_var)]

hogares_agr_cony <- aggregate(x = aux_personas[,aux_var],
                              by = list(aux_personas$LLAVE_HOGAR_H),
                              FUN = length )

dim(hogares_agr_cony)
colnames(hogares_agr_cony)
colnames(hogares_agr_cony) <- c("LLAVE_HOGAR_H","es_cony")
table(hogares_agr_cony$es_cony)

hogares_agr_cony <- merge(hogares_agr_cony,
                          personas[,c("LLAVE_HOGAR_H","es_cony","c_esc")],
                          by=c("LLAVE_HOGAR_H","es_cony"),
                          all.x = TRUE,
                          sort = TRUE)

rm(aux_personas,aux_ind,aux_var)

write.csv(hogares_agr_cony,file="../Bases.Cuis/analisis_hogares_agr_cony.csv")

### 09_AgreHogarPer_Merge}
# Trabajamos con la tabla `personas

hogares_agr <- hogares_agr_per
colnames(hogares_agr)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_jefe,
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
hogares_agr <- merge(hogares_agr,
                     hogares_agr_cony,
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
colnames(hogares_agr)

# Viviendas

vivienda_agr <- merge(se_vivienda_cuis,
                      vivienda_cuis,
                      by=c("LLAVE_HOGAR_H"),
                      all = TRUE,
                      sort = TRUE)
dim(vivienda_agr)
colnames(vivienda_agr)

# Calculo de variables para modelacion

### v01_indice_de_dependencia_demografica} 
# v01 depdemog
# Trabajamos con la tabla `personas

hogares_agr$depdemog <- 0
hogares_agr[which(hogares_agr$int13a64!=0),"depdemog"] <- 
  ( hogares_agr[which(hogares_agr$int13a64!=0),"int0a12"] + 
    hogares_agr[which(hogares_agr$int13a64!=0),"int65a98"] ) /
  hogares_agr[which(hogares_agr_per$int13a64!=0),"int13a64"]

summary(hogares_agr[which(hogares_agr$int13a64!=0),"depdemog"])

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
plot(hogares_agr[,c("tot_per","ltot_per")])

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
                     hogares_agr_per[,c("LLAVE_HOGAR_H","trab_sub")],
                     by=c("LLAVE_HOGAR_H"),
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
                     hogares_agr_per[,c("LLAVE_HOGAR_H","trab_ind")],
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
colnames(hogares_agr)
summary(hogares_agr_per$trabind)
summary(hogares_agr$trab_ind)

## v08_trabajo_subordinado_sinpago} 
# v08 trab_s_pag (numero)
hogares_agr_per$trab_s_pag <- 0
hogares_agr_per[which(hogares_agr_per$trab_s_pago>0),"trab_s_pag"] <- 
  hogares_agr_per[which(hogares_agr_per$trab_s_pago>0),"trab_s_pago"] 
hogares_agr_per[which(hogares_agr_per$trab_s_pago==0 & 
                      hogares_agr_per$tot_per==0),"trab_s_pago"] <- 0

hogares_agr <- merge(hogares_agr,
                     hogares_agr_per[,c("LLAVE_HOGAR_H","trab_s_pag")],
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
colnames(hogares_agr)
summary(hogares_agr_per$trab_s_pago)
summary(hogares_agr$trab_s_pag)

# Acceso alimentación

## v09_seguridad_alimentaria_1} 
# v09 seg_alim2 (indicadora)
vivienda_agr$seg_alim2 <- 0
vivienda_agr[which(vivienda_agr$SEG_ALIM_2==1),"seg_alim2"] <- 1

hogares_agr <- merge(hogares_agr,
                     vivienda_agr[,c("LLAVE_HOGAR_H","seg_alim2")],
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
colnames(hogares_agr)
table(vivienda_agr$SEG_ALIM_2)
table(hogares_agr$seg_alim2)

## v10_Seguridad_alimentaria_a} 
# v10 seg_alim3 (indicadora)
vivienda_agr$seg_alim3 <- 0
vivienda_agr[which(vivienda_agr$SEG_ALIM_A==1),"seg_alim3"] <- 1

hogares_agr <- merge(hogares_agr,
                     vivienda_agr[,c("LLAVE_HOGAR_H","seg_alim3")],
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
colnames(hogares_agr)
table(vivienda_agr$SEG_ALIM_A)
table(hogares_agr$seg_alim3)

## v11_seguridad_alimentaria_conjunta} 
# v11 seg_alim_a2 (indicadora)
hogares_agr$seg_alim_a2 <- 0
hogares_agr[which(hogares_agr$seg_alim2==1 | 
                  hogares_agr$seg_alim3==1 ),"seg_alim_a2"] <- 1

colnames(hogares_agr)
table(hogares_agr$seg_alim_a2)

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

## v14_trabind_ss} 
# v14 ssjtrabind (indicadora)
table(hogares_agr[,c("ss","jtrab_ind")])
hogares_agr$ssjtrabind <- hogares_agr$ss * hogares_agr$jtrab_ind
table(hogares_agr$ssjtrabind)

## v15_accotros_ingresos} 
# v15 con_remesas (indicadora)
table(vivienda_agr$CON_REMESA)
vivienda_agr$con_remesas <- 0
vivienda_agr[which(vivienda_agr$CON_REMESA==2),"con_remesas"] <- 1
table(vivienda_agr$con_remesas)

hogares_agr <- merge(hogares_agr,
                     vivienda_agr[,c("LLAVE_HOGAR_H","con_remesas")],
                     by=c("LLAVE_HOGAR_H"),
                     all.x = TRUE,
                     sort = TRUE)
table(hogares_agr$con_remesas)

gc()

# Características de la Vivienda

## v16_vivenda_propia} 
# v16 viv_prop (indicadora)
table(vivienda_agr$C_SIT_VIV)
vivienda_agr$viv_prop <- 0
vivienda_agr[which(vivienda_agr$C_SIT_VIV==1 |
                   vivienda_agr$C_SIT_VIV==2 |
                   vivienda_agr$C_SIT_VIV==3 ),"viv_prop"] <- 1

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","viv_prop")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(vivienda_agr$C_SIT_VIV)
table(hogares_agr$viv_prop)

## v17_vivenda_rantada} 
# v17 viv_rent (indicadora)
table(vivienda_agr$C_SIT_VIV)
vivienda_agr$viv_rent <- 0
vivienda_agr[which(vivienda_agr$C_SIT_VIV==4 ),"viv_rent"] <- 1

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","viv_rent")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(vivienda_agr$C_SIT_VIV)
table(hogares_agr$viv_rent)

## v18_tot_cuartos} 
# v18 tot_cuar (numero)
table(vivienda_agr[,c("COC_DUER","CUART")])
vivienda_agr$tot_cuar <- 0
vivienda_agr[which(vivienda_agr$COC_DUER==2 &
                   vivienda_agr$CUART>1),"tot_cuar"] <-
  vivienda_agr[which(vivienda_agr$COC_DUER==2 &
                   vivienda_agr$CUART>1),"CUART"]-1
vivienda_agr[which(vivienda_agr$COC_DUER==2 &
                   vivienda_agr$CUART==1),"tot_cuar"] <-
  vivienda_agr[which(vivienda_agr$COC_DUER==2 &
                   vivienda_agr$CUART==1),"CUART"]
vivienda_agr[which(vivienda_agr$COC_DUER==1),"tot_cuar"] <-
  vivienda_agr[which(vivienda_agr$COC_DUER==1),"CUART"]
table(vivienda_agr[,c("COC_DUER","CUART")])
table(vivienda_agr$tot_cuar)

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","tot_cuar")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(vivienda_agr[,c("COC_DUER","CUART")])
table(hogares_agr$tot_cuar)

## v19_tipo_banio} 
# v19 bao1, bao2 and bao3 (indicadoras)
vivienda_agr$bao1 <- 0
vivienda_agr$bao2 <- 0
vivienda_agr$bao3 <- 0

table(vivienda_agr$C_ESCUSADO)

vivienda_agr[which( (vivienda_agr$C_ESCUSADO==1 |
                     vivienda_agr$C_ESCUSADO==2 |
                     vivienda_agr$C_ESCUSADO==3 |
                     vivienda_agr$C_ESCUSADO==4 ) &
                      vivienda_agr$USO_EXC==2 ),"bao1"] <- 1
vivienda_agr[which( vivienda_agr$C_ESCUSADO==97 ),"bao1"] <- 1

vivienda_agr[which( (vivienda_agr$C_ESCUSADO==2 |
                     vivienda_agr$C_ESCUSADO==3 |
                     vivienda_agr$C_ESCUSADO==4 ) &
                      vivienda_agr$USO_EXC==1 ),"bao2"] <- 1

vivienda_agr[which( vivienda_agr$C_ESCUSADO==1 &
                      vivienda_agr$USO_EXC==1 ),"bao3"] <- 1

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","bao1","bao2","bao3")],
                   by=c("LLAVE_HOGAR_H"),
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
table(vivienda_agr$C_PISO_VIV)
vivienda_agr$piso_fir <- 0
vivienda_agr[which(vivienda_agr$C_PISO_VIV==2),"piso_fir"] <- 1

vivienda_agr$piso_rec <- 0
vivienda_agr[which(vivienda_agr$C_PISO_VIV==3),"piso_rec"] <- 1

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","piso_fir","piso_rec")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr[,c("piso_fir","piso_rec")])

# Servicios básicos de la vivienda

## v22_combustible} 
# v22 combustible (indicadoras)
table(vivienda_agr$C_COMBUS_COCIN)
vivienda_agr$combustible <- 0
vivienda_agr[which(vivienda_agr$C_COMBUS_COCIN==4 |
                   vivienda_agr$C_COMBUS_COCIN==5 ),"combustible"] <- 1

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","combustible")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$combustible)

gc()

# Posesión de bienes

## v23_sin_refrigerador} 
# v23 sin_refri (indicadoras)
table(vivienda_agr$TS_REFRI)
vivienda_agr$sin_refri <- 0
vivienda_agr[which( vivienda_agr$TS_REFRI==22 |
                    vivienda_agr$TS_REFRI==12 ),"sin_refri"] <- 1
vivienda_agr[which( vivienda_agr$TS_REFRI==11 ),"sin_refri"] <- 0

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","sin_refri")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$sin_refri)

## v24_sin_vehiculo} 
# v24 sin_vehi (indicadoras)
table(vivienda_agr$TS_VEHI)
vivienda_agr$sin_vehi <- 0
vivienda_agr[which( vivienda_agr$TS_VEHI==22 |
                    vivienda_agr$TS_VEHI==12 ),"sin_vehi"] <- 1
vivienda_agr[which( vivienda_agr$TS_VEHI==11 ),"sin_vehi"] <- 0

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","sin_vehi")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$sin_vehi)

## v25_sin_compu} 
# v25 sin_compu (indicadoras)
table(vivienda_agr$TS_COMPU)
vivienda_agr$sin_compu <- 0
vivienda_agr[which( vivienda_agr$TS_COMPU==22 |
                    vivienda_agr$TS_COMPU==12 ),"sin_compu"] <- 1
vivienda_agr[which( vivienda_agr$TS_COMPU==11 ),"sin_compu"] <- 0

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","sin_compu")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$sin_compu)

## v26_sin_vhs_dvd} 
# v26 sin_vidvd (indicadoras)
table(vivienda_agr$TS_VHS_DVD_BR)
vivienda_agr$sin_vidvd <- 0
vivienda_agr[which( vivienda_agr$TS_VHS_DVD_BR==22 |
                    vivienda_agr$TS_VHS_DVD_BR==12 ),"sin_vidvd"] <- 1
vivienda_agr[which( vivienda_agr$TS_VHS_DVD_BR==11 ),"sin_vidvd"] <- 0

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","sin_vidvd")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$sin_vidvd)

## v27_sin_telefono} 
# v27 sin_teleff (indicadoras)
table(vivienda_agr$TS_TELEFON)
vivienda_agr$sin_teleff <- 0
vivienda_agr[which( vivienda_agr$TS_TELEFON==22 |
                    vivienda_agr$TS_TELEFON==12 ),"sin_teleff"] <- 1
vivienda_agr[which( vivienda_agr$TS_TELEFON==11 ),"sin_teleff"] <- 0

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","sin_teleff")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$sin_teleff)

colnames(hogares_agr)

## v28_sin_horno} 
# v28 sin_horno (indicadoras)
table(vivienda_agr$TS_MICRO)
vivienda_agr$sin_horno <- 0
vivienda_agr[which( vivienda_agr$TS_MICRO==22 |
                    vivienda_agr$TS_MICRO==12 ),"sin_horno"] <- 1
vivienda_agr[which( vivienda_agr$TS_MICRO==11 ),"sin_horno"] <- 0

hogares_agr <- merge(hogares_agr,
                   vivienda_agr[,c("LLAVE_HOGAR_H","sin_horno")],
                   by=c("LLAVE_HOGAR_H"),
                   all.x = TRUE,
                   sort = TRUE)

table(hogares_agr$sin_horno)

# Variables numericas y categoricas (p/ modelo)

#num_cat}
hogares_agr[,var_enighcuis_num] <- lapply(hogares_agr[,var_enighcuis_num],as.numeric)

hogares_agr[,var_enighcuis_cat] <- lapply(hogares_agr[,var_enighcuis_cat],factor)

# Exportacion de tabla de trabajo

#exportacion}
write.csv(hogares_agr,file="../Bases.Cuis/hogares_cuis_agr.csv")
colnames(hogares_agr)
rm(list=ls())
gc()
