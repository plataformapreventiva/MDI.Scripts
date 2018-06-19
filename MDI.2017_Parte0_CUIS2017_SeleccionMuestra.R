rm(list=ls())

# Base de la muestra

se_integrante_cuis <- read.csv("../Bases.Datos.Original/CUIS/CUIS/cuis_muestra100.csv",head=TRUE)
                      #read.spss("../Bases.Datos.Original/CUIS/CUIS/se_integrante_cuis.sav", to.data.frame=TRUE)

dim(se_integrante_cuis)

head(se_integrante_cuis)

LLAVE_HOGAR_H.df <- as.data.frame(unique(se_integrante_cuis$LLAVE_HOGAR_H))

LLAVE_HOGAR_H.df$IND_SAM <- 1

colnames(LLAVE_HOGAR_H.df) <- c("LLAVE_HOGAR_H","IND_SAM")

head(LLAVE_HOGAR_H.df)

dim(LLAVE_HOGAR_H.df)

write.csv(LLAVE_HOGAR_H.df, file="../BasesCuis/hogares_cuis_4_analysis.csv")

# ----

if(!require('foreign')){install.packages("foreign")}
library("foreign")

# DOMICILIO CUIS
domicilio_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/domicilio_cuis_original.sav", to.data.frame=TRUE)
                  #read.csv("../Bases.Datos.Original/CUIS/CUIS/domicilio_cuis_original.csv", head=TRUE)

dim(domicilio_cuis)

domicilio_cuis <- merge(domicilio_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

domicilio_cuis <- encuesta_cuis[which(domicilio_cuis$IND_SAM==1),]

dim(domicilio_cuis)

write.csv(domicilio_cuis, file="../BasesCuis/domicilio_cuis.csv")

# ENCUESTA CUIS

encuesta_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/encuesta_cuis_original.sav", to.data.frame=TRUE)
                #read.csv("../Bases.Datos.Original/CUIS/CUIS/encuesta_cuis_original.csv", head=TRUE)

dim(encuesta_cuis)

encuesta_cuis <- merge(encuesta_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

encuesta_cuis <- encuesta_cuis[which(encuesta_cuis$IND_SAM==1),]

dim(encuesta_cuis)

write.csv(encuesta_cuis, file="../BasesCuis/encuesta_cuis.csv")

# INTEGRANTE CUIS

integrante_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/integrante_cuis_original.sav", to.data.frame=TRUE)
                  #read.csv("../Bases.Datos.Original/CUIS/CUIS/integrante_cuis_original.csv", head=TRUE)

dim(integrante_cuis)

integrante_cuis <- merge(integrante_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

integrante_cuis <- integrante_cuis[which(integrante_cuis$IND_SAM==1),]

dim(integrante_cuis)

write.csv(integrante_cuis, file="../BasesCuis/integrante_cuis.csv")

# PERSONA CUIS FILTRADO

persona_cuis_filtrado <- read.spss("../Bases.Datos.Original/CUIS/CUIS/persona_cuis_filtrado_original.sav", to.data.frame=TRUE)
                        #read.csv("../Bases.Datos.Original/CUIS/CUIS/persona_cuis_filtrado_original.csv", head=TRUE)

dim(persona_cuis_filtrado)

persona_cuis_filtrado <- merge(persona_cuis_filtrado, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

persona_cuis_filtrado <- persona_cuis_filtrado[which(persona_cuis_filtrado$IND_SAM==1),]

dim(persona_cuis_filtrado)

write.csv(persona_cuis_filtrado, file="../BasesCuis/persona_cuis_filtrado.csv")

# SE INTEGRANTE CUIS

se_integrante_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/se_integrante_cuis_original.sav", to.data.frame=TRUE)
                      #read.csv("../Bases.Datos.Original/CUIS/CUIS/se_integrante_cuis_linux.csv", head=TRUE)

dim(se_integrante_cuis)

se_integrante_cuis <- merge(se_integrante_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

se_integrante_cuis <- se_integrante_cuis[which(se_integrante_cuis$IND_SAM==1),]

dim(se_integrante_cuis)

write.csv(se_integrante_cuis, file="../BasesCuis/se_integrante_cuis.csv")


# SE VIVIENDA

se_vivienda_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/se_vivienda_cuis_original.sav", to.data.frame=TRUE)
                   #read.csv("../Bases.Datos.Original/CUIS/CUIS/se_vivienda_cuis_original.csv", head=TRUE)

dim(se_vivienda_cuis)

se_vivienda_cuis <- merge(se_vivienda_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

se_vivienda_cuis <- se_vivienda_cuis[which(se_vivienda_cuis$IND_SAM==1),]

dim(se_vivienda_cuis)

write.csv(se_vivienda_cuis, file="../BasesCuis/se_vivienda_cuis.csv")

# V ENCUESTADOR

v_encuestador_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/v_encuestador_cuis_original.sav", to.data.frame=TRUE)
                     #read.csv("../Bases.Datos.Original/CUIS/CUIS/v_encuestador_cuis_original.csv", head=TRUE)

dim(v_encuestador_cuis)

v_encuestador_cuis <- merge(v_encuestador_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

v_encuestador_cuis <- v_encuestador_cuis[which(v_encuestador_cuis$IND_SAM==1),]

dim(v_encuestador_cuis)

write.csv(v_encuestador_cuis, file="../BasesCuis/v_encuestador_cuis.csv")

# VIVIENDA CUIS

vivienda_cuis <- read.spss("../Bases.Datos.Original/CUIS/CUIS/vivienda_cuis_original.sav", to.data.frame=TRUE)
                #read.csv("../Bases.Datos.Original/CUIS/CUIS/vivienda_cuis_original.csv", head=TRUE)

dim(vivienda_cuis)

vivienda_cuis <- merge(vivienda_cuis, LLAVE_HOGAR_H.df, by = "LLAVE_HOGAR_H")

vivienda_cuis <- vivienda_cuis[which(vivienda_cuis$IND_SAM==1),]

dim(vivienda_cuis)

write.csv(vivienda_cuis, file="../BasesCuis/vivienda_cuis.csv")

gc()