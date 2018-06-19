
rm(list=ls())

source("Sedesol.Code/load.R.packages.R")

path.data <- "Bases4Analysis/"

# **Bienestar de ingreso**
  
bienestar_ingreso <- read.dbf(paste(path.data,"2016_bienestra_ingreso.dbf",
                                    sep=""),
                              as.is = TRUE)

foliovivhog_cols <- c("folioviv","foliohog")

bienestar_ingreso$foliovivhog <- do.call(paste, 
                                         c(bienestar_ingreso[foliovivhog_cols], 
                                           sep=""))

head(bienestar_ingreso)

# **Carencia y mediciones en los hogares**
  
poblacion_carencia <- read.dbf(paste(path.data,"2016_poblacion_carencia.dbf",
                                     sep=""),
                               as.is = TRUE)

foliovivhog_cols <- c("folioviv","foliohog")

poblacion_carencia$foliovivhog <- do.call(paste, 
                                          c(poblacion_carencia[foliovivhog_cols], 
                                            sep=""))

head(poblacion_carencia)

#**Poblacion para analisis**
  
poblacion_analisis <- merge(
  bienestar_ingreso[,c("foliovivhog","factor","tam_loc", "rururb",
                       "tamhogesc","ict","ictpc","plb_m","plb")],                          
  poblacion_carencia[,c("foliovivhog","numren","edad","anac_e",
                        "inas_esc","antec_esc","niv_ed","ic_rezedu",
                        "hli","sexo","discap","ic_asalud","pea","jub",
                        "ss_dir","par","jef_ss","cony_ss","hijo_ss",
                        "s_salud","pam","ic_segsoc","tot_resid",
                        "num_cuarto","icv_pisos","icv_techos","icv_muros",
                        "icv_hac","ic_cv","isb_agua","isb_dren","isb_luz",
                        "isb_combus","ic_sbv","id_men","ia_1ad","ia_2ad",
                        "ia_3ad","ia_4ad","ia_5ad","ia_6ad","ia_7men",
                        "ia_8men","ia_9men","ia_10men","ia_11men","ia_12men",
                        "tot_iaad","tot_iamen","ins_ali","ic_ali","ent",
                        "i_privacio","pobreza","pobreza_e","pobreza_m","vul_car",
                        "vul_ing","no_pobv","carencias","carencias3","cuadrantes",
                        "prof_b1","prof_bm1","profun","int_pob","int_pobe","int_vulcar",
                        "int_caren")],
  by="foliovivhog")

head(poblacion_analisis)

dim(poblacion_analisis)
sum(poblacion_analisis$factor)
hist(poblacion_analisis$factor,50)

write.csv(poblacion_analisis, paste(path.data,"2016_a_analisis_tabla.csv",sep=""), row.names = TRUE)
write.dbf(poblacion_analisis, paste(path.data,"2016_a_analisis_tabla.csv",sep=""))
rm("poblacion_analisis")
rm("bienestar_ingreso")
rm("poblacion_carencia")
rm("foliovivhog_cols")

#**Tablas de `entrenamiento` y `prueba`**
  
analisis_tabla <- read.csv(paste(path.data,"2016_a_analisis_tabla.csv",sep=""),
                           header=TRUE, sep=",", na.strings="NA", dec=".")
dim(analisis_tabla)
#[1] 177111     78

colnames(analisis_tabla)
#[1] "X"           "foliovivhog" "factor"      "tam_loc"     "rururb"     
#[6] "tamhogesc"   "ict"         "ictpc"       "plb_m"       "plb"        
#[11] "numren"      "edad"        "anac_e"      "inas_esc"    "antec_esc"  
#[16] "niv_ed"      "ic_rezedu"   "hli"         "sexo"        "discap"     
#[21] "ic_asalud"   "pea"         "jub"         "ss_dir"      "par"        
#[26] "jef_ss"      "cony_ss"     "hijo_ss"     "s_salud"     "pam"        
#[31] "ic_segsoc"   "tot_resid"   "num_cuarto"  "icv_pisos"   "icv_techos" 
#[36] "icv_muros"   "icv_hac"     "ic_cv"       "isb_agua"    "isb_dren"   
#[41] "isb_luz"     "isb_combus"  "ic_sbv"      "id_men"      "ia_1ad"     
#[46] "ia_2ad"      "ia_3ad"      "ia_4ad"      "ia_5ad"      "ia_6ad"     
#[51] "ia_7men"     "ia_8men"     "ia_9men"     "ia_10men"    "ia_11men"   
#[56] "ia_12men"    "tot_iaad"    "tot_iamen"   "ins_ali"     "ic_ali"     
#[61] "ent"         "i_privacio"  "pobreza"     "pobreza_e"   "pobreza_m"  
#[66] "vul_car"     "vul_ing"     "no_pobv"     "carencias"   "carencias3" 
#[71] "cuadrantes"  "prof_b1"     "prof_bm1"    "profun"      "int_pob"    
#[76] "int_pobe"    "int_vulcar"  "int_caren"

# Creación de factores
analisis_tabla$tam_loc <- as.factor(analisis_tabla$tam_loc)
analisis_tabla$rururb <- as.factor(analisis_tabla$rururb)
analisis_tabla$ent <- as.factor(analisis_tabla$ent)
summary(analisis_tabla[,c("tam_loc","rururb","ent")])
table(analisis_tabla[,c("tam_loc","rururb")])
analisis_tabla$estrato1 <- analisis_tabla$tam_loc
analisis_tabla$estrato1 <- as.factor(analisis_tabla$estrato1)
table(analisis_tabla$estrato1)
summary(analisis_tabla[,c("estrato1","ent")])
table(analisis_tabla[,c("estrato1","ent")])

library("data.table")
library("sampling")

set.seed(1)

analisis_tabla_sampling <- as.data.table(analisis_tabla[,c("foliovivhog","estrato1","ent")])

summary(analisis_tabla_sampling)

head(analisis_tabla_sampling)
setkey(analisis_tabla_sampling, estrato1, ent)

analisis_tabla_estratos <- analisis_tabla_sampling[, .N, keyby = list(estrato1, ent)]
dim(analisis_tabla_estratos)

# Select sample
s <- data.table(strata(d, c("age", "lc"), rep(30, 10), "srswor"))

# Simple Random Sampling
#sample_id <- sample(seq_len(nrow(analisis_tabla)), size=1000, 
#                    replace = FALSE, prob = NULL)
#sample_id <- sample(rows, size=1000, replace = FALSE, prob = NULL)

#**Atributos de segmentacion**

# CEPAL
# Los 19 atributos de acuerdo al modelo actual de la Sedesol
# 1.  J_esc0 - Nivel de escolaridad del jefe del hogar - Sin escolaridad
# 2.  J_esc0a6 - Nivel de escolaridad del jefe del hogar - Primaria incompleta
# 3.  J_esc6a9 - Nivel de escolaridad del jefe del hogar - Secundaria incompleta
# 4.  Con_ss - Acceso a la seguridad social en el rubro salud
# 5.  Con_sp - Acceso al seguro popular
# 6.  Adol_trabaja - Adolecentes en el hogar trabajando
# 7.  Perceptor - Perceptores del hogar
# 8.  sin_basu - falta de recolección de basura
# 9.  Bao13 - Excusado exclusivo con descarga directa
#10.  sin_combus - Uso de leña o carbón
#11.  inttechpiso - Piso de tierra más techo balndo endeble
#12.  Exc_lengua - NUmero de hablantes exclusivamente de lengua indígena
#13.  remesa - Recepción de dinero proveniente de otros países
#14.  sin_refri - Falta de refrigerador
#15.  sin_vehi - Falta de vehículo de transporte
#16.  sin_compu - Falta de computadora
#17.  sin_telef - Falta de teléfono
#18.  intdvdhorno - Sin video o DVD + sin horno
#19.  Inseg_alim - inseguridad alimentaria

# SEDESOL
# Los 29 atributos de condiciones socioeconomicas y demograficas de ls hogares
#
# --- Escolaridad
#
# 1.  p_esc_3 - escolaridad promedio del jefes del hogar es entre 6-9 años
# 2.  p_esc5b - escolaridad promedio del jefes del hogar es al menos 9 años
#
# ---Demográficas
#
# 3.*  depdemog - Cociente de dependientes economicos de 16-64 años
# 4.*  muj15-49 - Numero de mujeres de 15-49 años
# 5.*  itotper - logaritmo al numero total de integrantes del hogar
#
# --- Laborales
#
# 6.*  trab_sub - Integrantes número del hogar con trabajo subordinado
# 7.*  trab_ind  - Integrantes número del hogar con trabajo independiente
# 8.*  trab_s_pago -  Integrantes número del hogar con trabajo subordinado sin pago
#
# --- Servicios de Salud
#
# 9.*  seg_pop -  Integrantes número con acceso al seguro popular
#10.  ss - Al menos una persona con acceso a seguro médico del trabajo
#11.  sstrabind - Trabajo independiente y una persona con acceso a servicio medico derivado del trabajo
#
# --- Caracteristicas de la Vivienda
#
#12.  piso_fir - Mayor parte de la vivienda con piso firme
#13.  piso_rec - Mayor parte de la vivienda con recubrimiento
#14.  viv_prop - Indicadora de vivienda propia
#15.  viv_rent - Indicadora de vivienda rentada
#16.  tot_cuar- Total de cuartos en la vivienda
#
# --- Servicios de la vivienda
#
#17.  combustuble - Uso de leña o carbón
#18.  bao13 - Escusado exclusivo con descarga directa
#
# --- Enseres Domésticos
#
#19.  sin_refir - Sin refrigerador
#20.  sin_telef - Sin telefono
#21.  sin_vehi - Sin vehículo de transporte
#22.  sin_vidvd - Sin video o dvd
#23.  sin_compu - Sin computadora
#24.  sin_horno - Sin horno electríco o microhondas
#
# --- Alimentación 
#
#25.  seg_alim2 - Si algun adulto dejo de desayunar, comer o cenar
#26.  seg_alim3 - Si algun adulto solo comio una vez en el dia
#27. seg_alim_a - Union de las dos anteriores
#
# --- Remesas
#
#28. remesas - Si el hogar recibe ingresos del extranjero
#
# --- Contexto Municipal de Rezago
#
#29.* irs - Indica el nivel de rezago social a nivel municipal

atributos_fijos <- c("ent","tam_loc","rururb","tamhogesc")

atributos_segme <- c(# Jefe del hogar
                     "sexo","edad",
                     # Demografica
                     "tamhogesc",
                     # laboral
                     "pea","jub",
                     # Escolaridad
                     "numren",
                     "anac_e","inas_esc",
                     "antec_esc","niv_ed","ic_rezedu","hli",
                     # Discapacidad
                     "discap",
                     # Acceso salud
                     "ic_asalud",
                     # Seguridad social
                     "ss_dir","par","jef_ss","cony_ss","hijo_ss",
                     "s_salud","pam","ic_segsoc",
                     # Vivienda
                     "num_cuarto","icv_pisos","icv_techos","icv_muros",
                     "icv_hac","ic_cv",
                     # Vivienda Servicios
                     "isb_agua","isb_dren","isb_luz","isb_combus","ic_sbv",
                     # Integrantes menores o mayores de 18 años
                     "id_men", "ia_1ad", "tot_iaad","tot_iamen",
                     # Inseguridad alimentaria y privación
                     "ins_ali","ic_ali","i_privacio")

atributos_ingre <- c(# Ingreso corriente total
                    "ict",
                    # Ingreso corriente percapita
                    "ictpc",
                    # Hogares bajo LMB
                    "plb_m",
                    # Hogares bajo LB
                    "plb")

#row.names(analisis_tabla_train) <- analisis_tabla_train$foliovivhog 
#head(analisis_tabla_train)

length(atributos)

# Lineas de Bienestar
LB <- array(NaN, dim=c(2,2))
dim(LB)

colnames(LB) <- c("rural","urbano")
rownames(LB) <- c("lbm","lb")

LB["lbm","rural"] <- 933.20 # lp1_rur <- rual lbm
LB["lb","rural"] <- 1715.57 # lp2_rur <- rual lb
LB["lbm","urbano"] <- 1310.94 # lp1_urb <- urbano lbm
LB["lb","urbano"] <- 2660.40 # lp2_urb <- urbano lb
LB

# 
