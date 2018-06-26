#
# Utilizamos los datos de ENIGH 2016 empleados por CONEVAL
#

# solo para Windows
memory.size(16000000)

rm(list=ls())

### 00_prelim, include=TRUE}
source("MDI.Scripts/Code/load.R.packages.R")

### 01_poblacion2}
# General - Poblacion1
poblacion1 <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf", as.is = TRUE)

names(poblacion1) <- tolower(names(poblacion1))

# Parentesco - Poblacion2
poblacion2 <- as.numeric(poblacion1$parentesco)

#Seleccion de parentezcos
index <- ( (poblacion2>=400 & poblacion2<500) | 
             (poblacion2>=700 & poblacion2 <800) )
index <- (index==FALSE)

# Poblacion seleccionada
poblacion <- poblacion1[index,]
dim(poblacion)
colnames(poblacion)

### 02_anio_nacimiento}
anio_med <- 2016

attach(poblacion)

poblacion$anac_e <- anio_med-edad
hist(poblacion$anac_e)

### 03_inasistencia_escolar}
poblacion$inas_esc <- NA

attach(poblacion)
poblacion$inas_esc <- recode(asis_esc, "1=0; 2=1; else=NA")
table(poblacion$inas_esc)

### 04_nivel_educativo}
poblacion$nivelaprob <- as.numeric(nivelaprob)

poblacion$gradoaprob <- as.numeric(gradoaprob)

poblacion$antec_esc <- as.numeric(antec_esc) 

#detach(poblacion)

poblacion$niv_ed <- NA

### 05_nivel_educativo_prim_incompleta}
poblacion$niv_ed[(nivelaprob < 2) | 
                   (nivelaprob == 2 & gradoaprob < 6)] <- 0 

### 06_nivel_educativo_prim_completa}
poblacion$niv_ed[(nivelaprob == 2 & gradoaprob == 6) | 
                   (nivelaprob == 3 & gradoaprob < 3) |
                   (nivelaprob == 5 | nivelaprob == 6) & 
                   gradoaprob < 3 & antec_esc == 1] <- 1

poblacion$niv_ed[((nivelaprob == 3 & gradoaprob == 3) | 
                    (nivelaprob == 4) | 
                    (nivelaprob == 5 & antec_esc == 1 & gradoaprob >= 3) |  
                    (nivelaprob == 6 & antec_esc == 1 & gradoaprob >= 3) |
                    (nivelaprob == 5 & antec_esc >= 2) | 
                    (nivelaprob == 6 & antec_esc >= 2) | 
                    (nivelaprob >= 7))] <- 2 

attach(poblacion)

### 07_secudnaria_completa}
#detach(poblacion)

table(poblacion$niv_ed)

### 08_carencia_rezago_educativo}
#attach(poblacion)

poblacion$ic_rezedu <- NA

poblacion$ic_rezedu[ (edad >= 3 & edad <= 11) & 
                       inas_esc == 1 & 
                       (niv_ed == 0 | niv_ed == 1)] <- 1

poblacion$ic_rezedu[ (edad >= 12) & 
                       (anac_e >= 1982) & 
                       (niv_ed == 0 | niv_ed==1)] <- 1

poblacion$ic_rezedu[ (edad >= 12) & 
                       (anac_e <= 1981) & 
                       (niv_ed == 0)] <- 1

poblacion$ic_rezedu[ (edad >= 0 & edad <= 2)] <- 0

poblacion$ic_rezedu[ (edad >= 3 & edad <= 11) & 
                       inas_esc == 0] <- 0

poblacion$ic_rezedu[ (edad >= 3 & edad <= 11) & 
                       inas_esc == 1 & 
                       (niv_ed == 2)] <- 0

poblacion$ic_rezedu[ (edad >= 12) & 
                       (anac_e >= 1982) & 
                       (niv_ed == 2)] <- 0

poblacion$ic_rezedu[ (edad >= 12) & 
                       (anac_e <= 1981) & 
                       (niv_ed == 1 | niv_ed == 2)] <- 0

attach(poblacion)

table(poblacion$ic_rezedu)

### 09_lengua_indigena}
poblacion$hablaind <- as.numeric(hablaind)

poblacion$hli <- NA

poblacion$hli[ (edad >= 3 & hablaind == 1) ] <- 1

poblacion$hli[ (edad >= 3 & hablaind == 2) ] <- 0

attach(poblacion)

table(poblacion$hli)

### 10_composicion_pob_indigena}
table(poblacion$hli)

table(poblacion$ic_rezedu)

poblacion <- poblacion[,c("folioviv", "foliohog", "numren", 
                          "edad", "anac_e", "inas_esc", 
                          "antec_esc", "niv_ed", 
                          "ic_rezedu", "hli")]

poblacion <- orderBy(~+folioviv+foliohog+numren, data=poblacion)
dim(poblacion)

attach(poblacion)

write.csv( poblacion, "Bases.Enigh/Tablas_2016/2016_ic_rezeducacion.csv", row.names = FALSE)
write.dbf( poblacion, "Bases.Enigh/Tablas_2016/2016_ic_rezeducacion.dbf")

# -----------------

#detach(poblacion)

### 11_privacion_social}
#rm(list=ls())
trabajos <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/trabajos.dbf",
                     as.is = TRUE)
attach(trabajos)
dim(trabajos)

### 12_tipo_trabajo_1}
trabajos$tipo_trab <- NA

trabajos$tipo_trab[subor == 1] <- 1

### 13_tipo_trabajo_2}
trabajos$tipo_trab[ subor == 2 & 
                      indep == 1 & 
                      tiene_suel == 1] <- 2

trabajos$tipo_trab[ subor == 2 & 
                      indep == 2 & 
                      pago == 1] <- 2

### 14_tipo_trabajo_3}
trabajos$tipo_trab[ subor == 2 & 
                      indep == 1 & 
                      tiene_suel == 2] <- 3

trabajos$tipo_trab[ subor == 2 & 
                      indep == 2 & 
                      (pago == 2 | pago == 3)] <- 3

attach(trabajos)

table(trabajos$tipo_trab)
dim(trabajos)

### 15_tipo_ocupacion}
trabajos$ocupa <- NA

trabajos$ocupa[ id_trabajo == 1 ] <- 1

trabajos$ocupa[ id_trabajo == 2 ] <- 0

attach(trabajos)

table(trabajos$ocupa)
dim(trabajos)

### 16_prestaciones_laborales}
trabajos <- trabajos[, c( "folioviv", "foliohog", "numren", 
                          "id_trabajo", "tipo_trab", "ocupa")]

trabajos2 <- reshape( trabajos, 
                      idvar = c("folioviv", "foliohog", "numren"), 
                      timevar = "id_trabajo", direction = "wide" )

#detach(trabajos)
attach(trabajos2)

trabajos2$ocupa2 <- NA

trabajos2$ocupa2[ is.na(ocupa.2) == TRUE ] <- 0

trabajos2$ocupa2[ ocupa.2 == 0 ] <- 1
#detach(trabajos2)

names(trabajos2)[4:6] <- c("tipo_trab1","ocupa1","tipo_trab2" )
#attach(trabajos2)

### 17_base_trabajadora}
trabajos2$trab <- 1

table(trabajos2$trab)

trabajos2 <- trabajos2[, c("folioviv", "foliohog", "numren", 
                           "tipo_trab1", "ocupa1", "tipo_trab2", 
                           "ocupa2", "trab") ]

attach(trabajos2)

trabajos2 <- orderBy(~+folioviv+foliohog+numren, data=trabajos2)
dim(trabajos2)

write.csv(trabajos2,"Bases.Enigh/Tablas_2016/2016_basetrabajadora.csv", row.names = FALSE)
write.dbf(trabajos2,"Bases.Enigh/Tablas_2016/2016_basetrabajadora.dbf")

# --------------------------

### 18_integracion_poblacion_basetrabajadora}
poblacion1 <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf", 
                       as.is = TRUE)
names(poblacion1) <-  tolower(names(poblacion1))
dim(poblacion1)

### 19_poblacion_objetivo} #***
poblacion2 <- as.numeric( poblacion1$parentesco )

index <- ( (poblacion2 >= 400 & poblacion2 < 500) | 
             (poblacion2 >= 700 & poblacion2 < 800) )

index <- ( index == FALSE )

poblacion <- poblacion1[index,]

poblacion <- orderBy(~+folioviv+foliohog+numren, data=poblacion)
dim(poblacion)

ocupados <- read.dbf("Bases.Enigh/Tablas_2016/2016_basetrabajadora.dbf", 
                     as.is = TRUE)
dim(ocupados)

poblacion <- merge(poblacion, ocupados,
                   by.x=c("folioviv", "foliohog", "numren"), 
                   all.x = TRUE)

attach(poblacion)

rm(ocupados)
colnames(poblacion)
dim(poblacion)

### 20_pea}
poblacion$pea <- NA

poblacion$pea[ (trab == 1 & (edad >= 12 & is.na(edad) == FALSE) ) ] <- 1

poblacion$pea[ ( (act_pnea1 == "1" | act_pnea2 == "1") & 
                   (edad >= 12 & is.na(edad) == FALSE) ) ] <- 2

poblacion$pea[ (edad >= 12 & is.na(edad) == FALSE) & 
                 (act_pnea1 == "2" | act_pnea1 == "3" | act_pnea1 == "4" | 
                    act_pnea1 == "5" | act_pnea1 == "6") &
                 is.na(poblacion$pea) == TRUE] <- 0

poblacion$pea[ (edad >= 12 & is.na(edad) == FALSE) & 
                 (act_pnea2 == "2" | act_pnea2 == "3" | act_pnea2 == "4" |
                    act_pnea2 == "5" | act_pnea2 == "6") & 
                 is.na(poblacion$pea) == TRUE] <- 0

attach(poblacion)
table(poblacion$pea)
dim(poblacion)

### 21_tipo_trabajo}
poblacion$tipo_trab1[ pea == 1 & is.na(tipo_trab1) == FALSE & 
                        is.na(pea) == FALSE ] <- 
  poblacion$tipo_trab1[ pea == 1 & is.na(tipo_trab1) == FALSE &
                          is.na(pea) == FALSE]

poblacion$tipo_trab1[ ( pea == 0 | pea == 2 ) ] <- NA

poblacion$tipo_trab1[ is.na(pea) == TRUE] <- NA

### 22_ocupacion_secundaria}
poblacion$tipo_trab2[ pea == 1 & 
                        is.na(tipo_trab2) == FALSE & 
                        is.na(pea) == FALSE ] <- 
  poblacion$tipo_trab2[ pea == 1 & 
                          is.na(tipo_trab2) == FALSE & 
                          is.na(pea) == FALSE ]

poblacion$tipo_trab2[ ( pea == 0 | pea == 2) ] <- NA

poblacion$tipo_trab2[ is.na(pea) == TRUE ] <- NA

attach(poblacion)

### 23_prestacionlabora_ocuprinc}
poblacion$smlab1 <- NA

poblacion$smlab1[ ocupa1 == 1 & atemed==1 & 
                    ( inst_1 == 1 | inst_2 == 2 | 
                        inst_3 == 3 | inst_4 == 4 ) & 
                    ( inscr_1 == 1) ] <- 1

poblacion$smlab1[ ocupa1 == 1 & 
                    is.na(poblacion$smlab1) == TRUE] <-0

### 24_prestacionlabora_ocusecund}
poblacion$smlab2 <- NA

poblacion$smlab2[ ocupa2 == 1 & atemed == 1 & 
                    ( inst_1 == 1 | inst_2 == 2 | 
                        inst_3 == 3 | inst_4 == 4) & 
                    ( inscr_1 == 1) ] <- 1

poblacion$smlab2[ ocupa2 == 1 & is.na(poblacion$smlab2) == TRUE] <- 0

attach(poblacion)
table(poblacion[, c("smlab1","smlab2")])
dim(poblacion)

### 25_prestacionlabora_volun_servmed}
poblacion$smcv <- NA

poblacion$smcv[ atemed == 1 & ( inst_1 == 1 | inst_2 == 2 | 
                                  inst_3 == 3 | inst_4 == 4) & 
                  ( inscr_6 == 6 ) & 
                  ( edad >= 12 & edad <= 97 ) ] <- 1

poblacion$smcv[ ( edad >= 12 & edad <= 97 ) & 
                  is.na(poblacion$smcv) == TRUE ] <- 0

attach(poblacion)
table(poblacion$smcv)
dim(poblacion)

### 26_serviciossalud_ocuprinc}
poblacion$sa_dir <- NA

names(poblacion)

poblacion$sa_dir[ tipo_trab1 == 1 & smlab1 == 1 ] <- 1

poblacion$sa_dir[ tipo_trab1 == 2 & (smlab1 == 1 | smcv == 1)] <- 1

poblacion$sa_dir[ tipo_trab1 == 3 & (smlab1 == 1 | smcv == 1)] <- 1

attach(poblacion)
table(poblacion$sa_dir)
dim(poblacion)

### 27_serviciossalud_ocusecund}
poblacion$sa_dir[ tipo_trab2 == 1 & smlab2 == 1] <- 1

poblacion$sa_dir[ tipo_trab2 == 2 & (smlab2 == 1 | smcv == 1) ] <- 1

poblacion$sa_dir[ tipo_trab2 == 3 & (smlab2 == 1 | smcv == 1) ] <- 1

attach(poblacion)
table(poblacion$sa_dir)
dim(poblacion)

### 28_nucleos_familiares}
parent <- as.numeric(poblacion$parentesco)

poblacion$par <- 6

poblacion$par[ ( parent >= 100 & parent < 200) ] <- 1

poblacion$par[ ( parent >= 200 & parent < 300) ] <- 2

poblacion$par[ (parent >= 300 & parent < 400) ] <- 3

poblacion$par[ parent == 601 ] <- 4

poblacion$par[ parent == 615] <- 5

attach(poblacion)
table(poblacion$par)
dim(poblacion)

### 29_nucleos_failiares_asistenciaescolar}
poblacion$inas_esc <- NA

poblacion$inas_esc[ asis_esc == 1 ] <- 0

poblacion$inas_esc[ asis_esc == 2 ] <- 1

attach(poblacion)
table(poblacion$inas_esc)
dim(poblacion)

### 30_jefe}
poblacion$jef <- 0

poblacion$jef[ par == 1 & sa_dir == 1 ] <- 1

poblacion$jef[ par == 1 & sa_dir == 1 & ( 
  ( (inst_2 == "2" | inst_3 == "3" ) & inscr_6 == "6" ) & 
    (is.na(inst_1) == TRUE & is.na(inst_4) == TRUE & 
       is.na(inst_6) == TRUE ) & 
    (is.na(inscr_1) == TRUE & is.na(inscr_2) == TRUE & 
       is.na(inscr_3) == TRUE & is.na(inscr_4) == TRUE & 
       is.na(inscr_5) == TRUE & is.na(inscr_7) == TRUE) ) ] <- NA

attach(poblacion)
table(poblacion$jef)
dim(poblacion)

### 31_conyuge}
poblacion$cony <- 0

poblacion$cony[ par == 2 & sa_dir == 1 ] <- 1

poblacion$cony[ par == 2 & sa_dir == 1 & 
                  ( ( (inst_2 == "2" | inst_3 == "3") & inscr_6 == "6") & 
                      (is.na(inst_1) == TRUE & is.na(inst_4) == TRUE & 
                         is.na(inst_6) == TRUE) & 
                      (is.na(inscr_1) == TRUE & is.na(inscr_2) == TRUE & 
                         is.na(inscr_3) == TRUE & is.na(inscr_4) == TRUE & 
                         is.na(inscr_5) == TRUE & is.na(inscr_7) == TRUE) ) 
                ] <- NA

attach(poblacion)
table(poblacion$cony)
dim(poblacion)

### 32_hijo}
poblacion$hijo <- 0

poblacion$hijo[ par == 3 & sa_dir == 1 ] <- 1

poblacion$hijo[ par == 3 & sa_dir == 1 & 
                  ( ( (inst_2 == "2" | inst_3 == "3") & inscr_6 == "6" ) & 
                      ( is.na(inst_1) == TRUE & is.na(inst_4) == TRUE & 
                          is.na(inst_6) == TRUE ) & 
                      ( is.na(inscr_1) == TRUE & is.na(inscr_2) == TRUE & 
                          is.na(inscr_3) == TRUE & is.na(inscr_4) == TRUE & 
                          is.na(inscr_5) == TRUE & is.na(inscr_7) == TRUE) ) 
                ] <- NA

attach(poblacion)
table(poblacion$hijo)
dim(poblacion)

### 33_agregacion}
attach(poblacion)
poblacion4 <- aggregate( x = list(jef, cony, hijo), 
                         by = list(folioviv, foliohog),  
                         FUN = sum, 
                         na.rm = FALSE )

names(poblacion4)[1:5] <- c("folioviv", "foliohog",
                            "jef_1", "cony_1", "hijo_1" )

poblacion <- merge(poblacion, poblacion4,
                   by.x=c( "folioviv", "foliohog"), 
                   all.x = TRUE)

attach(poblacion)
dim(poblacion)
rm(poblacion4)

### 34_serviciossalud_jefehogar}
poblacion$jef_sa <- poblacion$jef_1

attach(poblacion)
table(poblacion$jef_sa)
dim(poblacion)

### 35_serviciossalud_conyuge}
poblacion$cony_sa <- 0

poblacion$cony_sa[ (poblacion$cony_1 >= 1 & 
                      is.na(poblacion$cony_1) == FALSE) ] <- 1

attach(poblacion)
table(poblacion$cony_sa)
table(poblacion[,c("jef_sa","cony_sa")])
dim(poblacion)

### 36_serviciossalud_hijos}
poblacion$hijo_sa <- 0

poblacion$hijo_sa[(poblacion$hijo_1 >= 1 & 
                     is.na(poblacion$hijo_1) == FALSE) ] <- 1

attach(poblacion)
table(poblacion$hijo_sa)
table(poblacion[,c("jef_sa","cony_sa","hijo_sa")])
dim(poblacion)

### 37_salud otros_nucleosfaniliares}
attach(poblacion)
poblacion$s_salud <- NA

poblacion$s_salud[ atemed==1 & 
                     (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) & 
                     (inscr_3==3 | inscr_4==4 | inscr_6==6 | inscr_7==7) ] <- 1

poblacion$s_salud[ is.na(segpop) == FALSE & 
                     is.na(atemed) == FALSE & 
                     is.na(poblacion$s_salud) == TRUE ] <- 0

attach(poblacion)
table(poblacion$s_salud)
dim(poblacion)

### 38_carencia_serviciossalud}
poblacion$ic_asalud <- 1

### 39_carencia_serviciossalud_directo}
poblacion$ic_asalud[ sa_dir == 1 ] <- 0

### 40_carencia_serviciossaluds_jefatura}
poblacion$ic_asalud[ par == 1 & cony_sa == 1 ] <- 0

poblacion$ic_asalud[ par == 1 & pea == 0 & hijo_sa == 1 ] <- 0

### 41_carencia_serviciossalud_conjuge}
poblacion$ic_asalud[ par == 2 & jef_sa == 1 ] <- 0

poblacion$ic_asalud[ par == 2 & pea == 0 & hijo_sa == 1] <- 0

### 42_carencia_serviciossalud_descendientes}
poblacion$ic_asalud[ par == 3 & edad < 16 & jef_sa == 1 ] <- 0

poblacion$ic_asalud[ par == 3 & edad < 16 & cony_sa == 1 ] <- 0      

poblacion$ic_asalud[ par == 3 & 
                       (edad >= 16 & edad <= 25) & 
                       inas_esc == 0 & 
                       jef_sa == 1 ] <- 0

poblacion$ic_asalud[ par == 3 & 
                       (edad >= 16 & edad <= 25) & 
                       inas_esc == 0 & 
                       cony_sa == 1 ] <- 0

### 43_carencia_serviciossalud_ascendientes}
poblacion$ic_asalud[ par == 4 & pea == 0 & jef_sa == 1 ] <- 0

poblacion$ic_asalud[ par == 5 & pea == 0 & cony_sa == 1 ] <- 0

### 44_carencia_serviciossaluotrosfamilires}
poblacion$ic_asalud[ s_salud == 1 ] <- 0

### 45_carencia_serviciossalud_reportado}
poblacion$ic_asalud[ segpop == 1 | 
                       (segpop == 2 & atemed == 1 &
                          (inst_1 == "1" | inst_2 == "2" | inst_3 == "3"  |
                             inst_4 == "4" | inst_5 == "5" | inst_6 == "6"  ) ) | 
                       segvol_2 == "2" ] <- 0

attach(poblacion)
table(poblacion$ic_asalud)
dim(poblacion)

write.csv(poblacion,"Bases.Enigh/Tablas_2016/2016_poblacion.csv", 
          row.names = FALSE)

write.dbf(poblacion,"Bases.Enigh/Tablas_2016/2016_poblacion.dbf")

# ------------------------------

### 46_discapacidad1}
poblacion$discap <- 0

poblacion$discap[ (disc1 >= 1 & disc1 <= 7) ] <- 1

poblacion$discap[ (disc2 >= 2 & disc2 <= 7) ] <- 1

poblacion$discap[ (disc3 >= 3 & disc3 <= 7) ] <- 1

poblacion$discap[ (disc4 >= 4 & disc4 <= 7) ] <- 1

poblacion$discap[ (disc5 >= 5 & disc5 <= 7) ] <- 1

poblacion$discap[ (disc6 >= 6 & disc6 <= 7) ] <- 1

poblacion$discap[ (disc7 == 7) ] <- 1

poblacion$discap[ (disc1 == 8 | disc1 == "&" | is.na(disc1) == TRUE) ] <- 0

attach(poblacion)
table(poblacion[,c("ic_asalud","discap")])

poblacion <- poblacion[, c("folioviv", "foliohog", "numren", 
                           "sexo", "discap", "ic_asalud")]

poblacion <- orderBy(~+folioviv+foliohog+numren, data=poblacion)

attach(poblacion)

write.csv(poblacion,"Bases.Enigh/Tablas_2016/2016_ic_salud.csv", 
          row.names = FALSE)

write.dbf(poblacion,"Bases.Enigh/Tablas_2016/2016_ic_salud.dbf")

# -------------------------------

### 47_privacion_social2}
#rm(list=ls())
trabajos <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/trabajos.dbf",
                     as.is = TRUE)

attach(trabajos)

### 48_tipotrabajador_subordinados}
trabajos$tipo_trab <- NA

trabajos$tipo_trab[ subor == 1 ] <- 1

### 49_tipotrabajadro_indepago}
trabajos$tipo_trab[ subor == 2 & indep == 1 & tiene_suel == 1] <- 2

trabajos$tipo_trab[ subor ==2 & indep == 2 & pago == 1 ] <- 2

### 50_tipotrabajador_idenopago}
trabajos$tipo_trab[ subor == 2 & indep == 1 & tiene_suel == 2 ] <-3

trabajos$tipo_trab[ subor == 2 & indep==2 & ( pago == 2| pago == 3) ] <- 3

table(trabajos$tipo_trab)

### 51_prestacioneslaborales}
trabajos$inclab <- NA

trabajos$inclab[ is.na(pres_7) == TRUE ] <- 0

trabajos$inclab[ pres_7 == "07" ] <- 1

trabajos$aforlab <- NA

trabajos$aforlab[ is.na(pres_14) == TRUE ] <-0

trabajos$aforlab[ pres_14 == "14" ] <-1

attach(trabajos)
table(trabajos[,c("inclab","aforlab")])

### 52_ocupacion_principal}
trabajos$ocupa <- NA

trabajos$ocupa[ id_trabajo == 1 ] <- 1

trabajos$ocupa[ id_trabajo == 2 ] <-0

### 53_prestacionsecundario}
names(trabajos)

trabajos <- trabajos[, c("folioviv", "foliohog", "numren", 
                         "id_trabajo", "tipo_trab", "inclab", 
                         "aforlab", "ocupa")]

trabajos2 <- reshape( trabajos, 
                      idvar = c("folioviv", "foliohog", "numren"), 
                      timevar = "id_trabajo", 
                      direction = "wide" )

#detach(trabajos)

#attach(trabajos2)

trabajos2$ocupa2 <- NA

trabajos2$ocupa2[ is.na(ocupa.2) == TRUE ] <- 0

trabajos2$ocupa2[ ocupa.2 == 0 ] <- 1

#detach(trabajos2)

names(trabajos2)[4:10] <- c("tipo_trab1", "inclab1", "aforlab1", 
                            "ocupa1", "tipo_trab2", "inclab2", "aforlab2")

### 54_inclab1_inclab2}
trabajos2 <- trabajos2[,-(5:6)] 

### 55_poblacion_trabajadora}
trabajos2$trab=1
table(trabajos2$trab)

trabajos2=trabajos2[, c("folioviv", "foliohog", "numren", 
                        "tipo_trab1", "ocupa1", "tipo_trab2", 
                        "inclab2", "aforlab2", "ocupa2", "trab" )]

trabajos2 <- orderBy(~+folioviv+foliohog+numren, data=trabajos2)
write.csv(trabajos2, "Bases.Enigh/Tablas_2016/2016_prestaciones_laborales.csv", 
          row.names = FALSE)
write.dbf(trabajos2, "Bases.Enigh/Tablas_2016/2016_prestaciones_laborales.dbf")

# --------------------------------

### 56_ingresos_pension}
ingresos <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/ingresos.dbf",
                     as.is = TRUE)

names(ingresos) <-  tolower(names(ingresos))

attach(ingresos)
index <- (clave=="P032" | clave=="P033" | clave=="P044" | clave=="P045")
index <- (index==TRUE)
ingresos <- ingresos[index,]
#detach(ingresos)

attach(ingresos)
ingresos$ing_pens[(clave=="P032" | clave=="P033")] <- 
  rowMeans(data.frame(ing_1[(clave=="P032" | clave=="P033")], 
                      ing_2[(clave=="P032" | clave=="P033")], 
                      ing_3[(clave=="P032" |clave=="P033")], 
                      ing_4[(clave=="P032" | clave=="P033")], 
                      ing_5[(clave=="P032" | clave=="P033")], 
                      ing_6[(clave=="P032" | clave=="P033")]), 
           na.rm = TRUE)

ingresos$ing_pam[(clave=="P044" | clave=="P045")] <-
  rowMeans(data.frame(ing_1[(clave=="P044" | clave=="P045")], 
                      ing_2[(clave=="P044" | clave=="P045")],
                      ing_3[(clave=="P044" | clave=="P045")], 
                      ing_4[(clave=="P044" | clave=="P045")], 
                      ing_5[(clave=="P044" | clave=="P045")], 
                      ing_6[(clave=="P044" | clave=="P045")]), 
           na.rm = TRUE)

ingresos$ing_pens[is.na(ingresos$ing_pens)==TRUE] <- 0
ingresos$ing_pam[is.na(ingresos$ing_pam)==TRUE] <- 0
#detach(ingresos)

ingresos <- ingresos[, c("folioviv", "foliohog", "numren", 
                         "ing_pens", "ing_pam")]

attach(ingresos)
ingresos2 <- aggregate(x=list(ing_pens, ing_pam), 
                       by=list(folioviv, foliohog, numren),  
                       FUN=sum, na.rm=FALSE)

names(ingresos2 )[1:5] <- c("folioviv", "foliohog", "numren",
                            "ing_pens", "ing_pam")

hist(ingresos2$ing_pens,50)

hist(ingresos2$ing_pam,50)

ingresos2 <- orderBy(~+folioviv+foliohog+numren, data=ingresos2)

write.csv(ingresos2, "Bases.Enigh/Tablas_2016/2016_ingresos_pensiones.csv", 
          row.names = FALSE)
write.dbf(ingresos2, "Bases.Enigh/Tablas_2016/2016_ingresos_pensiones.dbf")

# --------------------------------

### 57_poblacion1_2}
poblacion1 <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf",
                       as.is = TRUE)

names(poblacion1) <- tolower(names(poblacion1))
attach(poblacion1)

### 58_poblacion1_objetivo3}
poblacion2 <- as.numeric(poblacion1$parentesco)
index <- ((poblacion2>=400 & poblacion2<500) | 
            (poblacion2>=700 & poblacion2 <800))

index <- (index==FALSE)

poblacion <- poblacion1[index,]

poblacion <- orderBy(~+folioviv+foliohog+numren, data=poblacion)

attach(poblacion)

prestaciones <- read.dbf("Bases.Enigh/Tablas_2016/2016_prestaciones_laborales.dbf",
                         as.is = TRUE)

poblacion <- merge(poblacion, prestaciones,
                   by.x=c("folioviv", "foliohog", "numren"), 
                   all.x = TRUE)
rm(prestaciones)
poblacion <- orderBy(~+folioviv+foliohog+numren, data=poblacion)
pensiones <- read.dbf("Bases.Enigh/Tablas_2016/2016_ingresos_pensiones.dbf", as.is = TRUE)
poblacion <- merge(poblacion, 
                   pensiones,by.x=c("folioviv", "foliohog", "numren"),
                   all.x = TRUE)
attach(poblacion)
rm(pensiones)

### 59_pea_peasplus}
attach(poblacion)

# Mas de 12 años
poblacion$pea <- NA
poblacion$pea[(trab==1 & (edad>=12 & is.na(edad)==FALSE))] <- 1
poblacion$pea[((act_pnea1=="1" | act_pnea2=="1") & 
                 (edad>=12 & is.na(edad)==FALSE))] <- 2
poblacion$pea[(edad>=12 & is.na(edad)==FALSE) & 
                (act_pnea1=="2" | 
                   act_pnea1=="3" | 
                   act_pnea1=="4" | 
                   act_pnea1=="5" | 
                   act_pnea1=="6") & 
                is.na(poblacion$pea)==TRUE] <- 0
poblacion$pea[(edad>=12 & is.na(edad)==FALSE) & 
                (act_pnea2=="2" | 
                   act_pnea2=="3" | 
                   act_pnea2=="4" | 
                   act_pnea2=="5" | 
                   act_pnea2=="6") & 
                is.na(poblacion$pea)==TRUE] <- 0

table(poblacion$pea)
dim(poblacion)

attach(poblacion)

### 60_ocupacion_primaria_2}
attach(poblacion)

poblacion$tipo_trab1[pea==1 & is.na(tipo_trab1)==FALSE & is.na(pea)==FALSE] <- 
  poblacion$tipo_trab1[pea==1  & is.na(tipo_trab1)==FALSE & is.na(pea)==FALSE]

poblacion$tipo_trab1[(pea==0 | pea==2)]<-NA
poblacion$tipo_trab1[is.na(pea)==TRUE]<-NA
#detach(poblacion)

### 61_ocupacion_secundaria_2}
poblacion$tipo_trab2[pea==1 & is.na(tipo_trab2)==FALSE & is.na(pea)==FALSE] <- 
  poblacion$tipo_trab2[pea==1 & is.na(tipo_trab2)==FALSE & is.na(pea)==FALSE]

poblacion$tipo_trab2[(pea==0 | pea==2)] <- NA
poblacion$tipo_trab2[is.na(pea)==TRUE] <- NA
#detach(poblacion)

### 62_jubilados_2}
poblacion$jub <- NA
poblacion$jub[trabajo_mp==2 & 
                (poblacion$act_pnea1=="2" | 
                   poblacion$act_pnea2=="2")] <- 1
poblacion$jub[ing_pens>0 &
                is.na(ing_pens)==FALSE] <- 1
poblacion$jub[inscr_2==2] <- 1
poblacion$jub[is.na(poblacion$jub)==TRUE] <- 0

attach(poblacion)

### 63_serviciomedico_op_2}
poblacion$smlab1 <- NA
poblacion$smlab1[ocupa1==1 & 
                   atemed==1 & 
                   (inst_1==1 | 
                      inst_2==2 | 
                      inst_3==3 | 
                      inst_4==4) & 
                   (inscr_1==1)] <- 1
poblacion$smlab1[ocupa1==1 & 
                   is.na(poblacion$smlab1)==TRUE] <- 0

### 64_serviciomedico_os_2}
poblacion$smlab2 <- NA
poblacion$smlab2[ocupa2==1 & 
                   atemed==1 & 
                   (inst_1==1 | 
                      inst_2==2 | 
                      inst_3==3 | 
                      inst_4==4) & 
                   (inscr_1==1)] <- 1
poblacion$smlab2[ocupa2==1 & 
                   is.na(poblacion$smlab2)==TRUE] <- 0

attach(poblacion)

### 65_smcv_def}
attach(poblacion)

poblacion$smcv <- NA
poblacion$smcv[atemed==1 & 
                 (inst_1==1 | 
                    inst_2==2 | 
                    inst_3==3 |
                    inst_4==4) & 
                 (inscr_6==6) & 
                 (edad>=12 & edad<=97)] <- 1
poblacion$smcv[(edad>=12 & edad<=97) & 
                 is.na(poblacion$smcv)==TRUE] <- 0

### 66_aforecv_def}
attach(poblacion)

poblacion$aforecv <- NA
poblacion$aforecv[segvol_1==1 & 
                    (edad>=12 & 
                       is.na(edad)==FALSE)] <- 1
poblacion$aforecv[is.na(segvol_1)==TRUE & 
                    (edad>=12 & 
                       is.na(edad)==FALSE) & 
                    is.na(poblacion$aforecv)==TRUE] <- 0

attach(poblacion)

names(poblacion)[181:182] <- c("aforlab1", "inclab1")

### 67_ss_dir_def_prim}
attach(poblacion)

poblacion$ss_dir <- NA
poblacion$ss_dir[tipo_trab1==1 & 
                   (smlab1==1 & 
                      inclab1==1 & 
                      aforlab1==1)] <- 1
poblacion$ss_dir[tipo_trab1==2 & 
                   ((smlab1==1 | 
                       smcv==1) & 
                      (aforlab1==1 | 
                         aforecv==1))] <- 1
poblacion$ss_dir[tipo_trab1==3 & 
                   ((smlab1==1 | 
                       smcv==1) & 
                      aforecv==1)] <- 1

### 68_ss_dir_def_sec}
poblacion$ss_dir[tipo_trab2==1 & 
                   (smlab2==1 & 
                      inclab2==1 & 
                      aforlab2==1)]=1
poblacion$ss_dir[tipo_trab2==2 & 
                   ((smlab2==1 | 
                       smcv==1) & 
                      (aforlab2==1 | 
                         aforecv==1))]=1
poblacion$ss_dir[tipo_trab2==3 & 
                   ((smlab2==1 | 
                       smcv==1) & 
                      aforecv==1)]=1
attach(poblacion)

### 69_ss_dir_def_jub}
poblacion$ss_dir[jub==1]=1
poblacion$ss_dir[is.na(poblacion$ss_dir)==TRUE]=0

### 70_nucleos_familiares}
parent<-as.numeric(poblacion$parentesco)
poblacion$par=6
poblacion$par[(parent>=100 & parent<200)]=1
poblacion$par[(parent>=200 & parent<300)]=2
poblacion$par[(parent>=300 & parent<400)]=3
poblacion$par[parent==601]=4
poblacion$par[parent==615]=5
table(poblacion$par)

### 71_nf_asistencia_escuela}
poblacion$inas_esc=NA
poblacion$inas_esc[asis_esc==1]=0
poblacion$inas_esc[asis_esc==2]=1
#detach(poblacion)

### 72_nf_parentezco_jefe}
attach(poblacion)

poblacion$jef <- 0
poblacion$jef[par==1 & ss_dir==1] <-1
poblacion$jef[par==1 & ss_dir==1 & 
                (((inst_2=="2" | 
                     inst_3=="3") & 
                    inscr_6=="6") & 
                   (is.na(inst_1)==TRUE & 
                      is.na(inst_4)==TRUE & 
                      is.na(inst_6)==TRUE) & 
                   (is.na(inscr_1)==TRUE & 
                      is.na(inscr_2)==TRUE & 
                      is.na(inscr_3)==TRUE & 
                      is.na(inscr_4)==TRUE & 
                      is.na(inscr_5)==TRUE & 
                      is.na(inscr_7)==TRUE))] <- NA
table(poblacion$jef)

poblacion$cony <- 0
poblacion$cony[par==2 & ss_dir==1] <-1
poblacion$cony[par==2 & ss_dir==1 & 
                 (((inst_2=="2" | 
                      inst_3=="3") & 
                     inscr_6=="6") & 
                    (is.na(inst_1)==TRUE & 
                       is.na(inst_4)==TRUE & 
                       is.na(inst_6)==TRUE) & 
                    (is.na(inscr_1)==TRUE & 
                       is.na(inscr_2)==TRUE & 
                       is.na(inscr_3)==TRUE & 
                       is.na(inscr_4)==TRUE & 
                       is.na(inscr_5)==TRUE & 
                       is.na(inscr_7)==TRUE))] <- NA
table(poblacion$cony)

poblacion$hijo <- 0
poblacion$hijo[par==3 & ss_dir==1 & jub==0] <- 1
poblacion$hijo[par==3 & ss_dir==1 & jub==1 & 
                 (edad>25 & is.na(edad)==FALSE)] <- 1
poblacion$hijo[par==3 & ss_dir==1 & 
                 (((inst_2=="2" | 
                      inst_3=="3") & 
                     inscr_6=="6") & 
                    (is.na(inst_1)==TRUE & 
                       is.na(inst_4)==TRUE & 
                       is.na(inst_6)==TRUE) & 
                    (is.na(inscr_1)==TRUE & 
                       is.na(inscr_2)==TRUE & 
                       is.na(inscr_3)==TRUE & 
                       is.na(inscr_4)==TRUE & 
                       is.na(inscr_5)==TRUE & 
                       is.na(inscr_7)==TRUE))] <- NA
table(poblacion$hijo)

#detach(poblacion)

attach(poblacion)
poblacion4=aggregate(x=list(jef, cony, hijo), 
                     by=list(folioviv, foliohog),  
                     FUN=sum, na.rm=FALSE)
#detach(poblacion)
names(poblacion4)[1:5] <- c("folioviv", "foliohog", 
                            "jef_1", "cony_1", "hijo_1" )

poblacion= merge(poblacion, 
                 poblacion4,by.x=c("folioviv", "foliohog"), 
                 all.x = TRUE)

rm(poblacion4)
attach(poblacion)

### 73_acceso_ss_jefe}
poblacion$jef_ss <- poblacion$jef_1
table(poblacion$jef_ss)
dim(poblacion)

### 74_acceso_ss_cony}
poblacion$cony_ss <- 0
poblacion$cony_ss[(cony_1>=1 & is.na(cony_1)==FALSE)]=1
table(poblacion$cony_ss)
dim(poblacion)

### 75_acceso_ss_hijos}
poblacion$hijo_ss=0
poblacion$hijo_ss[(hijo_1>=1 & is.na(hijo_1)==FALSE)]=1
table(poblacion$hijo_ss)
dim(poblacion)

### 76_acceso_ss_otrosnucleos}
poblacion$s_salud <- NA
poblacion$s_salud[atemed==1 & 
                    (inst_1==1 | 
                       inst_2==2 | 
                       inst_3==3 | 
                       inst_4==4) & 
                    (inscr_3==3 | 
                       inscr_4==4 | 
                       inscr_6==6 | 
                       inscr_7==7)] <- 1
poblacion$s_salud[is.na(segpop)==FALSE & 
                    is.na(atemed)==FALSE & 
                    is.na(poblacion$s_salud)==TRUE ] <- 0
table(poblacion$s_salud)
dim(poblacion)

### 77_acceso_ss_adultosmayor}
poblacion$pam <- NA
poblacion$pam[(edad>=65 & 
                 is.na(edad)==FALSE) & 
                ing_pam>0] <- 1
poblacion$pam[(edad>=65 & 
                 is.na(edad)==FALSE) & 
                is.na(poblacion$pam)==TRUE] <- 0
table(poblacion$pam)
dim(poblacion)
#detach(poblacion)

### 77_ic_carencia_ss}
attach(poblacion)
poblacion$ic_segsoc <- NA

### 78_ic_carencia_ss_directo}
poblacion$ic_segsoc[ss_dir==1] <- 0

### 79_ic_carencia_ss_jefe}
poblacion$ic_segsoc[par==1 & 
                      cony_ss==1] <- 0
poblacion$ic_segsoc[par==1 & pea==0 & 
                      hijo_ss==1] <- 0

### 80_ic_carencia_ss_cony}
poblacion$ic_segsoc[par==2 & 
                      jef_ss==1] <- 0
poblacion$ic_segsoc[par==2 & 
                      pea==0 & 
                      hijo_ss==1] <- 0

### 81_ic_carencia_ss_descendientes}
poblacion$ic_segsoc[par==3 & 
                      edad<16 & 
                      jef_ss==1] <- 0
poblacion$ic_segsoc[par==3 & 
                      edad<16 & 
                      cony_ss==1] <- 0      
poblacion$ic_segsoc[par==3 & 
                      (edad>=16 & 
                         edad<=25) & 
                      inas_esc==0 & 
                      jef_ss==1] <- 0
poblacion$ic_segsoc[par==3 & 
                      (edad>=16 & 
                         edad<=25) & 
                      inas_esc==0 & 
                      cony_ss==1] <- 0

### 82_ic_carencia_ascendentes}
poblacion$ic_segsoc[par==4 & 
                      pea==0 & 
                      jef_ss==1] <- 0
poblacion$ic_segsoc[par==5 & 
                      pea==0 & 
                      cony_ss==1] <- 0

### 83_ic_carencia_otros}
poblacion$ic_segsoc[s_salud==1] <- 0

### 84_ic_carencia_adultomayor}
poblacion$ic_segsoc[pam==1] <- 0

poblacion$ic_segsoc[is.na(poblacion$ic_segsoc)==TRUE] <- 1

table(poblacion$pea)
table(poblacion$jub)
table(poblacion$ss_dir)
table(poblacion$jef_ss)
table(poblacion$cony_ss)
table(poblacion$hijo_ss)
table(poblacion$s_salud)
table(poblacion$pam)
table(poblacion$ic_segsoc)
dim(poblacion)

#detach(poblacion)

poblacion=poblacion[, c( "folioviv", "foliohog", "numren", "pea",
                         "jub", "ss_dir", "par", "jef_ss", "cony_ss",
                         "hijo_ss", "s_salud", "pam", "ic_segsoc")]

poblacion <- orderBy(~+folioviv+foliohog+numren, data=poblacion)

write.csv(poblacion, "Bases.Enigh/Tablas_2016/2016_ic_seguridadsocial.csv", 
          row.names = FALSE)
write.dbf(poblacion, "Bases.Enigh/Tablas_2016/2016_ic_seguridadsocial.dbf")

# --------------------------------

### 89_ic_carencia_vivienda}
#rm(list=ls())
hogares<- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/hogares.dbf",
                   as.is = TRUE)

hogares <- orderBy(~+folioviv, data=hogares)

vivienda <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/viviendas.dbf",
                     as.is = TRUE)

hogares2 = merge(hogares, vivienda,by=c( "folioviv"), all.x = TRUE)
hogares2 <- orderBy(~+folioviv, data=hogares2)

attach(hogares2)
hogares2$mat_pisos=recode(mat_pisos, "-1=NA")
hogares2$mat_pisos <- ifelse(mat_pisos == "&", NA, mat_pisos)


attach(hogares2)
hogares2$mat_pisos <- as.numeric(mat_pisos)
hogares2$mat_techos <- as.numeric(mat_techos)
hogares2$mat_muros <- as.numeric(mat_pared)
hogares2$tot_resid <- as.numeric(tot_resid)
hogares2$num_cuarto <- as.numeric(num_cuarto)
##detach(hogares2)

### 90_cv_hac}
hogares2$cv_hac <- hogares2$tot_resid/hogares2$num_cuarto

#detach(hogares2)
attach(hogares2)
dim(hogares2)

### 91_icv_pisos}
hogares2$icv_pisos <- NA
hogares2$icv_pisos[mat_pisos==1] <- 1
hogares2$icv_pisos[mat_pisos>1 & 
                     is.na(mat_pisos)==FALSE] <- 0
table(hogares2$icv_pisos)

### 92_icv_techos}
hogares2$icv_techos <- NA
hogares2$icv_techos[mat_techos<=2] <- 1
hogares2$icv_techos[mat_techos>2 & 
                      is.na(mat_techos)==FALSE] <- 0
table(hogares2$icv_techos)

### 93_icv_muros}
hogares2$icv_muros <- NA
hogares2$icv_muros[mat_muros<=5] <- 1
hogares2$icv_muros[mat_muros>5 & 
                     is.na(mat_muros)==FALSE] <- 0
table(hogares2$icv_muros)

### 94_icv_hac}
hogares2$icv_hac <- NA
hogares2$icv_hac[cv_hac>2.5 & 
                   is.na(cv_hac)==FALSE] <- 1
hogares2$icv_hac[cv_hac<=2.5] <- 0

table(hogares2$icv_hac)
dim(hogares2)
detach(hogares2)

### 95_ic_cv}
attach(hogares2)

hogares2$ic_cv[icv_pisos==1 | 
                 icv_techos==1 | 
                 icv_muros==1 | 
                 icv_hac==1 ] <- 1
hogares2$ic_cv[icv_pisos==0 & 
                 icv_techos==0 & 
                 icv_muros==0 & 
                 icv_hac==0] <- 0
hogares2$ic_cv[is.na(icv_pisos)==TRUE | 
                 is.na(icv_muros)==TRUE | 
                 is.na(icv_muros)==TRUE | 
                 is.na(icv_hac)==TRUE] <- NA

detach(hogares2)

table(hogares2$icv_pisos)
table(hogares2$icv_techos)
table(hogares2$icv_muros)
table(hogares2$icv_hac)
table(hogares2$ic_cv)
dim(hogares2)

hogares2 <- hogares2[, c( 
  "folioviv","foliohog","tot_resid","num_cuarto",
  "icv_pisos","icv_techos","icv_muros","icv_hac","ic_cv")]

hogares2 <- orderBy(~+folioviv+foliohog, data=hogares2)

write.csv(hogares2, "Bases.Enigh/Tablas_2016/2016_ic_vivienda.csv",
          row.names = FALSE)
write.dbf(hogares2, "Bases.Enigh/Tablas_2016/2016_ic_vivienda.dbf")
attach(hogares2)

# -------------------------------

### 96_hogares}
hogares <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/viviendas.dbf",
                    as.is = TRUE)

attach(hogares)
hogares$aguav <- as.numeric(disp_agua)
hogares$drenajev <- as.numeric(drenaje)
hogares$elecv <- as.numeric(disp_elect) 
hogares$combusv <- as.numeric(combustibl)
detach(hogares)

### 97_sb_agua}
attach(hogares)
hogares$aguav[hogares$aguav==0] <- NA 
hogares$sb_agua <- NA
hogares$sb_agua[aguav==7] <- 1
hogares$sb_agua[aguav==6] <- 2
hogares$sb_agua[aguav==5] <- 3
hogares$sb_agua[aguav==4] <- 4
hogares$sb_agua[aguav==3] <- 5
hogares$sb_agua[aguav==2] <- 6
hogares$sb_agua[aguav==1] <- 7

table(hogares$sb_agua)
dim(hogares)

### 98_sb_dren}
hogares$drenajev[hogares$drenajev==0] <- NA
hogares$sb_dren <- NA
hogares$sb_dren[drenajev==5] <- 1
hogares$sb_dren[drenajev==4] <- 2
hogares$sb_dren[drenajev==3] <- 3
hogares$sb_dren[drenajev==2] <- 4
hogares$sb_dren[drenajev==1] <- 5

table(hogares$sb_dren)
dim(hogares)

### 99_sb_electricidad}
hogares$elecv[hogares$elecv==0] <- NA
hogares$sb_luz <- NA
hogares$sb_luz[elecv==5] <- 1
hogares$sb_luz[elecv==3 | elecv==4] <- 2
hogares$sb_luz[elecv==2] <- 3
hogares$sb_luz[elecv==1] <- 4

table(hogares$sb_luz)
dim(hogares)
detach(hogares)

### 100_isb_agua}
attach(hogares)
hogares$isb_agua[sb_agua<=5] <- 1
hogares$isb_agua[sb_agua>5 & 
                   is.na(sb_agua)==FALSE] <- 0
hogares$isb_agua[sb_agua==4 & 
                   ubica_geo=="200580016"] <- 0
table(hogares$isb_agua)

### 110_isb_dren}
hogares$isb_dren[sb_dren<=3] <- 1
hogares$isb_dren[sb_dren>3 & 
                   is.na(sb_dren)==FALSE] <- 0
table( hogares$isb_dren)

### 102_isb_luz}
hogares$isb_luz[sb_luz==1] <- 1
hogares$isb_luz[sb_luz>1 & 
                  is.na(sb_luz)==FALSE] <- 0
table( hogares$isb_luz)

### 103_isb_combus}
hogares$isb_combus <- NA
hogares$isb_combus[(combusv==1 | 
                      combusv==2) & 
                     estufa_chi=="2" & 
                     is.na(combusv)==FALSE] <- 1
hogares$isb_combus[(combusv==1 | 
                      combusv==2) & 
                     estufa_chi=="1" & 
                     is.na(combusv)==FALSE] <- 0
hogares$isb_combus[ combusv>=3 & 
                      combusv<=6 & 
                      is.na(combusv)==FALSE] <- 0

table( hogares$isb_combus)
detach(hogares)

### 104_ic_vivienda_servicios}
attach(hogares)
hogares$ic_sbv <- NA
hogares$ic_sbv[(isb_agua==1 | 
                  isb_dren==1 | 
                  isb_luz==1 | 
                  isb_combus==1)] <- 1
hogares$ic_sbv[isb_agua==0 & 
                 isb_dren==0 & 
                 isb_luz==0 & 
                 isb_combus==0] <- 0
hogares$ic_sbv[is.na(isb_agua)==TRUE | 
                 is.na(isb_dren)==TRUE | 
                 is.na(isb_luz)==TRUE | 
                 is.na(isb_combus)==TRUE] <- NA

#detach(hogares)

attach(hogares)

table(hogares$isb_agua)
table(hogares$isb_dren)
table(hogares$isb_luz)
table(hogares$isb_combus)
table(hogares$ic_sbv)
dim(hogares)

hogares=hogares[, c("folioviv", 
                    "isb_agua", 
                    "isb_dren", 
                    "isb_luz", 
                    "isb_combus", 
                    "ic_sbv")]

hogares <- orderBy(~+folioviv, data=hogares)

write.csv(hogares, "Bases.Enigh/Tablas_2016/2016_ic_privacionsocial.csv", 
          row.names = FALSE)
write.dbf(hogares, "Bases.Enigh/Tablas_2016/2016_ic_privacionsocial.dbf")
#detach(hogares)

# ------------------------------

### 104_ic_alimentacion}
poblacion1 <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf",
                       as.is = TRUE)

names(poblacion1) <- tolower(names(poblacion1))
poblacion2 <- as.numeric(poblacion1$parentesco)
index <- ((poblacion2>=400 & 
             poblacion2<500) | 
            (poblacion2>=700 & 
               poblacion2 <800))
index <- (index==FALSE)
poblacion <- poblacion1[index,]
dim(poblacion)

### 105_ic_alimentacion_hogares12-} 
#***
attach(poblacion)
poblacion$men12 <- NA
poblacion$men12[edad>=0 & 
                  edad<=12] <- 1
poblacion$men12[edad>12] <- 0
#detach(poblacion)

attach(poblacion)
poblacion2 <- aggregate(x=list(men12), 
                        by=list( folioviv, foliohog),  
                        FUN=sum, na.rm=TRUE)
#detach(poblacion)
names(poblacion2)[1:3] <- c( "folioviv", "foliohog",
                             "men12")

attach(poblacion2)
poblacion2$id_men12 <- NA
poblacion2$id_men12[men12>=1 & 
                      is.na(men12)==FALSE] <- 1
poblacion2$id_men12[men12==0] <- 0
#detach(poblacion2)

attach(poblacion2)
poblacion2=poblacion2[, c( "folioviv", "foliohog", 
                           "id_men12")]
poblacion2 <- orderBy(~+folioviv+foliohog, data=poblacion2)

write.csv(poblacion2, "Bases.Enigh/Tablas_2016/2016_hogares_menos12a.csv", 
          row.names = FALSE)
write.dbf(poblacion2, "Bases.Enigh/Tablas_2016/2016_hogares_menos12a.dbf")
#detach(poblacion2)

# ---------------------------------

hogares <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/hogares.dbf",
                    as.is = TRUE)

### 106_6pregs_1}
attach(hogares)
hogares$ia_1ad <- NA
hogares$ia_1ad[acc_alim4==1] <- 1
hogares$ia_1ad[acc_alim4==2] <- 0
hogares$ia_1ad[is.na(acc_alim4)==TRUE] <- 0

### 107_6pregs_2}
hogares$ia_2ad <- NA
hogares$ia_2ad[acc_alim5==1] <- 1
hogares$ia_2ad[acc_alim5==2] <- 0
hogares$ia_2ad[is.na(acc_alim5)==TRUE] <- 0

### 108_6pregs_3}
hogares$ia_3ad <- NA
hogares$ia_3ad[acc_alim6==1] <- 1
hogares$ia_3ad[acc_alim6==2] <- 0
hogares$ia_3ad[is.na(acc_alim6)==TRUE] <- 0

### 109_6pregs_4}
hogares$ia_4ad <- NA
hogares$ia_4ad[acc_alim2==1] <- 1
hogares$ia_4ad[acc_alim2==2] <- 0
hogares$ia_4ad[is.na(acc_alim2)==TRUE] <- 0

### 110_6pregs_5}
hogares$ia_5ad <- NA
hogares$ia_5ad[acc_alim7==1] <- 1
hogares$ia_5ad[acc_alim7==2] <- 0
hogares$ia_5ad[is.na(acc_alim7)==TRUE] <- 0

### 111_6pregs_6}
hogares$ia_6ad <- NA
hogares$ia_6ad[acc_alim8==1] <- 1
hogares$ia_6ad[acc_alim8==2] <- 0
hogares$ia_6ad[is.na(acc_alim8)==TRUE] <- 0

### 112_6pregs_1_alim}
hogares$ia_7men <- NA
hogares$ia_7men[acc_alim11==1] <- 1
hogares$ia_7men[acc_alim11==2] <- 0
hogares$ia_7men[is.na(acc_alim11)==TRUE] <- 0

### 113_6pregs_2_alim}
hogares$ia_8men <- NA
hogares$ia_8men[acc_alim12==1] <- 1
hogares$ia_8men[acc_alim12==2] <- 0
hogares$ia_8men[is.na(acc_alim12)==TRUE] <- 0

### 114_6pregs_3_alim}
hogares$ia_9men <- NA
hogares$ia_9men[acc_alim13==1] <- 1
hogares$ia_9men[acc_alim13==2] <- 0
hogares$ia_9men[is.na(acc_alim13)==TRUE] <- 0

### 115_6pregs_4_alim}
hogares$ia_10men <- NA
hogares$ia_10men[acc_alim14==1] <- 1
hogares$ia_10men[acc_alim14==2] <- 0
hogares$ia_10men[is.na(acc_alim14)==TRUE] <- 0

### 116_6pregs_5_alim}
hogares$ia_11men <- NA
hogares$ia_11men[acc_alim15==1] <- 1
hogares$ia_11men[acc_alim15==2] <- 0
hogares$ia_11men[is.na(acc_alim15)==TRUE] <- 0

### 117_6pregs_6_alim}
hogares$ia_12men <- NA
hogares$ia_12men[acc_alim16==1] <- 1
hogares$ia_12men[acc_alim16==2] <- 0
hogares$ia_12men[is.na(acc_alim16)==TRUE] <- 0
#detach(hogares)
dim(hogares)

### 118_ia_escala}
hogares <- orderBy(~+folioviv+foliohog, data=hogares)
hogares= merge(hogares, 
               poblacion2, 
               by=c( "folioviv", "foliohog"),
               all.x = TRUE)

attach(hogares)

### 119_ia_escala_sinm12}
hogares$tot_iaad <- NA
hogares$tot_iaad[id_men12==0] <- 
  ia_1ad[id_men12==0] + 
  ia_2ad[id_men12==0] + 
  ia_3ad[id_men12==0] +
  ia_4ad[id_men12==0] + 
  ia_5ad[id_men12==0] + 
  ia_6ad[id_men12==0]
table(hogares$tot_iaad)
dim(hogares)

### 120_ia_escala_conm12}
hogares$tot_iamen <- NA
hogares$tot_iamen[id_men12==1] <- 
  ia_1ad[id_men12==1] + 
  ia_2ad[id_men12==1] + 
  ia_3ad[id_men12==1] + 
  ia_4ad[id_men12==1] + 
  ia_5ad[id_men12==1] + 
  ia_6ad[id_men12==1] + 
  ia_7men[id_men12==1] + 
  ia_8men[id_men12==1] + 
  ia_9men[id_men12==1] + 
  ia_10men[id_men12==1] + 
  ia_11men[id_men12==1] + 
  ia_12men[id_men12==1]
table(hogares$tot_iamen)
dim(hogares)
#detach(hogares)

### 121_ia_grado}
attach(hogares)
hogares$ins_ali <- NA
hogares$ins_ali[tot_iaad==0 | 
                  tot_iamen==0] <- 0
hogares$ins_ali[(tot_iaad==1 | 
                   tot_iaad==2) | 
                  (tot_iamen==1 | 
                     tot_iamen==2 |
                     tot_iamen==3)] <- 1
hogares$ins_ali[(tot_iaad==3 | tot_iaad==4) | 
                  (tot_iamen==4 | 
                     tot_iamen==5 |
                     tot_iamen==6 |
                     tot_iamen==7)] <- 2
hogares$ins_ali[(tot_iaad==5 | tot_iaad==6) | 
                  (tot_iamen>=8 & 
                     is.na(tot_iamen)==FALSE)] <- 3
table(hogares$ins_ali)
dim(hogares)
detach(hogares)

### 122_ic_alim}
attach(hogares)
hogares$ic_ali <- 0
hogares$ic_ali[ins_ali==2 | 
                 ins_ali==3] <- 1

table(hogares$ins_ali)
table(hogares$ic_ali)
dim(hogares)

hogares <- hogares[, c( 
  "folioviv","foliohog",
  "id_men12",
  "ia_1ad","ia_2ad","ia_3ad","ia_4ad","ia_5ad","ia_6ad","ia_7men",
  "ia_8men","ia_9men","ia_10men","ia_11men","ia_12men",
  "tot_iaad","tot_iamen","ins_ali","ic_ali" )]

hogares <- orderBy(~+folioviv+foliohog, data=hogares)

attach(hogares)
write.csv(hogares, "Bases.Enigh/Tablas_2016/2016_ic_alimentacion_12a.csv",
          row.names = FALSE)
write.dbf(hogares, "Bases.Enigh/Tablas_2016/2016_ic_alimentacion_12a.dbf")

# ------------------------------

### 123_bienestar_ing_auxiliar_a}
gc()
## defrag memory #
#save.image(file="temp.RData")
#rm(list=ls())
#load(file="temp.RData")
#source("Sedesol.Code/load.R.packages.R")
#path.data <- "BasesDatos/ENIGH2016/"

### 124_ingreso_monetario}
trabajos <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/trabajos.dbf",
                     as.is = TRUE)

trabajos <- trabajos[, c( "folioviv", "foliohog", "numren",
                          "id_trabajo", "pres_8")]

trabajos2 <- reshape(trabajos, 
                     idvar = c( "folioviv", "foliohog", "numren"), 
                     timevar = "id_trabajo", direction = "wide")

names(trabajos2)[4:5] <- c("pres_81", "pres_82")

### 125_ingreso_monetario_1empleo}
trabajos2$trab <- 1

attach(trabajos2)

### 126_ingreso_monetario_aguinaldo}
trabajos2$aguinaldo1 <- 0
trabajos2$aguinaldo1[pres_81=="08"] <- 1

### 127_ingreso_monetario_trabsec}
trabajos2$aguinaldo2 <- 0
trabajos2$aguinaldo2[pres_82=="08"] <- 1

attach(trabajos2)
aguinaldo <- trabajos2[,c( "folioviv", "foliohog", "numren",
                           "aguinaldo1" , "aguinaldo2" , "trab")]

aguinaldo <- orderBy(~+folioviv+foliohog+numren, data=trabajos2)

write.dbf(aguinaldo, "Bases.Enigh/Tablas_2016/2016_aguinaldo.dbf")
write.csv(aguinaldo, "Bases.Enigh/Tablas_2016/2016_aguinaldo.csv", 
          row.names=FALSE)
detach(trabajos2)

# --------------------------------

### 128_ingresos_monetarios}
ingresos <-read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/ingresos.dbf",
                    as.is = TRUE)

names(ingresos) <- tolower(names(ingresos))

ingresos <- orderBy(~+folioviv+foliohog+numren, data=ingresos)

ingresos3 <- merge(ingresos,aguinaldo,
                   by.x=c("folioviv","foliohog","numren"),
                   all=TRUE)

index1 <- (ingresos3$clave=="P009" & 
             ingresos3$aguinaldo1!=1 & 
             is.na(ingresos3$clave)==FALSE )

index2 <- (ingresos3$clave=="P016" & 
             ingresos3$aguinaldo2!=1 & 
             is.na(ingresos3$clave)==FALSE )

index <- (index1==FALSE &  index2==FALSE)

ingresos3 <- ingresos3[index,]

rm(ingresos)

ingresos <- ingresos3

attach(ingresos)
rm(ingresos3)

### 129_auxiliar_b, include=FALSE}
gc()
## defrag memory #
#save.image(file="temp.RData")
#rm(list=ls())
#load(file="temp.RData")
#source("Sedesol.Code/load.R.packages.R")
#path.data <- "BasesDatos/ENIGH2016/"

### 130_deflactores_def}
dic15 <- 0.9915096155	
ene16 <- 0.9952905552	
feb16 <- 0.9996486737	
mar16 <- 1.0011208981	
abr16 <- 0.9979505968	
may16 <- 0.9935004643	
jun16 <- 0.9945962676	
jul16 <- 0.9971893899	
ago16 <- 1.0000000000	
sep16 <- 1.0061063849	
oct16 <- 1.0122127699	
nov16 <- 1.0201259756	
dic16 <- 1.0248270555	

### 131_ingresos_deflactacion}
ingresos$ing_6 <- ingresos$ing_6
ingresos$ing_5 <- ingresos$ing_5
ingresos$ing_4 <- ingresos$ing_4
ingresos$ing_3 <- ingresos$ing_3
ingresos$ing_2 <- ingresos$ing_2
ingresos$ing_1 <- ingresos$ing_1

mes_6 <- as.numeric(ingresos$mes_6)
mes_5 <- as.numeric(ingresos$mes_5)
mes_4 <- as.numeric(ingresos$mes_4)
mes_3 <- as.numeric(ingresos$mes_3)
mes_2 <- as.numeric(ingresos$mes_2)
mes_1 <- as.numeric(ingresos$mes_1)

ingresos$ing_6[(is.na(mes_6==2)!=TRUE & 
                  mes_6==2 & 
                  is.na(ingresos$ing_6)!=TRUE)] <- 
  ingresos$ing_6[(is.na(mes_6==2)!=TRUE & 
                    mes_6==2 & 
                    is.na(ingresos$ing_6)!=TRUE)]/feb16

ingresos$ing_6[(is.na(mes_6==3)!=TRUE & 
                  mes_6==3 &
                  is.na(ingresos$ing_6)!=TRUE)] <- 
  ingresos$ing_6[(is.na(mes_6==3)!=TRUE & 
                    mes_6==3 & 
                    is.na(ingresos$ing_6)!=TRUE)]/mar16

ingresos$ing_6[(is.na(mes_6==4)!=TRUE & 
                  mes_6==4 & 
                  is.na(ingresos$ing_6)!=TRUE)] <- 
  ingresos$ing_6[(is.na(mes_6==4)!=TRUE & 
                    mes_6==4 & 
                    is.na(ingresos$ing_6)!=TRUE)]/abr16

ingresos$ing_6[(is.na(mes_6==5)!=TRUE & 
                  mes_6==5 &  
                  is.na(ingresos$ing_6)!=TRUE)] <- 
  ingresos$ing_6[(is.na(mes_6==5)!=TRUE & 
                    mes_6==5 & is.na(ingresos$ing_6)!=TRUE)]/may16

ingresos$ing_6[(is.na(mes_6==6)!=TRUE & 
                  mes_6==6 &  
                  is.na(ingresos$ing_6)!=TRUE)] <- 
  ingresos$ing_6[(is.na(mes_6==6)!=TRUE & 
                    mes_6==6 & 
                    is.na(ingresos$ing_6)!=TRUE)]/jun16

ingresos$ing_5[(is.na(mes_5==3)!=TRUE & 
                  mes_5==3 & 
                  is.na(ingresos$ing_5)!=TRUE)] <- 
  ingresos$ing_5[(is.na(mes_5==3)!=TRUE & 
                    mes_5==3 & 
                    is.na(ingresos$ing_5)!=TRUE)]/mar16

ingresos$ing_5[(is.na(mes_5==4)!=TRUE & 
                  mes_5==4 &
                  is.na(ingresos$ing_5)!=TRUE)] <- 
  ingresos$ing_5[(is.na(mes_5==4)!=TRUE & 
                    mes_5==4 & 
                    is.na(ingresos$ing_5)!=TRUE)]/abr16

ingresos$ing_5[(is.na(mes_5==5)!=TRUE & 
                  mes_5==5 &
                  is.na(ingresos$ing_5)!=TRUE)] <- 
  ingresos$ing_5[(is.na(mes_5==5)!=TRUE & 
                    mes_5==5 & 
                    is.na(ingresos$ing_5)!=TRUE)]/may16

ingresos$ing_5[(is.na(mes_5==6)!=TRUE & 
                  mes_5==6 &
                  is.na(ingresos$ing_5)!=TRUE)] <- 
  ingresos$ing_5[(is.na(mes_5==6)!=TRUE & 
                    mes_5==6 & 
                    is.na(ingresos$ing_5)!=TRUE)]/jun16

ingresos$ing_5[(is.na(mes_5==7)!=TRUE & 
                  mes_5==7 & 
                  is.na(ingresos$ing_5)!=TRUE)] <- 
  ingresos$ing_5[(is.na(mes_5==7)!=TRUE & 
                    mes_5==7 & 
                    is.na(ingresos$ing_5)!=TRUE)]/jul16

ingresos$ing_4[(is.na(mes_4==4)!=TRUE & 
                  mes_4==4 &
                  is.na(ingresos$ing_4)!=TRUE)] <- 
  ingresos$ing_4[(is.na(mes_4==4)!=TRUE & 
                    mes_4==4 & is.na(ingresos$ing_4)!=TRUE)]/abr16

ingresos$ing_4[(is.na(mes_4==5)!=TRUE &
                  mes_4==5 & 
                  is.na(ingresos$ing_4)!=TRUE)] <- 
  ingresos$ing_4[(is.na(mes_4==5)!=TRUE & 
                    mes_4==5 & 
                    is.na(ingresos$ing_4)!=TRUE)]/may16

ingresos$ing_4[(is.na(mes_4==6)!=TRUE & 
                  mes_4==6 & 
                  is.na(ingresos$ing_4)!=TRUE)] <- 
  ingresos$ing_4[(is.na(mes_4==6)!=TRUE & 
                    mes_4==6 & 
                    is.na(ingresos$ing_4)!=TRUE)]/jun16

ingresos$ing_4[(is.na(mes_4==7)!=TRUE & 
                  mes_4==7 & 
                  is.na(ingresos$ing_4)!=TRUE)] <- 
  ingresos$ing_4[(is.na(mes_4==7)!=TRUE & 
                    mes_4==7 & 
                    is.na(ingresos$ing_4)!=TRUE)]/jul16

ingresos$ing_4[(is.na(mes_4==8)!=TRUE & 
                  mes_4==8 & 
                  is.na(ingresos$ing_4)!=TRUE)] <- 
  ingresos$ing_4[(is.na(mes_4==8)!=TRUE & 
                    mes_4==8 & 
                    is.na(ingresos$ing_4)!=TRUE)]/ago16

ingresos$ing_3[(is.na(mes_3==5)!=TRUE & 
                  mes_3==5 & 
                  is.na(ingresos$ing_3)!=TRUE)] <- 
  ingresos$ing_3[(is.na(mes_3==5)!=TRUE & 
                    mes_3==5 & 
                    is.na(ingresos$ing_3)!=TRUE)]/may16

ingresos$ing_3[(is.na(mes_3==6)!=TRUE & 
                  mes_3==6 & 
                  is.na(ingresos$ing_3)!=TRUE)] <- 
  ingresos$ing_3[(is.na(mes_3==6)!=TRUE & 
                    mes_3==6 & 
                    is.na(ingresos$ing_3)!=TRUE)]/jun16

ingresos$ing_3[(is.na(mes_3==7)!=TRUE & 
                  mes_3==7 & 
                  is.na(ingresos$ing_3)!=TRUE)] <-
  ingresos$ing_3[(is.na(mes_3==7)!=TRUE & 
                    mes_3==7 & 
                    is.na(ingresos$ing_3)!=TRUE)]/jul16

ingresos$ing_3[(is.na(mes_3==8)!=TRUE & 
                  mes_3==8 & 
                  is.na(ingresos$ing_3)!=TRUE)] <- 
  ingresos$ing_3[(is.na(mes_3==8)!=TRUE & 
                    mes_3==8 & 
                    is.na(ingresos$ing_3)!=TRUE)]/ago16

ingresos$ing_3[(is.na(mes_3==9)!=TRUE & 
                  mes_3==9 & 
                  is.na(ingresos$ing_3)!=TRUE)] <- 
  ingresos$ing_3[(is.na(mes_3==9)!=TRUE & 
                    mes_3==9 & 
                    is.na(ingresos$ing_3)!=TRUE)]/sep16

ingresos$ing_2[(is.na(mes_2==6)!=TRUE & 
                  mes_2==6 & 
                  is.na(ingresos$ing_2)!=TRUE)] <- 
  ingresos$ing_2[(is.na(mes_2==6)!=TRUE & 
                    mes_2==6 & 
                    is.na(ingresos$ing_2)!=TRUE)]/jun16

ingresos$ing_2[(is.na(mes_2==7)!=TRUE & 
                  mes_2==7 & 
                  is.na(ingresos$ing_2)!=TRUE)] <- 
  ingresos$ing_2[(is.na(mes_2==7)!=TRUE & 
                    mes_2==7 & 
                    is.na(ingresos$ing_2)!=TRUE)]/jul16

ingresos$ing_2[(is.na(mes_2==8)!=TRUE & 
                  mes_2==8 &
                  is.na(ingresos$ing_2)!=TRUE)] <- 
  ingresos$ing_2[(is.na(mes_2==8)!=TRUE & 
                    mes_2==8 & 
                    is.na(ingresos$ing_2)!=TRUE)]/ago16

ingresos$ing_2[(is.na(mes_2==9)!=TRUE & 
                  mes_2==9 & 
                  is.na(ingresos$ing_2)!=TRUE)] <- 
  ingresos$ing_2[(is.na(mes_2==9)!=TRUE & 
                    mes_2==9 & 
                    is.na(ingresos$ing_2)!=TRUE)]/sep16

ingresos$ing_2[(is.na(mes_2==10)!=TRUE & 
                  mes_2==10 & 
                  is.na(ingresos$ing_2)!=TRUE)] <- 
  ingresos$ing_2[(is.na(mes_2==10)!=TRUE & 
                    mes_2==10 & 
                    is.na(ingresos$ing_2)!=TRUE)]/oct16

ingresos$ing_1[(is.na(mes_1==7)!=TRUE & 
                  mes_1==7 & 
                  is.na(ingresos$ing_1)!=TRUE)] <- 
  ingresos$ing_1[(is.na(mes_1==7)!=TRUE & 
                    mes_1==7 & 
                    is.na(ingresos$ing_1)!=TRUE)]/jul16

ingresos$ing_1[(is.na(mes_1==8)!=TRUE & 
                  mes_1==8 & 
                  is.na(ingresos$ing_1)!=TRUE)] <- 
  ingresos$ing_1[(is.na(mes_1==8)!=TRUE & 
                    mes_1==8 & 
                    is.na(ingresos$ing_1)!=TRUE)]/ago16

ingresos$ing_1[(is.na(mes_1==9)!=TRUE & 
                  mes_1==9 & 
                  is.na(ingresos$ing_1)!=TRUE)] <- 
  ingresos$ing_1[(is.na(mes_1==9)!=TRUE & 
                    mes_1==9 & 
                    is.na(ingresos$ing_1)!=TRUE)]/sep16

ingresos$ing_1[(is.na(mes_1==10)!=TRUE & 
                  mes_1==10 & 
                  is.na(ingresos$ing_1)!=TRUE)] <- 
  ingresos$ing_1[(is.na(mes_1==10)!=TRUE & 
                    mes_1==10 &
                    is.na(ingresos$ing_1)!=TRUE)]/oct16

ingresos$ing_1[(is.na(mes_1==11)!=TRUE & 
                  mes_1==11 & 
                  is.na(ingresos$ing_1)!=TRUE)] <- 
  ingresos$ing_1[(is.na(mes_1==11)!=TRUE & 
                    mes_1==11 & 
                    is.na(ingresos$ing_1)!=TRUE)]/nov16

attach(ingresos)

### 132_deflactacion_claves}
ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE & 
                 ingresos$clave=="P008"] <- 
  ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                   ingresos$clave=="P008"]/may16/12

ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                 ingresos$clave=="P015"] <- 
  ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                   ingresos$clave=="P015"]/may16/12

ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                 ingresos$clave=="P009"] <- 
  ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                   ingresos$clave=="P009"]/dic15/12

ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                 ingresos$clave=="P016"] <- 
  ingresos$ing_1[is.na(ingresos$ing_1)!=TRUE &
                   ingresos$clave=="P016"]/dic15/12

### 133_auxiliar_c, include=FALSE}
gc()
## defrag memory #
#save.image(file="temp.RData")
#rm(list=ls())
#load(file="temp.RData")
#source("Sedesol.Code/load.R.packages.R")
#path.data <- "BasesDatos/ENIGH2016/"

### 134_ingreso_mensual}
ingresos$ing_mens <- 
  rowMeans(data.frame(
    ingresos$ing_1, 
    ingresos$ing_2, 
    ingresos$ing_3,
    ingresos$ing_4, 
    ingresos$ing_5, 
    ingresos$ing_6), 
    na.rm = TRUE)
#sum(ingresos$ing_mens, na.rm=TRUE)

### 135_ingresos_monetarios}
attach(ingresos)

for(i in 1:9){
  ing_mon <- 1000+i
  string <- paste("P", 
                  substr(as.character(ing_mon), 2, 4),  
                  sep = "")
  ingresos$ing_mon[(clave==string & 
                      is.na(clave)!=TRUE)] <- 
    ingresos$ing_mens[(clave==string & 
                         is.na(clave)!=TRUE)]
}

for(i in 11:16){
  ing_mon <- 1000+i
  string <- paste("P", 
                  substr(as.character(ing_mon), 2, 4),  
                  sep = "")
  ingresos$ing_mon[(clave==string & 
                      is.na(clave)!=TRUE)] <- 
    ingresos$ing_mens[(clave==string & 
                         is.na(clave)!=TRUE)]
}

for(i in 18:48){
  ing_mon <- 1000+i
  string <- paste("P", 
                  substr(as.character(ing_mon), 2, 4),  
                  sep = "")
  ingresos$ing_mon[(clave==string & 
                      is.na(clave)!=TRUE)]<- 
    ingresos$ing_mens[(clave==string & 
                         is.na(clave)!=TRUE)]
}

for(i in 67:81){
  ing_mon <- 1000+i
  string <- paste("P", 
                  substr(as.character(ing_mon), 2, 4),  
                  sep = "")
  ingresos$ing_mon[(clave==string & 
                      is.na(clave)!=TRUE)] <- 
    ingresos$ing_mens[(clave==string & 
                         is.na(clave)!=TRUE)]
}

### 136_ing_mon1}
ingresos$ing_mon1 <- as.numeric(ingresos$ing_mon)

#detach(ingresos)
#sum(ingresos$ing_mon, na.rm=TRUE)

ingresos <- data.frame(ingresos)
ingresos <- ingresos[, c( "folioviv", "foliohog", "ing_mon1")]

attach(ingresos)
ingresos2 <- aggregate(x=list(ing_mon1), 
                       by=list(folioviv, foliohog),  
                       FUN=sum, na.rm=TRUE)
detach(ingresos)

names(ingresos2)[1:3] <- c( "folioviv", "foliohog", "ing_mon")

dim(ingresos2)

ingresos2 <- orderBy(~+folioviv+foliohog, data=ingresos2)

write.csv(ingresos2, "Bases.Enigh/Tablas_2016/2016_ingresocorriente.csv",
          row.names = FALSE)
write.dbf(ingresos2, "Bases.Enigh/Tablas_2016/2016_ingresocorriente.dbf")

# -------------------------------

### *** ###

### 137_nomonetariopersona}
library("foreign")
library("doBy")

nomonetariopersona <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/gastospersona.dbf",
                               as.is = TRUE)

names(nomonetariopersona) <- tolower(names(nomonetariopersona))

names(nomonetariopersona)[7] <- "frecuenciap"

nomonetarioper <- orderBy(~+folioviv+foliohog,
                          data=nomonetariopersona)

nomonetariohogar <- 
  read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/gastoshogar.dbf",
           as.is = TRUE)

names(nomonetariohogar) <- tolower(names(nomonetariohogar))

nomonetariohog <- orderBy(~+folioviv+foliohog,
                          data=nomonetariohogar)
nomonetariohog <- data.frame(nomonetariohog, 
                             numren=NA, 
                             origen_rem=NA, 
                             inst=NA )
dim(nomonetariohog)
 
nomonetario <- merge(nomonetariohog, nomonetarioper, all=TRUE)
nomonetario$decena <- substr(nomonetario$folioviv, 8, 8)
nomonetario$decena <- as.numeric(nomonetario$decena)
### ^^^ ###

### 138_deflactores_semanal_alimentos}
d11w07 <- 0.9985457696	
d11w08 <- 1.0000000000	
d11w09 <- 1.0167932672	
d11w10 <- 1.0199415214	
d11w11 <- 1.0251086805	

### 139_deflactores_semanal_alcohol}
d12w07 <- 0.9959845820	
d12w08 <- 1.0000000000	
d12w09 <- 1.0066744829	
d12w10 <- 1.0087894741	
d12w11 <- 1.0100998490	

### 140_deflactores_semanal_vestido}
d2t05 <- 0.9920067602	
d2t06 <- 0.9948005139	
d2t07 <- 0.9986462366	
d2t08 <- 1.0053546946	

### 141_deflactores_semanal_vivienda}
d3m07 <- 1.0017314941	
d3m08 <- 1.0000000000	
d3m09 <- 0.9978188915	
d3m10 <- 1.0133832055	
d3m11 <- 1.0358543632	

### 142_deflactores_semanal_limpieza}
d42m07 <- 0.9936894797	
d42m08 <- 1.0000000000	
d42m09 <- 1.0041605121	
d42m10 <- 1.0056376169	
d42m11 <- 1.0087477433	

### 143_deflactores_accesorios}
d42t05 <- 0.9932545544	
d42t06 <- 0.9960501122	
d42t07 <- 0.9992833306	
d42t08 <- 1.0032660430	

### 144_deflactores_muebles}
d41s02 <- 1.0081456317	
d41s03 <- 1.0057381027	
d41s04 <- 1.0038444337	
d41s05 <- 1.0025359940	

### 145_deflactores_salud}
d51t05 <- 0.9948500567	
d51t06 <- 0.9974422922	
d51t07 <- 1.0000318717	
d51t08 <- 1.0028179937	

### 146_deflactores_trasnportepublico}
d611w07 <- 0.9998162514	
d611w08 <- 1.0000000000	
d611w09 <- 1.0010465683	
d611w10 <- 1.0030038907	
d611w11 <- 1.0040584480	

### 147_deflactores_transporte_men}
d6m07 <- 0.9907765708	
d6m08 <- 1.0000000000	
d6m09 <- 1.0049108739	
d6m10 <- 1.0097440440	
d6m11 <- 1.0137147031	

### 148_deflactores_transporte_sem}
d6s02 <- 0.9749314912	
d6s03 <- 0.9796636466	
d6s04 <- 0.9851637735	
d6s05 <- 0.9917996695	

### 149_deflactores_educacion}
d7m07 <- 0.9997765641	
d7m08 <- 1.0000000000	
d7m09 <- 1.0128930818	
d7m10 <- 1.0131744455	
d7m11 <- 1.0158805031	

### 150_deflactores_accesorios_men}
d23m07 <- 0.9923456541	
d23m08 <- 1.0000000000	
d23m09 <- 1.0029207372	
d23m10 <- 1.0029710948	
d23m11 <- 1.0057155806	

### 151_deflactores__accesorios_trim}
d23t05 <- 0.9913748727	
d23t06 <- 0.9950229966	
d23t07 <- 0.9984221305	
d23t08 <- 1.0019639440	

### 152_inpc_sem}
dINPCs02 <- 0.9973343817	
dINPCs03 <- 0.9973929361	
dINPCs04 <- 0.9982238506	
dINPCs05 <- 1.0006008794	

gc()
dim(nomonetario)

### 153_deflactor_proceso}
nomonetario$gasnomon <- nomonetario$gas_nm_tri/3
nomonetario$gasnomon[is.na(nomonetario$gasnomon)==TRUE] <- 0

gc()

nomonetario$esp[nomonetario$tipo_gasto=="G4"] <- 1
nomonetario$reg[nomonetario$tipo_gasto=="G5"] <- 1
nomonetario$reg[nomonetario$tipo_gasto=="G6"] <- 1

index1 <- nomonetario$tipo_gasto=="G2" 
index2 <- nomonetario$tipo_gasto=="G3" 
index3 <- nomonetario$tipo_gasto=="G7" 

indext <- (index1==FALSE & index2==FALSE & index3==FALSE)

nomonetario <- nomonetario[indext,]

gc()
dim(nomonetario)

### 154_nomonetario}
index1 <- ((nomonetario$frecuenciap=="9" | 
              nomonetario$frecuenciap=="NA" | 
              nomonetario$frecuenciap=="0") & 
             nomonetario$tipo_gasto=="G5")

index1[is.na(index1)==TRUE] <- FALSE

index2 <- ((nomonetario$frecuencia=="5" |
              nomonetario$frecuencia=="6" |
              nomonetario$frecuencia=="0" | 
              nomonetario$frecuencia=="NA") &
             nomonetario$tipo_gasto=="G5")

index2[is.na(index2)==TRUE] <- FALSE

indext <- (index1==FALSE & index2==FALSE)

nomonetario <- nomonetario[indext,]

attach(nomonetario)

### 155_gasto_alimentos}
for(i in 1:222){
  gasto_ali <- 1000+i
  string <- paste("A", 
                  substr(as.character(gasto_ali), 2, 4),  
                  sep = "")
  nomonetario$ali_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string &                                                                 is.na(clave)!=TRUE)]
}

gc()
dim(nomonetario)

for(i in 242:247){
  gas_ali <- 1000+i
  string <- paste("A", 
                  substr(as.character(gas_ali), 2, 4),  
                  sep = "")
  nomonetario$ali_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$ali_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/d11w08

gc()

nomonetario$ali_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/d11w08

nomonetario$ali_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/d11w08

nomonetario$ali_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/d11w09

nomonetario$ali_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/d11w09

nomonetario$ali_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/d11w09

nomonetario$ali_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/d11w10

nomonetario$ali_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/d11w10

nomonetario$ali_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/d11w10

nomonetario$ali_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ali_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/d11w11

gc()

### 156_Gasto_alcoholtabaco}
for(i in 223:241){
  gas_alctab <- 1000+i
  string=paste("A", 
               substr(as.character(gas_alctab), 2, 4),  
               sep = "")
  nomonetario$alta_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$alta_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d12w08

nomonetario$alta_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d12w08

nomonetario$alta_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d12w08

nomonetario$alta_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d12w09

nomonetario$alta_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d12w09

nomonetario$alta_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d12w09

nomonetario$alta_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d12w10

nomonetario$alta_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d12w10

nomonetario$alta_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d12w10

nomonetario$alta_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$alta_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d12w11

gc()

### 157_gasto_vestidoycalzado}
for(i in 1:122){
  gas_vescal <- 1000+i
  string=paste("H", substr(as.character(gas_vescal), 2, 4),  
               sep = "")
  nomonetario$veca_nm[(clave==string &
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$veca_nm[(clave=="H136" & 
                       is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="H136" & 
                          is.na(clave)!=TRUE)]

nomonetario$veca_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d2t05

nomonetario$veca_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d2t05

nomonetario$veca_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d2t06

nomonetario$veca_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d2t06

nomonetario$veca_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d2t06

nomonetario$veca_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d2t07

nomonetario$veca_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d2t07

nomonetario$veca_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d2t07

nomonetario$veca_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d2t08

nomonetario$veca_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$veca_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d2t08

gc()

### 158_gasto_vivienda}
for(i in 1:16){
  gas_viv <- 1000+i
  string=paste("G", 
               substr(as.character(gas_viv), 2, 4), 
               sep = "")
  nomonetario$viv_nm[(clave==string &
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 1:4){
  gas_viv <- 1000+i
  string=paste("R", 
               substr(as.character(gas_viv), 2, 4),  
               sep = "")
  nomonetario$viv_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$viv_nm[(clave=="R013" & 
                      is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="R013" & 
                          is.na(clave)!=TRUE)]

nomonetario$viv_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/d3m07

nomonetario$viv_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/d3m07

nomonetario$viv_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/d3m08

nomonetario$viv_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/d3m08

nomonetario$viv_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/d3m08

nomonetario$viv_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/d3m09

nomonetario$viv_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/d3m09

nomonetario$viv_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/d3m09

nomonetario$viv_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/d3m10

nomonetario$viv_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$viv_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/d3m10

gc()

### 159_gasto_limpieza}
for(i in 1:24){
  gas_limp <- 1000+i
  string=paste("C", 
               substr(as.character(gas_limp), 2, 4),  
               sep = "")
  nomonetario$lim_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$lim_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/d42m07

nomonetario$lim_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/d42m07

nomonetario$lim_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/d42m08

nomonetario$lim_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/d42m08

nomonetario$lim_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/d42m08

nomonetario$lim_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/d42m09

nomonetario$lim_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/d42m09

nomonetario$lim_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/d42m09

nomonetario$lim_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/d42m10

nomonetario$lim_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$lim_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/d42m10


gc()

### 160_gasto_blancos}
for(i in 1:26){
  gas_cris <- 1000+i
  string=paste("I", 
               substr(as.character(gas_cris), 2, 4),  
               sep = "")
  nomonetario$cris_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$cris_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d42t05

nomonetario$cris_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d42t05

nomonetario$cris_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d42t06

nomonetario$cris_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d42t06

nomonetario$cris_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d42t06

nomonetario$cris_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d42t07

nomonetario$cris_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d42t07

nomonetario$cris_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d42t07

nomonetario$cris_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d42t08

nomonetario$cris_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cris_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d42t08

gc()

### 161_gasto_muebles}
for(i in 1:37){
  gas_endom <- 1000+i
  string=paste("K", 
               substr(as.character(gas_endom), 2, 4), 
               sep = "")
  nomonetario$ens_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$ens_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/d41s02

nomonetario$ens_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/d41s02

nomonetario$ens_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/d41s03

nomonetario$ens_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/d41s03

nomonetario$ens_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/d41s03

nomonetario$ens_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/d41s04

nomonetario$ens_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/d41s04

nomonetario$ens_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/d41s04

nomonetario$ens_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/d41s05

nomonetario$ens_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$ens_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/d41s05

gc()

### 162_gasto_salud}
for(i in 1:72){
  gas_salud <- 1000+i
  string=paste("J", 
               substr(as.character(gas_salud), 2, 4),  
               sep = "")
  nomonetario$sal_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$sal_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/d51t05

nomonetario$sal_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/d51t05

nomonetario$sal_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/d51t06

nomonetario$sal_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/d51t06

nomonetario$sal_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/d51t06

nomonetario$sal_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/d51t07

nomonetario$sal_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/d51t07

nomonetario$sal_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/d51t07

nomonetario$sal_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/d51t08

nomonetario$sal_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$sal_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/d51t08

gc()

### 163_gasto_transporte}
for(i in 1:7){
  gas_transpub <- 1000+i
  string=paste("B", 
               substr(as.character(gas_transpub), 2, 4),  
               sep = "")
  nomonetario$tpub_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$tpub_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d611w08

nomonetario$tpub_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d611w08

nomonetario$tpub_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d611w08

nomonetario$tpub_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d611w09

nomonetario$tpub_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d611w09

nomonetario$tpub_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d611w09

nomonetario$tpub_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d611w10

nomonetario$tpub_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d611w10

nomonetario$tpub_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d611w10

nomonetario$tpub_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tpub_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d611w11

gc()

### 164_gasto_transporte_foraneo}
for(i in 1:18){
  gas_transfor <- 1000+i
  string=paste("M", 
               substr(as.character(gas_transfor), 2, 4),  sep = "")
  nomonetario$tfor_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- nomonetario$gasnomon[(clave==string & 
                                                                         is.na(clave)!=TRUE)]
}

gc()

for(i in 7:14){
  gas_transfor <- 1000+i
  string=paste("F", 
               substr(as.character(gas_transfor), 2, 4),  
               sep = "")
  nomonetario$tfor_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$tfor_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d6s02

nomonetario$tfor_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d6s02

nomonetario$tfor_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d6s03

nomonetario$tfor_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d6s03

nomonetario$tfor_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d6s03

nomonetario$tfor_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d6s04

nomonetario$tfor_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d6s04

nomonetario$tfor_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d6s04

nomonetario$tfor_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d6s05

nomonetario$tfor_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$tfor_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d6s05

gc()

### 165_gasto_comunicaciones}
for(i in 1:6){
  gas_com <- 1000+i
  string=paste("F", 
               substr(as.character(gas_com), 2, 4),  
               sep = "")
  nomonetario$com_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 5:8){
  gas_com <- 1000+i
  string=paste("R", 
               substr(as.character(gas_com), 2, 4),  
               sep = "")
  nomonetario$com_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 10:11){
  gas_com <- 1000+i
  string=paste("R", 
               substr(as.character(gas_com), 2, 4), 
               sep = "")
  nomonetario$com_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$com_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/d6m07

nomonetario$com_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/d6m07

nomonetario$com_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/d6m08

nomonetario$com_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/d6m08

nomonetario$com_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/d6m08

nomonetario$com_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/d6m09

nomonetario$com_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/d6m09

nomonetario$com_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/d6m09

nomonetario$com_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/d6m10

nomonetario$com_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$com_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/d6m10

gc()

### 166_gasto_educacion}
for(i in 1:34){
  gas_edurec <- 1000+i
  string=paste("E", 
               substr(as.character(gas_edurec), 2, 4), 
               sep = "")
  nomonetario$edre_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 134:135){
  gas_edurec <- 1000+i
  string=paste("H", 
               substr(as.character(gas_edurec), 2, 4), 
               sep = "")
  nomonetario$edre_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 1:29){
  gas_edurec <- 1000+i
  string=paste("L", 
               substr(as.character(gas_edurec), 2, 4),  
               sep = "")
  nomonetario$edre_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 3:5){
  gas_edurec <- 1000+i
  string=paste("N", 
               substr(as.character(gas_edurec), 2, 4),
               sep = "")
  nomonetario$edre_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$edre_nm[(clave=="R009" & 
                       is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="R009" &
                          is.na(clave)!=TRUE)]

nomonetario$edre_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d7m07

nomonetario$edre_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d7m07

nomonetario$edre_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d7m08

nomonetario$edre_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d7m08

nomonetario$edre_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d7m08

nomonetario$edre_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d7m09

nomonetario$edre_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d7m09

nomonetario$edre_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d7m09

nomonetario$edre_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d7m10

nomonetario$edre_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edre_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d7m10

gc()

### 167_gasto_educacion_basica}
for(i in 2:3){
  gas_edubas <- 1000+i
  string=paste("E", 
               substr(as.character(gas_edubas), 2, 4), 
               sep = "")
  nomonetario$edba_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 134:135){
  gas_edubas <- 1000+i
  string=paste("H", 
               substr(as.character(gas_edubas), 2, 4), 
               sep = "")
  nomonetario$edba_nm[(clave==string &
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string &
                            is.na(clave)!=TRUE)]
}

nomonetario$edba_nm[(decena==1 &
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d7m07

nomonetario$edba_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d7m07

nomonetario$edba_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d7m08

nomonetario$edba_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d7m08

nomonetario$edba_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d7m08

nomonetario$edba_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d7m09

nomonetario$edba_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d7m09

nomonetario$edba_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d7m09

nomonetario$edba_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d7m10

nomonetario$edba_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$edba_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d7m10

gc()

### 168_gasto_cuidado_personal}
for(i in 1:26){
  gas_cuiper <- 1000+i
  string=paste("D", 
               substr(as.character(gas_cuiper), 2, 4),  
               sep = "")
  nomonetario$cuip_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$cuip_nm[(clave=="H132" & 
                       is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="H132" & 
                          is.na(clave)!=TRUE)]

nomonetario$cuip_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d23m07

nomonetario$cuip_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d23m07

nomonetario$cuip_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d23m08

nomonetario$cuip_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d23m08

nomonetario$cuip_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d23m08

nomonetario$cuip_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d23m09

nomonetario$cuip_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d23m09

nomonetario$cuip_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d23m09

nomonetario$cuip_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d23m10

nomonetario$cuip_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$cuip_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d23m10

gc()

### 169_gasto_accesorios}
for(i in 123:131){
  gas_accper <- 1000+i
  string=paste("H", 
               substr(as.character(gas_accper), 2, 4),  
               sep = "")
  nomonetario$accp_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$accp_nm[(clave=="H133" & 
                       is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="H133" & 
                          is.na(clave)!=TRUE)]

nomonetario$accp_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/d23t05

nomonetario$accp_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/d23t05

nomonetario$accp_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/d23t06

nomonetario$accp_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/d23t06

nomonetario$accp_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/d23t06

nomonetario$accp_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/d23t07

nomonetario$accp_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/d23t07

nomonetario$accp_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/d23t07

nomonetario$accp_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/d23t08

nomonetario$accp_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$accp_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/d23t08

gc()

### 170_gastos_otros}
for(i in 1:2){
  gas_otro <- 1000+i
  string=paste("N", 
               substr(as.character(gas_otro), 2, 4), 
               sep = "")
  nomonetario$otr_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 6:16){
  gas_otro <- 1000+i
  string <- paste("N", 
                  substr(as.character(gas_otro), 2, 4), 
                  sep = "")
  nomonetario$otr_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

for(i in 901:915){
  gas_otro <- 1000+i
  string <- paste("T", 
                  substr(as.character(gas_otro), 2, 4),
                  sep = "")
  nomonetario$otr_nm[(clave==string & 
                        is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

nomonetario$otr_nm[(clave=="R012" & 
                      is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="R012" & 
                          is.na(clave)!=TRUE)]

nomonetario$otr_nm[(decena==1 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==1 & 
                        is.na(decena)!=TRUE)]/dINPCs02

nomonetario$otr_nm[(decena==2 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==2 & 
                        is.na(decena)!=TRUE)]/dINPCs02

nomonetario$otr_nm[(decena==3 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==3 & 
                        is.na(decena)!=TRUE)]/dINPCs03

nomonetario$otr_nm[(decena==4 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==4 & 
                        is.na(decena)!=TRUE)]/dINPCs03

nomonetario$otr_nm[(decena==5 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==5 & 
                        is.na(decena)!=TRUE)]/dINPCs03

nomonetario$otr_nm[(decena==6 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==6 & 
                        is.na(decena)!=TRUE)]/dINPCs04

nomonetario$otr_nm[(decena==7 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==7 & 
                        is.na(decena)!=TRUE)]/dINPCs04

nomonetario$otr_nm[(decena==8 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==8 & 
                        is.na(decena)!=TRUE)]/dINPCs04

nomonetario$otr_nm[(decena==9 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==9 & 
                        is.na(decena)!=TRUE)]/dINPCs05

nomonetario$otr_nm[(decena==0 & 
                      is.na(decena)!=TRUE)] <- 
  nomonetario$otr_nm[(decena==0 & 
                        is.na(decena)!=TRUE)]/dINPCs05

gc()

### 171_gastos_regalos}
for(i in 901:915){
  gas_reg <- 1000+i
  string <- paste("T", 
                  substr(as.character(gas_reg), 2, 4),  
                  sep = "")
  nomonetario$reda_nm[(clave==string & 
                         is.na(clave)!=TRUE)] <- 
    nomonetario$gasnomon[(clave==string & 
                            is.na(clave)!=TRUE)]
}

gc()

nomonetario$reda_nm[(clave=="N013" & 
                       is.na(clave)!=TRUE)] <- 
  nomonetario$gasnomon[(clave=="N013" & 
                          is.na(clave)!=TRUE)]

nomonetario$reda_nm[(decena==1 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==1 & 
                         is.na(decena)!=TRUE)]/dINPCs02

nomonetario$reda_nm[(decena==2 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==2 & 
                         is.na(decena)!=TRUE)]/dINPCs02

nomonetario$reda_nm[(decena==3 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==3 & 
                         is.na(decena)!=TRUE)]/dINPCs03

nomonetario$reda_nm[(decena==4 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==4 & 
                         is.na(decena)!=TRUE)]/dINPCs03

nomonetario$reda_nm[(decena==5 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==5 & 
                         is.na(decena)!=TRUE)]/dINPCs03

nomonetario$reda_nm[(decena==6 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==6 & 
                         is.na(decena)!=TRUE)]/dINPCs04

nomonetario$reda_nm[(decena==7 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==7 & 
                         is.na(decena)!=TRUE)]/dINPCs04

nomonetario$reda_nm[(decena==8 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==8 & 
                         is.na(decena)!=TRUE)]/dINPCs04

nomonetario$reda_nm[(decena==9 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==9 & 
                         is.na(decena)!=TRUE)]/dINPCs05

nomonetario$reda_nm[(decena==0 & 
                       is.na(decena)!=TRUE)] <- 
  nomonetario$reda_nm[(decena==0 & 
                         is.na(decena)!=TRUE)]/dINPCs05

detach(nomonetario)

#mean(nomonetario$ali_nm,na.rm=TRUE)
#mean(nomonetario$alta_nm,na.rm=TRUE) 
#mean(nomonetario$veca_nm,na.rm=TRUE) 
#mean(nomonetario$viv_nm,na.rm=TRUE)
#mean(nomonetario$lim_nm,na.rm=TRUE)
#mean(nomonetario$cris_nm,na.rm=TRUE)
#mean(nomonetario$ens_nm,na.rm=TRUE) 
#mean(nomonetario$sal_nm,na.rm=TRUE) 
#mean(nomonetario$tpub_nm,na.rm=TRUE) 
#mean(nomonetario$tfor_nm,na.rm=TRUE) 
#mean(nomonetario$com_nm,na.rm=TRUE) 
#mean(nomonetario$edre_nm,na.rm=TRUE) 
#mean(nomonetario$edba_nm,na.rm=TRUE) 
#mean(nomonetario$cuip_nm,na.rm=TRUE) 
#mean(nomonetario$accp_nm,na.rm=TRUE) 
#mean(nomonetario$otr_nm,na.rm=TRUE)
#mean(nomonetario$reda_nm,na.rm=TRUE)

indexesp <- (nomonetario$esp==1 & is.na(nomonetario$esp)!=TRUE)

nomonetarioesp <- nomonetario[indexesp,]

dim(nomonetarioesp)

### 172_gastos_pagos_especie}
attach(nomonetarioesp)
nomonetarioesp2 <- aggregate(x=list(ali_nm, alta_nm, 
                                    veca_nm,  viv_nm,  lim_nm, 
                                    cris_nm, ens_nm, sal_nm, 
                                    tpub_nm, tfor_nm, com_nm, 
                                    edre_nm, edba_nm, cuip_nm, 
                                    accp_nm, otr_nm, reda_nm), 
                             by=list( folioviv, foliohog),  
                             FUN=sum, na.rm=TRUE)
detach(nomonetarioesp)

names(nomonetarioesp2 )[1:19] <- c("folioviv", "foliohog","ali_nme", 
                                   "alta_nme", "veca_nme", "viv_nme",
                                   "lim_nme", "cris_nme", "ens_nme",
                                   "sal_nme", "tpub_nme", "tfor_nme",
                                   "com_nme", "edre_nme", "edba_nme",
                                   "cuip_nme", "accp_nme", "otr_nme",
                                   "reda_nme")

nomonetarioesp2 <- orderBy(~+folioviv+foliohog, data=nomonetarioesp2)

indexreg <- (nomonetario$reg==1 & is.na(nomonetario$reg)!=TRUE)
nomonetarioreg <- nomonetario[indexreg,]

gc()

### 173_gastos_regalos}
attach(nomonetarioreg)
nomonetarioreg2 <- aggregate(x=list(
  ali_nm, alta_nm, veca_nm, viv_nm,
  lim_nm, cris_nm, ens_nm, sal_nm,
  tpub_nm, tfor_nm, com_nm, edre_nm,
  edba_nm, cuip_nm, accp_nm, otr_nm,
  reda_nm), 
  by=list( folioviv, foliohog), 
  FUN=sum, na.rm=TRUE)
detach(nomonetarioreg)

names(nomonetarioreg2 )[1:19] <- c( "folioviv","foliohog","ali_nmr",
                                    "alta_nmr","veca_nmr","viv_nmr",
                                    "lim_nmr","cris_nmr","ens_nmr",
                                    "sal_nmr","tpub_nmr","tfor_nmr",
                                    "com_nmr","edre_nmr","edba_nmr",
                                    "cuip_nmr","accp_nmr","otr_nmr",
                                    "reda_nmr")

nomonetarioreg2 <- orderBy(~+folioviv+foliohog, data=nomonetarioreg2)

dim(nomonetarioreg2)

head(nomonetarioreg2)

### **** ###

write.csv(nomonetarioreg2, "Bases.Enigh/Tablas_2016/2016_nomonetarioreg2.csv", 
          row.names = FALSE)
write.dbf(nomonetarioreg2, "Bases.Enigh/Tablas_2016/2016_nomonetarioreg2.dbf")

# --------------------------------------
# --------------------------------------

gc()

### 174_ingreso_corriente_total}
library("foreign")
concentrado <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/concentradohogar.dbf",
                        as.is = TRUE)

names(concentrado) <- tolower(names(concentrado))

concentrado <- concentrado[ c( "folioviv","foliohog","factor",
                               "tam_loc" , "tot_integ")]

concentrado <- orderBy(~+folioviv+foliohog, data=concentrado)

dim(concentrado)
colnames(concentrado)

### ***** ###
ingresos2 <- read.csv("Bases.Enigh/Tablas_2016/2016_ingresocorriente.csv",
                      header = TRUE)

dim(ingresos2)
colnames(ingresos2)

concentrado <- concentrado[,c("folioviv","foliohog","tot_integ")]

concentrado1 <- merge(concentrado,
                      ingresos2,
                      by.x = c("folioviv","foliohog"),
                      by.y = c("folioviv","foliohog"),
                      all = TRUE)

colnames(concentrado1)

concentrado1 <- orderBy(~+folioviv+foliohog, data=concentrado1)

dim(concentrado1)
dim(nomonetarioesp2)

concentrado2 <- merge(concentrado1,
                      nomonetarioesp2,
                      by.x=c("folioviv","foliohog"),
                      by.y=c("folioviv","foliohog"),
                      all = TRUE)

concentrado2 <- orderBy(~+folioviv+foliohog, data=concentrado2)

concentrado3 <- merge(concentrado2,
                      nomonetarioreg2,
                      by.x=c( "folioviv","foliohog"),
                      by.y=c( "folioviv","foliohog"),
                      all = TRUE)

concentrado3 <- orderBy(~+folioviv+foliohog, data=concentrado3)

concentrado3$rururb <- 0

concentrado3$rururb[concentrado3$tam_loc=="4"] <- 1

colnames(concentrado3)
pago_especie <- concentrado3[,c("ali_nme", "alta_nme", "veca_nme",
                               "viv_nme", "lim_nme", "cris_nme",
                               "ens_nme", "sal_nme", "tpub_nme",
                               "tfor_nme", "com_nme", "edre_nme",
                               "cuip_nme", "accp_nme", "otr_nme")]

dim(pago_especie)

concentrado3$pago_esp <- rowSums(pago_especie, na.rm = TRUE)

concentrado3$reg_esp <- rowSums(
  data.frame(concentrado3$ali_nmr,concentrado3$alta_nmr,
             concentrado3$veca_nmr,concentrado3$viv_nmr,
             concentrado3$lim_nmr,concentrado3$cris_nmr,
             concentrado3$ens_nmr,concentrado3$sal_nmr,
             concentrado3$tpub_nmr,concentrado3$tfor_nmr,
             concentrado3$com_nmr,concentrado3$edre_nmr,
             concentrado3$cuip_nmr,concentrado3$accp_nmr,
             concentrado3$otr_nmr), 
  na.rm = TRUE)

concentrado3$nomon <- rowSums(data.frame(concentrado3$pago_esp, concentrado3$reg_esp ), na.rm = TRUE)
concentrado3$ict <- rowSums(data.frame(concentrado3$ing_mon, concentrado3$nomon ), na.rm = TRUE)
concentrado3 <- orderBy(~+folioviv+foliohog, data=concentrado3)

#mean(concentrado3$pago_esp)
#mean(concentrado3$reg_esp)
#mean(concentrado3$nomon)
#mean(concentrado3$ict)

write.csv(concentrado3, "Bases.Enigh/Tablas_2016/2016_ingresocorriente_total.csv", 
          row.names = FALSE)
write.dbf(concentrado3, "Bases.Enigh/Tablas_2016/2016_ingresocorriente_total.dbf")

#### ****** ###

### 175_bienestar_tamaniohogar}
poblacion1 <- read.dbf("Bases.Enigh/Tablas_2016/2016_poblacion.dbf",
                       as.is = TRUE)

names(poblacion1) <- tolower(names(poblacion1))

poblacion2 <- as.numeric(poblacion1$parentesco)

index  <- ( (poblacion2>=400 & poblacion2<500) |
              (poblacion2>=700 & poblacion2 <800) )

index <- (index==FALSE)

poblacion <- poblacion1[index,]

poblacion$ind <- 1


attach(poblacion)

poblacion2 <- aggregate(x=list(ind), 
                        by=list(folioviv, foliohog),
                        FUN=sum, 
                        na.rm=TRUE)

detach(poblacion)

names(poblacion2)[1:3] <- c("folioviv",  "foliohog", "tot_ind")

poblacion <- merge(poblacion, poblacion2, 
                   by=c( "folioviv",  "foliohog"), 
                   all.x = TRUE)

# Escalas de equivalencia
attach(poblacion)
poblacion$n_05 <- NA
poblacion$n_05[edad>=0 & edad<=5] <- 1
poblacion$n_05[(edad>5 & is.na(edad)==FALSE)] <- 0
table(poblacion$n_05)

poblacion$n_6_12 <- NA
poblacion$n_6_12[edad>=6 & edad<=12] <- 1
poblacion$n_6_12[((edad>12 | edad<6) & is.na(edad)==FALSE)] <- 0
table(poblacion$n_6_12)

poblacion$n_13_18 <- NA
poblacion$n_13_18[edad>=13 & edad<=18] <- 1
poblacion$n_13_18[((edad>18 | edad<13) & is.na(edad)==FALSE)] <- 0
table(poblacion$n_13_18)


poblacion$n_19 <- NA
poblacion$n_19[edad>=19] <- 1
poblacion$n_19[((edad<19) & is.na(edad)==FALSE)] <- 0
table(poblacion$n_19)
detach(poblacion)

attach(poblacion)
### tamhogesc
poblacion$tamhogesc <- n_05*.7031

poblacion$tamhogesc[n_6_12==1 & is.na(n_6_12)==FALSE] <- 
  n_6_12[n_6_12==1 & is.na(n_6_12)==FALSE]*.7382

poblacion$tamhogesc[n_13_18==1 & is.na(n_13_18)==FALSE] <- 
  n_13_18[n_13_18==1 & is.na(n_13_18)==FALSE]*.7057

poblacion$tamhogesc[n_19==1 & is.na(n_19)==FALSE] <- 
  n_19[n_19==1 & is.na(n_19)==FALSE]*.9945

poblacion$tamhogesc[tot_ind==1 & is.na(tot_ind)==FALSE] <- 1

detach(poblacion)

gc()

attach(poblacion)

poblacion2 <- aggregate(x=list(tamhogesc), 
                        by=list( folioviv, foliohog),
                        FUN=sum, 
                        na.rm=TRUE)

detach(poblacion)

names(poblacion2 )[1:3] <- c( "folioviv", "foliohog","tamhogesc")

poblacion2 <- orderBy(~+folioviv+foliohog, data=poblacion2)

write.csv(poblacion2, "Bases.Enigh/Tablas_2016/2016_tamhogesc.csv", 
          row.names = FALSE)
write.dbf(poblacion2, "Bases.Enigh/Tablas_2016/2016_tamhogesc.dbf")

gc()

### 176_bienestar_ingresos_pc}
### *** Revisar ###
library("foreign")
ingresos <- read.dbf("Bases.Enigh/Tablas_2016/2016_ingresocorriente_total.dbf",
                     as.is = TRUE)

poblacion2 <- read.dbf("Bases.Enigh/Tablas_2016/2016_tamhogesc.dbf",
                       as.is = TRUE)

names(ingresos) <- tolower(names(ingresos))

ingresos2 <- merge(ingresos, poblacion2, 
                   by=c( "folioviv","foliohog"),
                   all = TRUE)

ingresos2 <- orderBy(~+folioviv+foliohog, data=ingresos2)

dim(ingresos2)
colnames(ingresos2)

summary(as.numeric(ingresos2$ict))
summary(as.numeric(ingresos2$tamhogesc))

ingresos2$ictpc <- ingresos2$ict/ingresos2$tamhogesc
ingresos2$factorp <- ingresos2$factor*ingresos2$tot_integ

dim(poblacion2)
dim(ingresos)

attach(ingresos2)

### 177_plb_m}
lp1_urb <- 1310.94
lp1_rur <- 933.20

attach(ingresos2)
ingresos2$plb_m <- NA
ingresos2$plb_m[ictpc<lp1_urb & rururb==0] <- 1
ingresos2$plb_m[ictpc>=lp1_urb & rururb==0] <- 0
ingresos2$plb_m[ictpc<lp1_rur & rururb==1] <- 1
ingresos2$plb_m[ictpc>=lp1_rur & rururb==1] <- 0
table(ingresos2$plb_m)
detach(ingresos2)

### 178_plb}
lp2_urb <- 2660.40
lp2_rur <- 1715.57

attach(ingresos2)
ingresos2$plb <- NA
ingresos2$plb[(ictpc<lp2_urb & rururb==0)] <- 1
ingresos2$plb[(ictpc>=lp2_urb & rururb==0)] <- 0
ingresos2$plb[(ictpc<lp2_rur & rururb==1)] <- 1
ingresos2$plb[(ictpc>=lp2_rur & rururb==1)] <- 0
table(ingresos2$plb)
#detach(ingresos2)

attach(ingresos2)
colnames(ingresos2)

ingresos2 <- orderBy(~+folioviv+foliohog, data=ingresos2)

write.csv(ingresos2, "Bases.Enigh/Tablas_2016/2016_bienestar_ingreso.csv",
          row.names = FALSE)
write.dbf(ingresos2, "Bases.Enigh/Tablas_2016/2016_bienestar_ingreso.dbf")

write.csv(ingresos2, "Bases.Enigh/2016_bienestar_ingreso.csv",
          row.names = FALSE)

detach(ingresos2)
dim(ingresos2)

# ===========================================================================
#               Variables 
# ===========================================================================

rm(list=ls())

load("MDI.Scripts/Datos.Modelo/mdi_variables_modelo.RData")

# 0_concentradohogar}
concentradohogar <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/concentradohogar.dbf", 
                             as.is = TRUE)
dim(concentradohogar)

#  0_creacion}
aux_var <- c("tam_loc",
             "sexo_jefe","edad_jefe","educa_jefe",
             "tot_integ","p12_64","p65mas","remesas",
             "ing_cor")
hogares_agr <- concentradohogar[,c("folioviv","foliohog",aux_var)]
colnames(hogares_agr) <- c("FOLIOVIV","FOLIOHOG",aux_var)
dim(hogares_agr)

write.csv(hogares_agr,file="Bases.Enigh/2016_a_hogares_enigh.csv")
rm(concentradohogar)
rm(aux_var)

# 0_poblacion_jefe}
poblacion <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf", 
                      as.is = TRUE)
dim(poblacion)
colnames(poblacion) <- toupper(colnames(poblacion))

# Jefe y conyuge
poblacion$es_jefe <- 0
poblacion$es_cony <- 0
poblacion[which(poblacion$PARENTESCO==101),"es_jefe"] <- 1
poblacion[which(poblacion$PARENTESCO==201),"es_cony"] <- 1
table(poblacion[,c("es_jefe","es_cony")])

poblacion_jefe <- poblacion[which( poblacion$es_jefe==1 | poblacion$es_cony==1),]
dim(poblacion_jefe)

# Escolaridad Jefe y Conyuge
poblacion_jefe$p_esc3 <- 0
poblacion_jefe[which( (poblacion$PARENTESCO==101 |poblacion$PARENTESCO==201) &
                        poblacion$EDAD>=12 & 
                        ( poblacion$NIVELAPROB>=2 & poblacion$NIVELAPROB<3 ) ),"p_esc3"] <- 1

poblacion_jefe$p_esc5b <- 0
poblacion_jefe[which( (poblacion$PARENTESCO==101 |poblacion$PARENTESCO==201) &
                        poblacion$EDAD>=12 & 
                        poblacion$NIVELAPROB>=3 ),"p_esc5b"] <- 1

# Agregago
aux_var <- c("p_esc3","p_esc5b")
poblacion_jefe <- aggregate( x = poblacion_jefe[,aux_var],
                             by = list(poblacion_jefe$FOLIOVIV,poblacion_jefe$FOLIOHOG),
                             FUN = max )
colnames(poblacion_jefe) <- c("FOLIOVIV","FOLIOHOG",aux_var)
dim(poblacion_jefe)
rm(poblacion)
rm(aux_var)

# 0_poblacion_agr}
poblacion <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf", 
                      as.is = TRUE)
dim(poblacion)
colnames(poblacion) <- toupper(colnames(poblacion))

# Grupos de edad
poblacion$int0a12 <- 0
poblacion$int12a64 <- 0
poblacion$int65a98 <- 0
poblacion[which(poblacion$EDAD>0 & poblacion$EDAD<12 ),"int0a12"] <- 1  
poblacion[which(poblacion$EDAD>=12 & poblacion$EDAD<=64 ),"int12a64"] <- 1  
poblacion[which(poblacion$EDAD>=65 & poblacion$EDAD<=98 ),"int65a98"] <- 1  

# Mujeres 
poblacion$muj12a49 <- 0
poblacion[which( poblacion$SEXO==2 & 
                   (poblacion$EDAD>=12 & poblacion$EDAD<49) ),"muj12a49"] <- 1  

# Seguro Popular 
poblacion$seg_pop <- 0
poblacion[which( poblacion$SEGPOP==1 ),"seg_pop"] <- 1  

# Atencion Medica
poblacion$ss <- 0
poblacion[which( poblacion$ATEMED==1 ),"ss"] <- 1  

# Agregago
aux_var <- c("int0a12","int12a64","int65a98","muj12a49","seg_pop","ss")
poblacion_agr <- aggregate( x = poblacion[,aux_var],
                            by = list(poblacion$FOLIOVIV,poblacion$FOLIOHOG),
                            FUN = sum )
colnames(poblacion_agr) <- c("FOLIOVIV","FOLIOHOG",aux_var)
dim(poblacion_agr)
rm(poblacion)
rm(aux_var)

# 0_hogares}
hogares <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/hogares.dbf", 
                    as.is = TRUE)
dim(hogares)
colnames(hogares) <- toupper(colnames(hogares))

# Seguridad Alimentaria 3 (Desayuno, comida o cena)
table(hogares$ACC_ALIM5)
hogares$seg_alim2 <- 0
hogares[which(hogares$ACC_ALIM5==1),"seg_alim2"] <- 1

# Seguridad Alimentaria 3 (Comida)
table(hogares$ACC_ALIM2)
hogares$seg_alim3 <- 0
hogares[which(hogares$ACC_ALIM2==1),"seg_alim3"] <- 1

# Seguridad Alimentaria a (Comida)
table(hogares$ACC_ALIM8)
hogares$seg_alim_a <- 0
hogares[which(hogares$ACC_ALIM8==1),"seg_alim_a"] <- 1

# Refrigerador
table(hogares$NUM_REFRI)
hogares$sin_refri <- 0
hogares[which( hogares$NUM_REFRI==0 ),"sin_refri"] <- 1
table(hogares$sin_refri)

# Vehiculos
hogares$num_vehi <- hogares$NUM_AUTO + hogares$NUM_VAN + hogares$NUM_PICKUP
table(hogares$num_vehi)
hogares$sin_vehi <- 0
hogares[which( hogares$num_vehi==0 ),"sin_vehi"] <- 1
table(hogares$sin_vehi)

# Computadora
table(hogares$NUM_COMPU)
hogares$sin_compu <- 0
hogares[which( hogares$NUM_COMPU==0 ),"sin_compu"] <- 1
table(hogares$sin_compu)

# Video & DVD
hogares$num_vidvd <- hogares$NUM_DVD + hogares$NUM_VIDEO
table(hogares$num_vidvd)
hogares$sin_vidvd <- 0
hogares[which( hogares$num_vidvd==0 ),"sin_vidvd"] <- 1
table(hogares$sin_vidvd)

# Telefono
table(hogares$TELEFONO)
hogares$sin_telef <- 1
hogares[which( hogares$TELEFONO==1 ),"sin_telef"] <- 0
table(hogares$sin_telef)

# Horno (microondas)
table(hogares$NUM_MICRO)
hogares$sin_horno <- 0
hogares[which( hogares$NUM_MICRO==0 ),"sin_horno"] <- 1
table(hogares$sin_horno)

# Agregago
aux_var <- c("seg_alim2","seg_alim3","seg_alim_a","sin_refri","sin_vehi","sin_vidvd","sin_compu","sin_telef","sin_horno")
hogares_agr_agr <- aggregate( x = hogares[,aux_var],
                              by = list(hogares$FOLIOVIV,hogares$FOLIOHOG),
                              FUN = max )
colnames(hogares_agr_agr) <- c("FOLIOVIV","FOLIOHOG",aux_var)
summary(hogares_agr_agr$seg_alim2)
summary(hogares_agr_agr$sin_refri)
summary(hogares_agr_agr$sin_vehi)
summary(hogares_agr_agr$sin_compu)
summary(hogares_agr_agr$sin_vidvd)
summary(hogares_agr_agr$sin_telef)
summary(hogares_agr_agr$sin_horno)

rm(hogares)

# 0_trabajos}
trabajos <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/trabajos.dbf", 
                     as.is = TRUE)
dim(trabajos)
colnames(trabajos) <- toupper(colnames(trabajos))

poblacion <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/poblacion.dbf", 
                      as.is = TRUE)
dim(poblacion)
colnames(poblacion) <- toupper(colnames(poblacion))

trabajos <- merge(trabajos,
                  poblacion[,c("FOLIOVIV","FOLIOHOG",
                               "NUMREN", "EDAD","PARENTESCO")],
                  by=c("FOLIOVIV","FOLIOHOG","NUMREN"),
                  all.x=TRUE)

# Trabajo subordinado
trabajos$trab_sub <- 0
trabajos[which( trabajos$EDAD >= 12 & 
                  trabajos$ID_TRABAJO==1 &
                  #( trabajos$ID_TRABAJO==1 | trabajos$ID_TRABAJO==2 ) & 
                  trabajos$SUBOR==1 ),"trab_sub"] <- 1

table(trabajos$trab_sub)

# Trabajo independiendte
trabajos$trab_ind <- 0
trabajos[which( trabajos$EDAD >= 12 & 
                  trabajos$ID_TRABAJO==1 &
                  #( trabajos$ID_TRABAJO==1 | trabajos$ID_TRABAJO==2 ) & 
                  trabajos$INDEP==1 ),"trab_ind"] <- 1

table(trabajos$trab_ind)

# Trabajo subordinado sin pago
trabajos$trab_s_pago <- 0
trabajos[which( trabajos$EDAD >= 12 & 
                  trabajos$ID_TRABAJO==1 &
                  #( trabajos$ID_TRABAJO==1 | trabajos$ID_TRABAJO==2 ) & 
                  trabajos$SUBOR==1 & 
                  (trabajos$PAGO==2 | trabajos$PAGO==3) ),"trab_s_pago"] <- 1

table(trabajos$trab_s_pago)

# Trabajo independiendte / Jefe del hogar
trabajos$jtrab_ind <- 0
trabajos[which( trabajos$EDAD >= 12 & 
                  trabajos$PARENTESCO==101 & 
                  trabajos$ID_TRABAJO==1 &
                  #( trabajos$ID_TRABAJO==1 | trabajos$ID_TRABAJO==2 ) & 
                  trabajos$INDEP==1 ),"jtrab_ind"] <- 1

table(trabajos$jtrab_ind)

# Agregago
aux_var <- c("trab_sub","trab_ind","jtrab_ind","trab_s_pago")
trabajos_agr <- aggregate( x = trabajos[,aux_var],
                           by = list(trabajos$FOLIOVIV,trabajos$FOLIOHOG),
                           FUN = sum )
colnames(trabajos_agr) <- c("FOLIOVIV","FOLIOHOG",aux_var)
summary(trabajos_agr$trab_sub)
summary(trabajos_agr$trab_ind)
summary(trabajos_agr$trab_s_pago)

rm(trabajos)
rm(poblacion)

# 0_viviendas}
viviendas <- read.dbf("Bases.Datos.Original/ENIGH2016_Coneval/Microdatos/viviendas.dbf", 
                      as.is = TRUE)
dim(viviendas)
colnames(viviendas) <- toupper(colnames(viviendas))

# Vivienda propia
table(viviendas$TENENCIA)

viviendas$viv_prop <- 0
viviendas[which( viviendas$TENENCIA==3 | viviendas$TENENCIA==4 ),"viv_prop"] <- 1

# Vivienda rentada
viviendas$viv_rent <- 0
viviendas[which( viviendas$TENENCIA==1 ),"viv_rent"] <- 1

# Piso firme
table(viviendas$MAT_PISOS)

viviendas$piso_fir <- 0
viviendas[which( viviendas$MAT_PISOS==2 ),"piso_fir"] <- 1

# Piso con recubrimiento
viviendas$piso_rec <- 0
viviendas[which( viviendas$MAT_PISOS==3 ),"piso_rec"] <- 1

# Piso con recubrimiento
viviendas$tot_cuar <- viviendas$NUM_CUARTO

# Combustible
table(viviendas$COMBUSTIBL)
viviendas$combustible <- 0
viviendas[which( viviendas$COMBUSTIBL==1 | viviendas$COMBUSTIBL==2 ),"combustible"] <- 1
table(viviendas$combustible)

#Escusado exclusivo con descarga de agua
table(viviendas[,c("EXCUSADO","USO_COMPAR","SANIT_AGUA")])
viviendas$bao13 <- 0
viviendas[which( viviendas$EXCUSADO==1 &
                   viviendas$USO_COMPAR==2 & 
                   viviendas$SANIT_AGUA== 1 ),"bao13"] <- 1
table(viviendas$bao13)

# Agregacion
aux_var <- c("viv_prop","viv_rent","piso_fir","piso_rec","tot_cuar","combustible","bao13")

viviendas_agr <- viviendas[,c("FOLIOVIV",aux_var)]

rm(viviendas)

# v01_indice_de_dependencia_demografica} 
# v01 depdemog

# Se obtiene directamente de `poblacion_agr`
poblacion_agr$depdemog <- 0
poblacion_agr[which(poblacion_agr$int12a64>0),"depdemog"] <-
  (poblacion_agr[which(poblacion_agr$int12a64>0),"int0a12"] +
     poblacion_agr[which(poblacion_agr$int12a64>0),"int65a98"]) /
  poblacion_agr[which(poblacion_agr$int12a64>0),"int12a64"]
summary(poblacion_agr$depdemog)

aux_var <- c("int0a12","int12a64","int65a98","depdemog")

hogares_agr <- merge(hogares_agr,
                     poblacion_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)

# v02_numero_mujeres_12y49} 
# v02 muj12a49
# Trabajamos con la tabla `pobracion_agr`
summary(poblacion_agr$muj12a49)

aux_var <- c("muj12a49")

hogares_agr <- merge(hogares_agr,
                     poblacion_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)


# v03_total_personas} 
# v03 ltot_per
# Trabajamos con la tabla `hogares_agr`
summary(hogares_agr$tot_integ)
summary(hogares_agr$int0a12 + hogares_agr$int12a64 + hogares_agr$int65a98)
hogares_agr$tot_per <- hogares_agr$int0a12 + 
  hogares_agr$int12a64 + hogares_agr$int65a98
hogares_agr$ltot_per <- log(as.numeric(hogares_agr$tot_per))
colnames(hogares_agr)

# v04_educacion_jefe} 
# v04 p_esc3, p_esc4 and p_esc5
# Trabajamos con la tabla `poblacion_jefe`
table(poblacion_jefe$p_esc3)

hogares_agr <- merge(hogares_agr,
                     poblacion_jefe[,c("FOLIOVIV","FOLIOHOG","p_esc3")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$p_esc3)

# v05_educacion_jefecony_prom}
# v05 p_esc5b
# Trabajamos con la tabla `poblacion_jefe`
table(poblacion_jefe$p_esc5b)

hogares_agr <- merge(hogares_agr,
                     poblacion_jefe[,c("FOLIOVIV","FOLIOHOG","p_esc5b")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$p_esc5b)

# v06_trabajo_subordinado} 
# v06 trab_sub (numero)
# Traajamos con la tabla `trabajos_agr`
summary(trabajos_agr$trab_sub)

aux_var <- c("trab_sub")

hogares_agr <- merge(hogares_agr,
                     trabajos_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)

# v07_trabajo_independiente} 
# v07 trab_ind (numero)
# Traajamos con la tabla `trabajos_agr`
summary(trabajos_agr$trab_ind)
summary(trabajos_agr$trab_s_pago)

aux_var <- c("trab_ind")

hogares_agr <- merge(hogares_agr,
                     trabajos_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)

# v08_trabajo_subordinado_sinpago} 
# v08 trab_s_pag (numero)
# Traajamos con la tabla `trabajos_agr`
summary(trabajos_agr$trab_s_pago)

aux_var <- c("trab_s_pago")

hogares_agr <- merge(hogares_agr,
                     trabajos_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)

# v09_seguridad_alimentaria_1} 
# v09 seg_alim2 (indicadora)
# Trabajamos con la tabla `hogares_agr_agr`
table(hogares_agr_agr$seg_alim2)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","seg_alim2")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$seg_alim2)

# v10_Seguridad_alimentaria_a} 
# v10 seg_alim3 (indicadora)
# Trabajamos con la tabla `hogares_agr_agr`
table(hogares_agr_agr$seg_alim3)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","seg_alim3")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$seg_alim3)

# v11_seguridad_alimentaria_conjunta} 
# v11 seg_alim_a2 (indicadora)
# Trabajamos con la tabla `hogares_agr_agr`
# Trabajamos con la tabla `hogares_agr_agr`
table(hogares_agr_agr$seg_alim_a)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","seg_alim_a")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$seg_alim_a)

# v12_seguro_popular} 
# v12 seg_pop (numero)
table(poblacion_agr$seg_pop)

aux_var <- c("seg_pop")

hogares_agr <- merge(hogares_agr,
                     poblacion_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)

# v13_servicio_medico} 
# v13 ss (indicadora)
table(poblacion_agr$ss)

aux_var <- c("ss")

hogares_agr <- merge(hogares_agr,
                     poblacion_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"))
dim(hogares_agr)
colnames(hogares_agr)

# v14_trabind_ss}
# v14 ssjtrabind (indicadora)
table(hogares_agr$ss)
table(trabajos_agr$jtrab_ind)

hogares_agr <- merge(hogares_agr,
                     trabajos_agr[,c("FOLIOVIV","FOLIOHOG","jtrab_ind")],
                     by=c("FOLIOVIV","FOLIOHOG"))

hogares_agr$ssjtrabind <- 0
hogares_agr[which( hogares_agr$ss==1 & 
                     hogares_agr$jtrab_ind==1 ),"ssjtrabind"] <- 1
table(hogares_agr$ssjtrabind)

# v15_con_remesas} 
# v15 con_remesas
summary(hogares_agr$remesas)

hogares_agr$con_remesas <- 0
hogares_agr[which( hogares_agr$remesas>0 ),"con_remesas"] <- 1
table(hogares_agr$con_remesas)

# v16_vivenda_propia} 
# v16 viv_prop (indicadora)
# Trabajamos con `viviendas_agr`
table(viviendas_agr$viv_prop)

hogares_agr <- merge(hogares_agr,
                     viviendas_agr[,c("FOLIOVIV","viv_prop")],
                     by=c("FOLIOVIV"))
table(hogares_agr$viv_prop)

# v17_vivenda_rantada} 
# v17 viv_rent (indicadora)
# Trabajamos con `viviendas_agr`
table(viviendas_agr$viv_rent)

hogares_agr <- merge(hogares_agr,
                     viviendas_agr[,c("FOLIOVIV","viv_rent")],
                     by=c("FOLIOVIV"))
table(hogares_agr$viv_rent)

# v18_tot_cuartos} 
# v18 tot_cuar (numero)
table(viviendas_agr$tot_cuar)

hogares_agr <- merge(hogares_agr,
                     viviendas_agr[,c("FOLIOVIV","tot_cuar")],
                     by=c("FOLIOVIV"))
table(hogares_agr$tot_cuar)

# v19_tipo_banio} 
# v19 bao1, bao2 and bao3 (indicadoras)

# v20_banio_exclusivo} 
# v20 bao13 (indicadoras)
# Trabajamos con la tabla `viviendas_agr`
table(viviendas_agr$bao13)

hogares_agr <- merge(hogares_agr,
                     viviendas_agr[,c("FOLIOVIV","bao13")],
                     by=c("FOLIOVIV"))
table(hogares_agr$bao13)

# v21_piso_firme} 
# v21 piso_fir & piso_rec (indicadoras)
# Trabajamos con `viviendas_agr`
table(viviendas_agr$piso_fir)

hogares_agr <- merge(hogares_agr,
                     viviendas_agr[,c("FOLIOVIV","piso_fir")],
                     by=c("FOLIOVIV"))
table(hogares_agr$piso_fir)

# v22_piso_firme} 
# v22 piso_fir & piso_rec (indicadoras)
# Trabajamos con `viviendas_agr`
table(viviendas_agr$piso_rec)

hogares_agr <- merge(hogares_agr,
                     viviendas_agr[,c("FOLIOVIV","piso_rec")],
                     by=c("FOLIOVIV"))
table(hogares_agr$piso_rec)

# v223<_combustible} 
# v223< combustible (indicadoras)
# Trabajamos con la tabla `viviendas_agr`
table(viviendas_agr$combustible)

hogares_agr <- merge(x=hogares_agr,
                     y=viviendas_agr[,c("FOLIOVIV","combustible")],
                     by=c("FOLIOVIV"))
table(hogares_agr$combustible)

# v24<_sin_refrigerador} 
# v24< sin_refri (indicadoras)
# Trabajamos con la base `hogares_agr_agr`
table(hogares_agr_agr$sin_refri)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","sin_refri")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$sin_refri)

# v25_sin_vehiculo} 
# v25 sin_vehi (indicadoras)
# Trabajamos con la base `hogares_agr_agr`
table(hogares_agr_agr$sin_vehi)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","sin_vehi")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$sin_vehi)

# v26_sin_compu} 
# v26 sin_compu (indicadoras)
# Trabajamos con la base `hogares_agr_agr`
table(hogares_agr_agr$sin_compu)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","sin_compu")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$sin_compu)

# v27_sin_vhs_dvd} 
# v27 sin_vidvd (indicadoras)
# Trabajamos con la base `hogares_agr_agr`
table(hogares_agr_agr$sin_vidvd)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","sin_vidvd")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$sin_vidvd)

# v28_sin_telefono} 
# v28 sin_telef (indicadoras)
# Trabajamos con la base `hogares_agr_agr`
table(hogares_agr_agr$sin_telef)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","sin_telef")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$sin_telef)

# v29_sin_horno} 
# v29 sin_horno (indicadoras)
# Trabajamos con la base `hogares_agr_agr`
table(hogares_agr_agr$sin_horno)

hogares_agr <- merge(hogares_agr,
                     hogares_agr_agr[,c("FOLIOVIV","FOLIOHOG","sin_horno")],
                     by=c("FOLIOVIV","FOLIOHOG"))
table(hogares_agr$sin_horno)
dim(hogares_agr)

# ict} 
# ict - Ingresp Corriente Total
# Trabajamos con la base `2016_a_bienestar_ingreso`
ict_agr <- read.csv("Bases.Enigh/2016_bienestar_ingreso.csv", header=TRUE)
dim(ict_agr)

colnames(ict_agr) <- c("FOLIOVIV","FOLIOHOG","factor","tam_loc","rururb","tamhogesc","ict","ictpc","plb_m","plb")

table(ict_agr[,c("plb_m","plb")])

aux_var <- c("factor","rururb","tamhogesc","ict","ictpc") 
ict_agr$ict <- ict_agr$ict + 1
ict_agr$ictpc <- ict_agr$ictpc + 1

hogares_agr <- merge(hogares_agr,
                     ict_agr[,c("FOLIOVIV","FOLIOHOG",aux_var)],
                     by=c("FOLIOVIV","FOLIOHOG"),
                     x.all=TRUE)
summary(hogares_agr$ictpc)

# num_cat}
hogares_agr[,var_enighcuis_num] <- lapply(hogares_agr[,var_enighcuis_num],as.numeric)

hogares_agr[,var_enighcuis_cat] <- lapply(hogares_agr[,var_enighcuis_cat],factor)

# exportacion}
write.csv(hogares_agr,file="Bases.Enigh/hogares_enigh_agr.csv")
colnames(hogares_agr)
dim(hogares_agr)
rm(list=ls())
gc()
