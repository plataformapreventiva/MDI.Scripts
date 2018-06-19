* Encoding: UTF-8.

******************************************************************************************************************************************************************************************************
*                                 SYNTAXIS DEL ALGORITMO PARA LA ESTIMACIÓN DE INGRESOS Y LA IDENTIFICACIÓN DE CARENCIAS SOCIALES,                                *
*                                                                                                         MODELO SEDESOL 2015                                                                                                     *
******************************************************************************************************************************************************************************************************
** MODIFICADO PARA APLICARSE A LA BASE DE DATOS DE HOMOLOGACIÓN DE TODOS LOS INSTRUMENTOS AL 2016
**ENCASEH 2011 A 2014 / CUIS 2014 - 2015
**SIFODE 
**GENERAR TABLA DE PERSONAS (SOC_INTEGRANTE + PERSONAS + INTEGRANTE)

********TABLA: SOCIOEC_INTEGRANTE

GET
    FILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\SE_Integrante.sav'.

DATASET NAME SC_INTEGRANTE WINDOW=FRONT.



*******ETIQUETAS

VARIABLE LABELS  LLAVE_HOGAR_H  "Identifica Encuestas Únicas, se integra por el o los folios declarados por el Programa para determinar 1 encuesta única"
C_INTEGRANTE "Num. renglón de integrante"
ID_MDM_H "Identifica Hogares Únicos (RM)"
ID_MDM_P "Identifica Personas Únicas (RM)"
C_INSTSAL_A	"Institución de salud 1"
C_INSTSAL_B	"Institución de salud 2"
C_AFILSAL_A	"Motivo de afiliación a la inst. de salud 1"
C_AFILSAL_B	"Motivo de afiliación a la inst. de salud 2"
C_LENGUA_IND	"Lengua indígena"
OTRO_DIAL	"Especificar otra lengua indígena"
HABL_ESP	"También habla español"
INDIGENA	"Se considera indígena"
LEER_ESCR	"Sabe leer escribir"
C_ULT_NIVEL	"Nivel escolar (último aprobado)"
C_ULT_GRA	"Grado (años aprobados)"
ASIS_ESC	"Actualmente asiste a la escuela"
C_ABAN_ESCU	"Motivo por el que dejó la escuela"
C_CON_TRA	"Condición  laboral"
C_VER_CON_TRAB	"Verificación laboral"
C_POS_OCUP	"Ocupación principal"
C_PERI_TRA	"Periodo en el que trabaja"
C_MOT_NOTR	"Motivo por el que no trabaja todo el año"
TRAB_SUBOR	"Trabajo subordinado (tuvo un jefe o supervisor)"
TRAB_INDEP	"Trabajo independiente (por su cuenta)"
TRAB_PRESTA_A	"Prestación laboral Incapacidad: (enfermedad, accidente, maternidad)"
TRAB_PRESTA_B	"Prestación laboral: Sar o afore"
TRAB_PRESTA_C	"Prestación laboral: Crédito para vivienda"
TRAB_PRESTA_D	"Prestación laboral: Guardería"
TRAB_PRESTA_E	"Prestación laboral: Aguinaldo"
TRAB_PRESTA_F	"Prestación laboral: Seguro de vida"
TRAB_PRESTA_G	"Prestación laboral: No tiene ninguna"
TRAB_PRESTA_H	"Prestación laboral: No sabe o no responde"
TRAB_NO_RE	"Trabajo: Recibió un pago por su trabajo"
MONTO	"Trabajo: Monto que recibe por su trabajo "
C_PERIODO	"Trabajo: Periodo en el que recibe el pago"
SEG_VOLUNT_A	"Contratación voluntaria de:  sar, afore o fondo de pensiones"
SEG_VOLUNT_B	"Contratación voluntaria de: seguro privado de gastos médicos"
SEG_VOLUNT_C	"Contratación voluntaria de: seguro de vida"
SEG_VOLUNT_D	"Contratación voluntaria de: seguro de invalidez"
SEG_VOLUNT_E	"Contratación voluntaria de: otro tipo de seguro"
SEG_VOLUNT_F	"Contratación voluntaria de: ninguno "
SEG_VOLUNT_G	"Contratación voluntaria: no sabe / no responde"
JUBILADO	"Jubilación: Es jubilado o pensionado"
JUBILADO_1	"Jubilación: Recibe dinero por pensión dentro del país"
JUBILADO_2	"Jubilación: Recibe dinero por pensión de otros países"
INAPAM	"INAPAM - Tiene tarjeta de INAPAM"
AM_A	"AM - Recibe dinero por:  PPAM"
AM_B	"AM - Recibe dinero por: AM - Prospera"
AM_C	"AM - Recibe dinero por: otros programas para AM (estatal, muncipal)"
AM_D	"AM - Recibe dinero por: Ningún programa de AM"
AM_E	"AM - Recibe dinero por: No sabe / no responde"
OTR_ING_A	"Otros Ingresos: Es maestro de escuela de gobierno (federal, estatal, municipal)"
OTR_ING_A_2	"Otros Ingresos: Cuanto gana mensualmente como maestro de escuela"
OTR_ING_B	"Otros Ingresos: Es dueño de una tienda"
OTR_ING_B_2	"Otros Ingresos: Cuanto gana mensualmente como dueño de una tienda"
OTR_ING_C	"Otros Ingresos: Es dueño de algún negocio"
OTR_ING_C_2	"Otros Ingresos: Cuanto gana mensualmente como dueño de algún negocio"
OTR_ING_D	"Otros Ingresos: Es arrendatario de algún transporte"
OTR_ING_D_2	"Otros Ingresos: Cuanto gana mensualmente como arrendatario de algún transporte"
OTR_ING_E	"Otros Ingresos: Es doctor(a) o enfermero(a) de gobierno (federal, estatal, municipal)"
OTR_ING_E_2	"Otros Ingresos: Cuanto gana mensualmente como doctor(a) o enfermero(a) "
OTR_ING_F	"Otros Ingresos: Es servidor público de gobierno (federal, estatal, municipal)"
OTR_ING_F_2	"Otros Ingresos: Cuanto gana mensualmente como servidor público"
OTR_ING_G	"Otros Ingresos: Ninguna de las anteriores"
TIENE_DISCA	"Discapacidad Tipo: caminar, moverse, subir o bajar escaleras"
DISCA_ORI	"Discapacidad Origen: caminar, moverse, subir o bajar escaleras"
DISCA_GRA	"Discapacidad Grado: caminar, moverse, subir o bajar escaleras"
TIENE_DISCB	"Discapacidad Tipo: ver, o solo ve sombras aún usando lentes"
DISCB_ORI	"Discapacidad Origen: ver, o solo ve sombras aún usando lentes"
DISCB_GRA	"Discapacidad Grado: ver, o solo ve sombras aún usando lentes"
TIENE_DISCC	"Discapacidad Tipo: hablar, comunicarse o conversar"
DISCC_ORI	"Discapacidad Origen: hablar, comunicarse o conversar"
DISCC_GRA	"Discapacidad Grado: hablar, comunicarse o conversar"
TIENE_DISCD	"Discapacidad Tipo: oír, aún usando aparato auditivo"
DISCD_ORI	"Discapacidad Origen: oír, aún usando aparato auditivo"
DISCD_GRA	"Discapacidad Grado: oír, aún usando aparato auditivo"
TIENE_DISCE	"Discapacidad Tipo: vestirse, bañarse o comer, desplazarse u otras de cuidado personal"
DISCE_ORI	"Discapacidad Origen: vestirse, bañarse o comer, desplazarse u otras de cuidado personal"
DISCE_GRA	"Discapacidad Grado: vestirse, bañarse o comer, desplazarse u otras de cuidado personal"
TIENE_DISCF	"Discapacidad Tipo: poner atención, aprender cosas, o concentrarse"
DISCF_ORI	"Discapacidad Origen: poner atención, aprender cosas, o concentrarse"
DISCF_GRA	"Discapacidad Grado: poner atención, aprender cosas, o concentrarse"
ENF_ART	"Enfermedad diagnosticada: artritis"
ENF_CAN	"Enfermedad diagnosticada: cáncer"
ENF_CIR	"Enfermedad diagnosticada: cirrosis"
ENF_REN	"Enfermedad diagnosticada: deficiencia renal"
ENF_DIA	"Enfermedad diagnosticada: diabetes"
ENF_COR	"Enfermedad diagnosticada: enfermedades del corazón"
ENF_PUL	"Enfermedad diagnosticada: enfisema pulmonar"
ENF_VIH	"Enfermedad diagnosticada: VIH"
ENF_DEF	"Enfermedad diagnosticada: deficiencia nutricional (anemia/desnutrición)"
ENF_HIP	"Enfermedad diagnosticada: hipertensión"
ENF_OBE	"Enfermedad diagnosticada: obesidad"
P_AGRI	"Proyecto Productivo: Agricultura, cría y explotación de animales, aprovechamiento forestal, pesca y caza"
P_MANU	"Proyecto Productivo: Manufactura (elaboración de productos)"
P_COME	"Proyecto Productivo: Comercio (compra-venta de bienes)"
P_TRAN	"Proyecto Productivo: Transporte (mercancías o personas) "
P_PROF	"Proyecto Productivo:  Servicios profesionales, científicos y/o técnicos (oficios)"
P_EDUC	"Proyecto Productivo: Servicios educativos (capacitación)"
P_SALD	"Proyecto Productivo: Servicios de salud y de asistencia social (enfermería, cuidado de personas)"
P_RECR	"Proyecto Productivo: Servicios de esparcimiento, culturales y deportivos, y otros servicios recreativos"
P_ALOJ	"Proyecto Productivo: Servicios de alojamiento temporal y de preparación de alimentos y bebidas"
P_COMU	"Proyecto Productivo: Servicios de telecomunicaciones (café internet, casetas telefónicas)"
P_OTRO	"Proyecto Productivo: Otro"
TIPO_PROY_ESP	"Proyecto Productivo: Especificar otro tipo de proyecto"
FCH_CREACION "Atributo de Auditoria - guarda la fecha en que se crea el registro"
USR_CREACION "Atributo de Auditoria - guarda el usuario que crea el registro"
C_RAZ_NO_TRAB "Razón por la que no trabajó el mes pasado"
CSC_HOGAR "Consecutivo hogar CUIS 2012 y 2013".

*********Agregar y comprobar datos de hogares

DATASET ACTIVATE SC_INTEGRANTE.
AGGREGATE
  /OUTFILE=
    'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_scinteg_hogs.sav'
  /BREAK=LLAVE_HOGAR_H
  /tot_pers=N.

GET
  FILE=
    'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_scinteg_hogs.sav'.
DATASET NAME agr_scinteg_hogs WINDOW=FRONT.

DATASET ACTIVATE agr_scinteg_hogs.
DESCRIPTIVES VARIABLES=tot_pers
  /STATISTICS=SUM MIN MAX.

**Sacar únicos


 * DATASET ACTIVATE agr_scinteg_hogs.
* Identificar casos duplicados.
 * SORT CASES BY LLAVE_HOGAR_H(A).
 * MATCH FILES
  /FILE=*
  /BY LLAVE_HOGAR_H
  /FIRST=PrimarioPrimero
  /LAST=PrimarioÚltimo.
 * DO IF (PrimarioPrimero).
 * COMPUTE  SecuenciaCoincidencia=1-PrimarioÚltimo.
 * ELSE.
 * COMPUTE  SecuenciaCoincidencia=SecuenciaCoincidencia+1.
 * END IF.
 * LEAVE  SecuenciaCoincidencia.
 * FORMATS  SecuenciaCoincidencia (f7).
 * COMPUTE  InDupGrp=SecuenciaCoincidencia>0.
 * SORT CASES InDupGrp(D).
 * MATCH FILES
  /FILE=*
  /DROP=PrimarioPrimero InDupGrp SecuenciaCoincidencia.
 * VARIABLE LABELS  PrimarioÚltimo 'Indicador de cada último caso de coincidencia como primario'.
 * VALUE LABELS  PrimarioÚltimo 0 'Caso duplicado' 1 'Caso primario'.
 * VARIABLE LEVEL  PrimarioÚltimo (ORDINAL).
 * FREQUENCIES VARIABLES=PrimarioÚltimo.
 * EXECUTE.

DATASET ACTIVATE SC_INTEGRANTE. 
DATASET CLOSE agr_scinteg_hogs.

********TABLA: PERSONAS
********ENCASEH 2013

GET
  FILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\Persona.sav'.
DATASET NAME PERSONAS WINDOW=FRONT.

*******ETIQUETAS

VARIABLE LABELS  LLAVE_HOGAR_H  "Identifica Encuestas Únicas, se integra por el o los folios declarados por el Programa para determinar 1 encuesta única"
C_INTEGRANTE "Num. renglón de integrante"
ID_MDM_H "Identifica Hogares Únicos (RM)"
ID_MDM_P "Identifica Personas Únicas (RM)"
TIE_CURP "La persona tiene CURP"
NB_CURP "CURP"
NB_NOMBRE "Nombre"
NB_PRIMER_AP "Primer Apellido"
NB_SEGUNDO_AP "Segundo Apellido"
FCH_NACIMIENTO "Fecha de Nacimiento"
C_CD_EDO_NAC "Entidad de Nacimiento"
C_CD_SEXO "Sexo"
S_TIE_CURP "La persona tiene CURP (RM)"
S_NB_CURP "CURP (RM)"
S_NB_NOMBRE  "Nombre (RM)"
S_NB_PRIMER_AP "Primer Apellido (RM)"
S_NB_SEGUNDO_AP "Segundo Apellido (RM)"
S_FCH_NACIMIENTO "Fecha de Nacimiento (RM)"
S_C_CD_EDO_NAC "Entidad de Nacimiento (RM)"
S_C_CD_SEXO "SEXO (RM)"
ACTA_NAC "Tiene acta de Nacimiento"
FCH_CREACION "Atributo de Auditoria - guarda la fecha en que se crea el registro"
USR_CREACION "Atributo de Auditoria - guarda el usuario que crea el registro"
ID_UNICO "Identificador Único de personas de Padrones"
CSC_HOGAR "Consecutivo hogar CUIS 2012 y 2013"
ID_HOG_PADP "Ident. único de hogar de padrones del Programa"
ID_PERS_PADP "Ident. único de persona de padrones del Programa".

*ROL

VALUE LABELS TIE_CURP 
1 "SI TIENE CURP" 
2 "SI TIENE CURP, PERO NO LA TIENE EN EL MOMENTO DE LA ENCUESTA" 
3 "NO TIENE CURP". 
  
VALUE LABELS S_C_CD_SEXO 
1 "HOMBRE" 
2 "MUJER". 
 
VALUE LABELS C_CD_SEXO 
1 "HOMBRE" 
2 "MUJER". 
 
VALUE LABELS ACTA_NAC 
1 "SI TIENE ACTA" 
2 "SI TIENE ACTA, PERO NO LA TIENE EN EL MOMENTO DE LA ENCUESTA" 
3 "NO TIENE ACTA". 
 
VALUE LABELS C_CD_EDO_NAC 
1 "AGUASCALIENTES" 
2 "BAJA CALIFORNIA" 
3 "BAJA CALIFORNIA SUR" 
4 "CAMPECHE" 
5 "COAHUILA" 
6 "COLIMA" 
7 "CHIAPAS" 
8 "CHIHUAHUA" 
9 "DISTRITO FEDERAL" 
10 "DURANGO" 
11 "GUANAJUATO" 
12 "GUERRERO" 
13 "HIDALGO" 
14 "JALISCO" 
15 "MÉXICO" 
16 "MICHOACÁN" 
17 "MORELOS" 
18 "NAYARIT" 
19 "NUEVO LEÓN" 
20 "OAXACA" 
21 "PUEBLA" 
22 "QUERÉTARO" 
23 "QUINTANA ROO" 
24 "SAN LUIS POTOSÍ" 
25 "SINALOA" 
26 "SONORA" 
27 "TABASCO" 
28 "TAMAULIPAS" 
29 "TLAXCALA" 
30 "VERACRUZ" 
31 "YUCATÁN" 
32 "ZACATECAS" 
33 "EXTRANJERO". 
 
VALUE LABELS S_C_CD_EDO_NAC 
1 "AGUASCALIENTES" 
2 "BAJA CALIFORNIA" 
3 "BAJA CALIFORNIA SUR" 
4 "CAMPECHE" 
5 "COAHUILA" 
6 "COLIMA" 
7 "CHIAPAS" 
8 "CHIHUAHUA" 
9 "DISTRITO FEDERAL" 
10 "DURANGO" 
11 "GUANAJUATO" 
12 "GUERRERO" 
13 "HIDALGO" 
14 "JALISCO" 
15 "MÉXICO" 
16 "MICHOACÁN" 
17 "MORELOS" 
18 "NAYARIT" 
19 "NUEVO LEÓN" 
20 "OAXACA" 
21 "PUEBLA" 
22 "QUERÉTARO" 
23 "QUINTANA ROO" 
24 "SAN LUIS POTOSÍ" 
25 "SINALOA" 
26 "SONORA" 
27 "TABASCO" 
28 "TAMAULIPAS" 
29 "TLAXCALA" 
30 "VERACRUZ" 
31 "YUCATÁN" 
32 "ZACATECAS" 
33 "EXTRANJERO". 

VALUE LABELS S_TIE_CURP 
1 "SI TIENE CURP" 
2 "SI TIENE CURP, PERO NO LA TIENE EN EL MOMENTO DE LA ENCUESTA" 
3 "NO TIENE CURP". 

*********Agregar y comprobar datos de hogares
********ENCASEH 2012

DATASET ACTIVATE PERSONAS.
AGGREGATE
  /OUTFILE=
    'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_pers_hogs.sav'
  /BREAK=LLAVE_HOGAR_H
  /tot_pers=N.

GET
  FILE=
    'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_pers_hogs.sav'.
DATASET NAME agr_pers_hogs WINDOW=FRONT.

DATASET ACTIVATE agr_pers_hogs.
DESCRIPTIVES VARIABLES=tot_pers
  /STATISTICS=SUM MIN MAX.

DATASET ACTIVATE PERSONAS. 
DATASET CLOSE agr_pers_hogs.


********TABLA: INTEGRANTES
********ENCASEH 2013

GET
  FILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\Integrante.sav'.
DATASET NAME INTEGRANTES WINDOW=FRONT.

*******ETIQUETAS

VARIABLE LABELS  LLAVE_HOGAR_H  "Identifica Encuestas Únicas, se integra por el o los folios declarados por el Programa para determinar 1 encuesta única"
C_INTEGRANTE "Num. renglón de integrante"
ID_MDM_H "Identifica Hogares Únicos (RM)"
ID_MDM_P "Identifica Personas Únicas (RM)"
C_CON_RES "Condición de Residencia"
C_CD_PARENTESCO "Parentesco respecto al JH"
RESIDE "Año en el que empezó a residir en Mex. (si es extr)"
PADRE "Renglón de identificación del padre en el hogar"
MADRE "Renglón de identificación de la madre en el hogar"
C_CD_EDO_CIVIL "Estado Civil"
EDAD "Años cumplidos al momento de la encuesta"
VAL_NB_RENAPO "Validación de CURP con RENAPO" 
FCH_CREACION "Atributo de Auditoria - guarda la fecha en que se crea el registro"
USR_CREACION "Atributo de Auditoria - guarda el usuario que crea el registro"
NUM_PER "Informante adecuado"
CONYUGE "Num. renglón del cónyuge"
CSC_HOGAR "Consecutivo hogar CUIS 2012 y 2013".


VALUE LABELS C_CON_RES
1 "VIVE NORMALMENTE EN SU DOMICILIO"
2 "VIVE EN OTRO LUGAR PORQUE ESTÁ TRABAJANDO, ESTUDIANDO O POR OTRA RAZÓN"
3 "VIVE TEMPORALMENTE EN EL DOMICILIO PORQUE NO TIENE OTRO LUGAR DONDE VIVIR"
4 "VIVE EN EL DOMICILIO, AUNQUE POR AHORA ESTÁ EN OTRO LUGAR"
5 "NO EXISTE ESA PERSONA"
6 "YA NO VIVE EN EL HOGAR"
7 "SE MURIÓ"
8 "MIGRÓ".

VALUE LABELS C_CD_PARENTESCO
1 "JEFE(A) DEL HOGAR"
2 "CÓNYUGE O COMPAÑERO(A)"
3 "HIJO(A)"
4 "PADRE O MADRE"
5 "HERMANO(A)"
6 "NIETO(A)"
7 "NUERA O YERNO"
8 "SUEGRO(A)"
9 "HIJASTRO(A) / ENTENADO(A)"
10 "SOBRINO(A)"
11 "OTRO PARENTESCO"
12 "NO TIENE PARENTESCO".

VALUE LABELS C_CD_EDO_CIVIL
1 "VIVE EN UNIÓN LIBRE"
2 "ES CASADO (A)"
3 "ES SEPARADO (A)"
4 "ES DIVORCIADO (A)"
5 "ES VIUDO (A)"
6 "ES SOLTERO (A)".

VALUE LABELS MADRE
77 "NO VIVE EN EL HOGAR"
78 "YA NO VIVE"
98 "NO SABE / NO RESPONDE".

VALUE LABELS PADRE
77 "NO VIVE EN EL HOGAR"
78 "YA NO VIVE"
98 "NO SABE / NO RESPONDE".

VALUE LABELS VAL_NB_RENAPO
0 "NO TIENE CURP"
1 "CURP VÁLIDA CON RENAPO"
2 "CURP NO VÁLIDA CON RENAPO"
3 "NO SE REALIZÓ LA VALIDACIÓN CON RENAPO"
4 "LOS DATOS DE LA CURP NO COINCIDEN CON LOS DE LA PERSONA".

VALUE LABELS CONYUGE
77 "NO VIVE EN EL HOGAR"
98 "NO SABE".

VALUE LABELS NUM_PER
1 "INFORMANTE ADECUADO".

*********Agregar y comprobar datos de hogares
********ENCASEH 2013 - 786,626 HOGARES

DATASET ACTIVATE INTEGRANTES.
AGGREGATE
  /OUTFILE=
    'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_int_hogs.sav'
  /BREAK=LLAVE_HOGAR_H
  /tot_pers=N.

GET
  FILE=
    'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_int_hogs.sav'.
DATASET NAME agr_int_hogs WINDOW=FRONT.

DATASET ACTIVATE agr_int_hogs.
DESCRIPTIVES VARIABLES=tot_pers
  /STATISTICS=SUM MIN MAX.

DATASET ACTIVATE INTEGRANTES. 
DATASET CLOSE agr_int_hogs.


***************************************************************************** Pegar tablas de personas (base: sc_integrante) ********************************************************************

DATASET ACTIVATE SC_INTEGRANTE.
SORT CASES BY LLAVE_HOGAR_H(A) C_INTEGRANTE(A).

DATASET ACTIVATE PERSONAS.
SORT CASES BY LLAVE_HOGAR_H(A) C_INTEGRANTE(A).

DATASET ACTIVATE INTEGRANTES.
SORT CASES BY LLAVE_HOGAR_H(A) C_INTEGRANTE(A).


DATASET ACTIVATE SC_INTEGRANTE.

MATCH FILES /TABLE=*
  /FILE='PERSONAS'
  /RENAME (USR_CREACION FCH_CREACION ID_MDM_H ID_MDM_P = d0 d1 d2 d3) 
  /BY LLAVE_HOGAR_H C_INTEGRANTE
  /DROP= d0 d1 d2 d3.
EXECUTE.

MATCH FILES /TABLE=*
  /FILE='INTEGRANTES'
  /RENAME (USR_CREACION FCH_CREACION ID_MDM_H ID_MDM_P = d0 d1 d2 d3) 
  /BY LLAVE_HOGAR_H C_INTEGRANTE
  /DROP= d0 d1 d2 d3.
EXECUTE.

SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\personas2.sav'
  /COMPRESSED.

DATASET ACTIVATE PERSONAS.
DATASET CLOSE SC_INTEGRANTE.

DATASET ACTIVATE PERSONAS.
SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\Persona.sav'
  /COMPRESSED.

DATASET ACTIVATE INTEGRANTES.
SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\Integrante.sav'
  /COMPRESSED.

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\personas2.sav'.
DATASET NAME PERSONAS2 WINDOW=FRONT.

DATASET ACTIVATE PERSONAS2. 
DATASET CLOSE PERSONAS.
DATASET CLOSE INTEGRANTES.

*********************************************************************** COMIENZA LA ESTIMACIÓN DE INGRESOS 2016 ********************************************
*************************************************************************************************************************************************************************
*Se debe utilizar las tabla de C_Localidades_2016 - Misma que se utiliza para calificar y recolectar en línea del sistema WEB
*E:\SEDESOL\DE_SIFODE\ACTUALIZACION_SIFODE_2016\Sintax_calif_2016\locs\
**************************************************************************************************************************************************************************
* Se abre la tabla de personas.
* Se crean variables e indicadores a nivel persona

 * GET
  FILE=
   'I:\calif\calif2\CUIS13\Res_S\personas2.sav'.
 * DATASET NAME PERSONAS2 WINDOW=FRONT.

SORT CASES BY LLAVE_HOGAR_H (A) C_INTEGRANTE (A).

*Composición demográfica del hogar.
*** Identificación del total de personas del hogar, el jefe, el cónyuge, las mujeres de 15 a 49 
***los menores de 15 y los mayores de 65

FREQUENCIES VARIABLES=C_CD_PARENTESCO C_CD_SEXO C_CON_RES C_CD_EDO_CIVIL EDAD CONYUGE
  /ORDER=ANALYSIS.

COMPUTE tot_per = (C_CON_RES = 1 | C_CON_RES = 2 | C_CON_RES= 3 | C_CON_RES = 4).
COMPUTE es_jefe = (C_CD_PARENTESCO = 1) .
COMPUTE es_cony = (C_CD_PARENTESCO = 2 & EDAD>=10) .
COMPUTE int0a15 = (EDAD >= 0 & EDAD <= 15) .
COMPUTE int16a64 = (EDAD >= 16 & EDAD <= 64) .
COMPUTE int65a98 = (EDAD >= 65 & EDAD <= 98) .
COMPUTE muj15a49 = (C_CD_SEXO = 2 & (EDAD >= 15 & EDAD <= 49)) .
EXECUTE.

FREQUENCIES VARIABLES=tot_per es_jefe es_cony int0a15 int16a64 int65a98 muj15a49
  /ORDER=ANALYSIS.

*Años de escolaridad.

FREQUENCIES VARIABLES=C_ULT_NIVEL C_ULT_GRA
  /ORDER=ANALYSIS.

IF (C_ULT_NIVEL >10 & (C_ULT_GRA=0 | sysmis(C_ULT_GRA))) esc = 0.
IF (C_ULT_NIVEL = 1 & C_ULT_GRA >= 1 & C_ULT_GRA <= 3) esc = 0.
IF (C_ULT_NIVEL = 2 & C_ULT_GRA >= 1 & C_ULT_GRA <= 6) esc = C_ULT_GRA.
IF (C_ULT_NIVEL = 3 & C_ULT_GRA >= 1 & C_ULT_GRA <= 3) esc = 6 + C_ULT_GRA.
IF (C_ULT_NIVEL = 4 & C_ULT_GRA >= 1 & C_ULT_GRA <= 4) esc = 9 + C_ULT_GRA.
IF (C_ULT_NIVEL = 5 & C_ULT_GRA >= 1 & C_ULT_GRA <= 4) esc = 9 + C_ULT_GRA. 
IF (C_ULT_NIVEL = 6 & C_ULT_GRA >= 1 & C_ULT_GRA <= 4) esc = 6 + C_ULT_GRA.
IF (C_ULT_NIVEL = 7 & C_ULT_GRA >= 1 & C_ULT_GRA <= 4) esc = 9 + C_ULT_GRA.
IF (C_ULT_NIVEL = 8 & C_ULT_GRA >= 1 & C_ULT_GRA <= 4) esc = 12 + C_ULT_GRA.
IF (C_ULT_NIVEL = 9 & C_ULT_GRA >= 1 & C_ULT_GRA <= 6) esc = 12 + C_ULT_GRA.
IF (C_ULT_NIVEL = 10 & C_ULT_GRA >= 1 & C_ULT_GRA <= 6) esc = 16 + C_ULT_GRA.
IF (EDAD>=0 & EDAD<3) esc = 0.
EXECUTE. 

*Trabajadores: Declara trabajar en pregunta principal y verificación mayor a 11 años

FREQUENCIES VARIABLES=C_CON_TRA C_VER_CON_TRAB
  /ORDER=ANALYSIS.

IF (EDAD>=12 & (C_CON_TRA>=1 & C_CON_TRA<=3)) tot_ocupo = 1.
IF (EDAD>=12 & (C_VER_CON_TRAB >=1 & C_VER_CON_TRAB<=4)) tot_ocupo =1.
IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB=5 | C_VER_CON_TRAB=6))) tot_ocupo  = 0.
IF (EDAD>=0 & EDAD<12) tot_ocupo =0.
EXECUTE .

FREQUENCIES VARIABLES=tot_ocupo
  /ORDER=ANALYSIS.

***SIN SYSMIS tot_ocupo
**TRABAJADOR SUBORDINADO:Declara trabajo + jefe + con remuneración

FREQUENCIES VARIABLES=TRAB_SUBOR TRAB_INDEP TRAB_NO_RE
  /ORDER=ANALYSIS.

IF (tot_ocupo=1 & TRAB_SUBOR=1 & sysmis(TRAB_INDEP) & TRAB_NO_RE=1) trabsub=1.
IF (tot_ocupo=1 & TRAB_SUBOR=1 & sysmis(TRAB_INDEP) & TRAB_NO_RE=2) trabsub=0.
IF (tot_ocupo=1 & TRAB_SUBOR=2 & TRAB_INDEP=1) trabsub=0.
IF (tot_ocupo = 0) trabsub = 0.
IF (EDAD>=0 & EDAD<12) trabsub =0.
EXECUTE .

FREQUENCIES VARIABLES=trabsub
  /ORDER=ANALYSIS.

***CON SYSMIS trabsub
**TRABAJADOR INDEPENDIENTE:Declara trabajo + SIN jefe + con remuneración

IF (tot_ocupo = 1 & TRAB_SUBOR = 2 & TRAB_INDEP = 1 & TRAB_NO_RE = 1) trabind =1.
IF (tot_ocupo=1 & TRAB_SUBOR=1 & sysmis(TRAB_INDEP)) trabind=0.
IF (tot_ocupo=1 & TRAB_SUBOR=2 & TRAB_INDEP=1 & TRAB_NO_RE=2) trabind =0.
IF (tot_ocupo = 0) trabind = 0 .
IF (EDAD>=0 & EDAD<12) trabind =0.
EXECUTE.

**TRABAJADOR QUE NO ES SUBORDINADO NI INDEPENDIENTE SIN PAGO + trab. subordinado o independiente sin pago.

IF (tot_ocupo = 1 & TRAB_SUBOR=2 & TRAB_INDEP=2 & TRAB_NO_RE=2) trab_s_pago= 1.
IF (tot_ocupo=1 & TRAB_SUBOR=1 & sysmis(TRAB_INDEP) & TRAB_NO_RE=1)  trab_s_pago= 0.
IF (tot_ocupo=1 & TRAB_SUBOR=1 & sysmis(TRAB_INDEP) & TRAB_NO_RE=2)  trab_s_pago= 1.
IF (tot_ocupo = 1 & TRAB_SUBOR=2 & TRAB_INDEP=1 & TRAB_NO_RE=1) trab_s_pago= 0.
IF (tot_ocupo = 1 & TRAB_SUBOR=2 & TRAB_INDEP=1 & TRAB_NO_RE=2) trab_s_pago= 1.
IF (tot_ocupo = 0) trab_s_pago=0.
IF (EDAD>=0 & EDAD<12) trab_s_pago=0.
EXECUTE.


DATASET ACTIVATE PERSONAS2.
FREQUENCIES VARIABLES=trabsub trabind trab_s_pago
  /ORDER=ANALYSIS.

** Los sysmis en trabsub, trabind y trab_s_pago son correctos cuando se tiene
 trab_sub=2, trab_ind=2 y trab_no_re=1 dado que se considera inconsistente 
recibir pago sin ser subordinado o independiente.

**Los sysmis en  trabsub y trabind  son correctos cuando se tiene
 trab_sub=2, trab_ind=2 y trab_no_re=2 dado que no se puede clasificar 
como subordinado o idependiente pero si puede clasificarse como sin pago.

**JEFE TRABAJADOR INDEPENDIENTE

IF (es_jefe = 1) jtrab_ind = trabind .
EXECUTE.

****JUBILADO O PENSIONADO **** QUE NO TENGA TRABAJO Y DECLARE SER JUBILADO O PENSIONADO
****REVISAR CONSTRUCCIÓN PARA CUIS CON VARIABLES DE JUBILACIÓN - aunque la tabla sea homologada de no ser 
***una encuesta ENCASEH no se te tendrá informacion en con_inac

***PARA ENCASEH (con_inac - C_RAZ_NO_TRAB) - CUIS (jubilado)

 * DATASET ACTIVATE PERSONAS2.
 * FREQUENCIES VARIABLES=C_RAZ_NO_TRAB JUBILADO JUBILADO_1 JUBILADO_2
  /ORDER=ANALYSIS.

 * IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB=5 | C_VER_CON_TRAB=6)) & (C_RAZ_NO_TRAB = 2)) jubiladof = 1.
 * IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB=5 | C_VER_CON_TRAB=6)) & (C_RAZ_NO_TRAB ~=2 & C_RAZ_NO_TRAB ~=0)) jubiladof = 0.
 * IF (EDAD>=12 & (C_CON_TRA>=1 & C_CON_TRA<=3) & sysmis(C_VER_CON_TRAB)) jubiladof = 0.
 * IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB >=1 & C_VER_CON_TRAB<=4))) jubiladof = 0.
 * IF (EDAD>=12 & JUBILADO=1) jubiladof = 1.
 * IF (EDAD>=0 & EDAD<12) jubiladof =0.
 * EXECUTE.

 * FREQUENCIES VARIABLES=jubiladof
  /ORDER=ANALYSIS.

*** PARA CUIS  (jubilado | JUBILADO_1 | JUBILADO_2) - se identifican los mismos 1 pero no los "0"

IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB=5 | C_VER_CON_TRAB=6)) & (C_RAZ_NO_TRAB = 2)) jubiladof = 1.
IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB=5 | C_VER_CON_TRAB=6)) & (C_RAZ_NO_TRAB ~=2 & C_RAZ_NO_TRAB ~=0)) jubiladof = 0.
IF (EDAD>=12 & (C_CON_TRA>=1 & C_CON_TRA<=3) & sysmis(C_VER_CON_TRAB)) jubiladof = 0.
IF (EDAD>=12 & ((C_CON_TRA>=4 & C_CON_TRA<=7) & (C_VER_CON_TRAB >=1 & C_VER_CON_TRAB<=4))) jubiladof = 0.
IF (EDAD>=12 & JUBILADO=1) jubiladof = 1.
IF (EDAD>=12 & JUBILADO=2) jubiladof = 0.
IF (EDAD>=12 & sysmis(JUBILADO) & (JUBILADO_1=1 | JUBILADO_2=1))  jubiladof = 1.
IF (EDAD>=12 & sysmis(JUBILADO) & (JUBILADO_1>=2 & JUBILADO_2>=2))  jubiladof = 0.
IF (EDAD>=0 & EDAD<12) jubiladof =0.
EXECUTE.

FREQUENCIES VARIABLES=jubiladof
  /ORDER=ANALYSIS.


**PERSONAS CON SEGURIDAD SOCIAL POR TRABAJO - SEGURIDAD SOCIAL ACCESO

FREQUENCIES VARIABLES=C_INSTSAL_A C_INSTSAL_B C_AFILSAL_A C_AFILSAL_B
  /ORDER=ANALYSIS.

IF ((C_INSTSAL_A >= 2 & C_INSTSAL_A <= 5) & (C_AFILSAL_A >=1 & C_AFILSAL_A <= 3)) segsoc1 = 1. 
IF ((C_INSTSAL_B >= 2 & C_INSTSAL_B <= 5) & (C_AFILSAL_B >=1 & C_AFILSAL_B <= 3)) segsoc1 = 1. 
IF (((C_INSTSAL_A >= 1 & C_INSTSAL_A <= 5) & (C_AFILSAL_A >=4 & C_AFILSAL_A <= 9)) & ((C_INSTSAL_B >= 1 & C_INSTSAL_B <= 5) 
& (C_AFILSAL_B >=4 & C_AFILSAL_B <= 9))) segsoc1 = 0. 
IF (((C_INSTSAL_A >= 1 & C_INSTSAL_A <= 5) & (C_AFILSAL_A >=4 & C_AFILSAL_A <= 9)) and sysmis(C_INSTSAL_B)) segsoc1 = 0. 
IF (C_INSTSAL_A = 1 & sysmis(C_INSTSAL_B)) segsoc1 = 0. 
IF (C_INSTSAL_A = 99 & sysmis(C_AFILSAL_A) & sysmis(C_INSTSAL_B) & sysmis(C_AFILSAL_B)) segsoc1 = 0. 
IF (C_INSTSAL_A =1  & ((C_INSTSAL_B>=2 & C_INSTSAL_B<=5) & (C_AFILSAL_B>=4 & C_AFILSAL_B<=9))) segsoc1 =0. 
EXECUTE.

FREQUENCIES VARIABLES=segsoc1
  /ORDER=ANALYSIS.

*PERSONAS CON SEGURO POPULAR.

IF (C_INSTSAL_A = 1 | C_INSTSAL_B = 1 ) seg_pop=1.
IF (C_INSTSAL_A >= 2 & C_INSTSAL_A <= 5) seg_pop=0.
IF (C_INSTSAL_A = 99 & sysmis(C_AFILSAL_A) & sysmis(C_INSTSAL_B) & sysmis(C_AFILSAL_B)) seg_pop=0.
EXECUTE.

FREQUENCIES VARIABLES=seg_pop
  /ORDER=ANALYSIS.

* RECODIFICAR A SYSMIS LA INFORMACION INCONSISTENTE PARA SEGURIDAD SOCIAL 
*Personas que no trabajan y no son jubilados ni pensionados que aparecían con seguridad social derivada de trabajo

DO IF ((tot_per=1) & (tot_ocupo = 0 | sysmis(tot_ocupo)) & (jubiladof = 0 | sysmis(jubiladof))) .
RECODE
  segsoc1  (1=SYSMIS)  .
END IF.
EXECUTE.

FREQUENCIES VARIABLES=segsoc1
  /ORDER=ANALYSIS.

****VARIABLES PARA GUARDAR LOS CASOS PERDIDOS DE LAS VARIABLES CREADAS

*Sysmis de trabajo subordinados.

compute systs = (tot_per=1 & sysmis(trabsub)) .

*sysmis de trabajo independiente.

compute systi = (tot_per=1 & sysmis(trabind)) .

*sysmis de trabajadores sin pago.

compute systsp = (tot_per=1 & sysmis(trab_s_pago)) .
EXECUTE .

FREQUENCIES VARIABLES=systs systi systsp 
  /ORDER=ANALYSIS.

*sysmis de acceso a servicios mèdicos por trabajo.

compute sysss = (tot_per=1 & sysmis(segsoc1)) .

*sysmis de seguro popular.

compute syssp = (tot_per=1 & sysmis(seg_pop)) .

*sysmis de trabajo independiente del jefe.

compute sysjti = (tot_per=1 & sysmis(jtrab_ind)) .

*** se recodifican los valores para que no afecte en la suma

RECODE
  segsoc1 trabsub trabind trab_s_pago seg_pop jtrab_ind (SYSMIS=0)  .
EXECUTE.

*crear variables para agregar de escolaridad del jefe del hogar y cónyuge

IF (es_jefe = 1) j_esc = esc .
IF (es_cony = 1) c_esc = esc .
EXECUTE.

*************************************************************
SE GUARDAN LOS CÁLCULOS A NIVEL PERSONA.
*************************************************************.

SAVE OUTFILE= 'D:\Desktop\Prueba_2_Diego\Spss_Diego\personas2.sav'
  /COMPRESSED.


*****************************************************************************************
SE FILTRA LA INFORMACION PARA INTEGRANTES DEL HOGAR Y SE AGREGA POR HOGAR
*****************************************************************************************.

FILTER OFF.
USE ALL.
SELECT IF(tot_per = 1).
EXECUTE .

AGGREGATE
 /OUTFILE=
 'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_pers.sav'
  /BREAK= LLAVE_HOGAR_H(A) 
 /tot_perV = SUM(tot_per) / muj15a49 = SUM(muj15a49) / int16a64 = SUM (int16a64)
/int0a15 = SUM (int0a15) / int65a98 = SUM (int65a98) /trabsub = SUM(trabsub) 
/trabind = SUM(trabind)  / trab_s_pag = SUM(trab_s_pago) / segsoc1 = SUM(segsoc1)
/sysss = SUM(sysss)  /systs = SUM(systs) /systi = SUM(systi)
/systsp = SUM(systsp) /syssp = SUM(syssp) / segpop = SUM(seg_pop).


* Se identifica a los jefes trabajadores independientes y su nivel de escolaridad

FILTER OFF.
USE ALL.
SELECT IF (es_jefe = 1).
EXECUTE.

*** Este agrupamiento se pega al archivo la variable directamente
***Deben salir los mismos casos en la tabla de personas (no guardar cambios en personas2)

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=LLAVE_HOGAR_H
  /N_BREAK=N.

FREQUENCIES
  VARIABLES=N_BREAK
  /ORDER=  ANALYSIS .

*** Filtramos los jefes únicos y nos quedamos con algunas variables.

FILTER OFF.
USE ALL.
SELECT IF(N_BREAK = 1).
EXECUTE .

SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\var_jefe.sav'  
/keep= LLAVE_HOGAR_H j_esc jtrab_ind sysjti
 /COMPRESSED.

***abrir base nueva y cerrar personas sin guardar cambios
*** Se abre nuevamente personas (personas2) y se verifica que haya cónyuge único
***agregar escolaridad para pegar en hogares

NEW FILE. 
DATASET NAME cerrar  WINDOW=FRONT.
DATASET ACTIVATE cerrar. 
DATASET CLOSE PERSONAS2.

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\personas2.sav'.
DATASET NAME PERSONAS2 WINDOW=FRONT.

FILTER OFF.
USE ALL.
SELECT IF(tot_per = 1).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF(es_cony = 1).
EXECUTE .

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=LLAVE_HOGAR_H
  /N_BREAK=N.

FREQUENCIES
  VARIABLES=N_BREAK
  /ORDER=  ANALYSIS .

*** Filtramos los cónyuges únicos y nos quedamos con algunas variables.

FILTER OFF.
USE ALL.
SELECT IF(N_BREAK = 1).
EXECUTE .

SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\var_cony.sav'  
/keep= LLAVE_HOGAR_H c_esc
 /COMPRESSED.

*** SE GUARDA LA INFORMACION DE LOS AGREGADOS DE JEFE Y CÓNYUGE Y SE PEGA A LOS HOGARES
***ASÍ COMO EL AGREGADO DE PERSONAS
********************************GENERAR TABLA DE HOGARES (SOC_VIVIENDA + VIVIENDA + DOMICILIO (claves de localidad) + ENCUESTA)
********SE_VIVIENDA:

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\SE_Vivienda.sav'.
DATASET NAME SEVIV WINDOW=FRONT.

DATASET CLOSE PERSONAS2.

*******ETIQUETAS

VARIABLE LABELS  LLAVE_HOGAR_H	"Identifica Encuestas Únicas, se integra por el o los folios declarados por el Programa para determinar 1 encuesta única"
ID_MDM_H	"Identifica Hogares Únicos (RM)"
C_SALUD_HOGA	"Institución de salud en la que se atienden 1"
C_SALUD_HOGB	"Institución de salud en la que se atienden 1"
UT_CUIDA1	"Trabajo no remunerado P1: Cuida sin pago niños, AM, disc."
UT_CUIDA2	"Trabajo no remunerado P2: Cuida sin pago niños, AM, disc."
UT_VOLUN1	"Trabajo no remunerado P1: Trab. Comunitario y voluntario"
UT_VOLUN2	"Trabajo no remunerado P2: Trab. Comunitario y voluntario"
UT_REPARA1	"Trabajo no remunerado P1: Repara vivienda, vehículos, enseres"
UT_REPARA2	"Trabajo no remunerado P2: Repara vivienda, vehículos, enseres"
UT_LIMPIA1	"Trabajo no remunerado P1: Quehaceres de su hogar"
UT_LIMPIA2	"Trabajo no remunerado P2: Quehaceres de su hogar"
UT_ACARREA1	"Trabajo no remunerado P1: Acarrear agua o leña"
UT_ACARREA2	"Trabajo no remunerado P2: Acarrear agua o leña"
CON_REMESA	"Persona que recibe dinero de otros países"
GAS_ALIM	"Gasto en el hogar: bebidas, alimentos"
GAS_VEST	"Gasto en el hogar: compra o reparación de vestido o calzado"
GAS_EDUC	"Gasto en el hogar: artículos y servicios de educación"
COM_DIA	"Número de comidas al día de los integrantes del hogar"
CEREAL	"Consumo por semana de: Cereales y tubérculos"
VERDURAS	"Consumo por semana de: verduras "
FRUTAS	"Consumo por semana de: frutas"
LEGUMINOSAS	"Consumo por semana de: leguminosas"
CARNE_HUEVO	"Consumo por semana de: carne y huevo"
LACTEOS	"Consumo por semana de: lácteos"
GRASAS	"Consumo por semana de: grasas y/o azúcar"
SEG_ALIM_1	"Seguridad alimentaria 18+: poca variedad de alimentos"
SEG_ALIM_2	"Seguridad alimentaria 18+: dejaron de desayunar, comer o cenar"
SEG_ALIM_3	"Seguridad alimentaria 18+: comieron menos de lo que piensa deberían"
SEG_ALIM_4	"Seguridad alimentaria 18+: se quedaron sin comida"
SEG_ALIM_5	"Seguridad alimentaria 18+: sintieron hambre pero no comieron"
SEG_ALIM_A	"Seguridad alimentaria 18+: 1 comida al día o dejaron de comer todo un día"
SEG_ALIM_B	"Seguridad alimentaria -18: poca variedad de alimentos"
SEG_ALIM_C	"Seguridad alimentaria -18: dejaron de desayunar, comer o cenar"
SEG_ALIM_D	"Seguridad alimentaria -18: comieron menos de lo que piensa deberían"
SEG_ALIM_E	"Seguridad alimentaria -18: se quedaron sin comida"
SEG_ALIM_F	"Seguridad alimentaria -18: sintieron hambre pero no comieron"
SEG_ALIM_G	"Seguridad alimentaria -18: 1 comida al día o dejaron de comer todo un día"
DESAY_NIN	"Desayuno -12: lo acostumbran en ese hogar"
DESAY_LUGAR	"Desayuno -12: lugar dónde desayunan"
DESAY_RAZON	"Desayuno -12: razón por la que no desayunan"
CUART	"Cuartos: totales del hogar (contar cocina - no baño)"
CUA_DOR	"Cuartos: número que usan para dormir"
COC_DUER	"Cuartos: donde cocinan tambien duermen"
C_PISO_VIV	"Materiales de la Vivienda: Piso"
CONDI_PISO	"Materiales de la Vivienda: Piso - hundido, agrietado"
CUAR_PIS_T	"Materiales de la Vivienda: Piso de tierra en cuartos donde cocinan o duermen"
C_TECH_VIV	"Materiales de la Vivienda: Techo"
CONDI_TECHO	"Materiales de la Vivienda: Techo - flexión, fracturas, riesgo de caer"
C_MURO_VIV	"Materiales de la Vivienda: Muros"
CONDI_MURO	"Materiales de la Vivienda: Muros - grietas, fisuras, riesgo de caerse"
C_ESCUSADO	"Escusado: tipo de baño en la vivienda"
USO_EXC	"Escusado: exclusivo del hogar o compartido"
C_AGUA_A	"Agua: como se obtiene en la vivienda"
TRAT_AGUA_A	"Agua: se bebe sin tratamiento previo"
TRAT_AGUA_B	"Agua: se hierve"
TRAT_AGUA_C	"Agua: echan cloro"
TRAT_AGUA_D	"Agua: usan filtro"
TRAT_AGUA_E	"Agua: compran agua embotellada o garrafón"
TRAT_AGUA_F	"Agua: otro"
TRAT_AGUA_ESP	"Agua: especificar el otro"
C_CON_DRENA	"Drenaje: tipo del drenaje para aguas sucias"
C_BASURA	"Basura: qué se hace con la basura"
C_COMBUS_COCIN	"Combustible que se usa más para cocinar"
FOGON_CHIM	"Fogón: tipo de fogón para cocinar"
TS_REFRI	"Enseres: Refrigerador"
TS_LAVADORA	"Enseres: Lavadora automática"
TS_VHS_DVD_BR	"Enseres: DVD, Blu-ray, VHS"
TS_VEHI	"Enseres: Vehículo"
TS_TELEFON	"Enseres: Teléfono fijo"
TS_MICRO	"Enseres: Microondas - eléctrico"
TS_COMPU	"Enseres: Computadora"
TS_EST_GAS	"Enseres: Estufa - parrilla de gas"
TS_BOILER	"Enseres: Boiler de gas o solar - calentador de agua"
TS_INTERNET	"Enseres: Internet"
TS_CELULAR	"Enseres: Teléfono celular"
TS_TELEVISION	"Enseres: Televisión"
TS_TV_DIGITAL	"Enseres: Televisión digital"
TS_TV_PAGA	"Enseres: Televisión de paga"
TS_TINACO	"Enseres: Tinaco"
TS_CLIMA	"Enseres: ventilador, enfriador, clima, calefactor"
C_LUZ_ELE	"Luz: Medio por el que se obtiene luz eléctrica"
C_SIT_VIV	"Vivienda: Propia, rentada, prestada o intestada"
ESCRITURA1	"Vivienda: Persona 1 a las que pertenece las escrituras de la vivienda"
ESCRITURA2	"Vivienda: Persona 2 a las que pertenece las escrituras de la vivienda"
ESP_NIVELES	"Vivienda: tiene dos o más niveles"
ESP_CONSTRUC	"Vivienda: tiene espacio disponible para construcción"
CONSTRUC_MED	"Vivienda: medida de espacio para construcción"
ESP_LOCAL	"Vivienda: tiene local anexo"
LOCAL_MED	"Vivienda: medida de espacio del local"
TIE_AGRI	"Tierras: se tiene tierra para actividades de agricultura o forestales"
PROP_TIERRA1	"Tierras: persona 1 a la que pertenecen las tierras"
PROP_TIERRA2	"Tierras: persona 2  a la que pertenecen las tierras"
C_MAIZ	"Tierras: cultiva maiz"
C_FRIJ	"Tierras: cultiva frijol"
C_CERE	"Tierras: cultiva cereales "
C_FRUT	"Tierras: cultiva frutos"
C_CANA	"Tierras: cultiva caña de azúcar"
C_JITO	"Tierras: cultiva jitomate"
C_CHIL	"Tierras: cultiva chile"
C_LIMN	"Tierras: cultiva limón"
C_PAPA	"Tierras: cultiva papa"
C_CAFE	"Tierras: cultiva café"
C_CATE	"Tierras: cultiva aguacate"
C_FORR	"Tierras: cultiva forrajes"
C_OTRO	"Tierras: cultiva otros productos"
C_NING	"Tierras: no se cultiva "
CUL_RIEGO	"Tierras: utiliza sistema de riego"
CUL_MAQUINA	"Tierras: maquinaria (tractor - otros)"
CUL_ANIM	"Tierras: ayuda de animales"
CUL_FERORG	"Tierras: composta - fertilizantes orgánicos"
CUL_FERQUIM	"Tierras: fertilizantes químicos"
CUL_PLAGUI	"Tierras: plaguicidas"
USO_HID_TRA	"Tierras: se utiliza la hidroponía o agricultura de traspatio"
CABALLOS	"Animales: número de caballos"
BURROS	"Animales: número de burros"
BUEYES	"Animales: número de bueyes"
CHIVOS	"Animales: número de chivos"
RESES	"Animales: número de reses"
GALLINAS	"Animales: número de gallinas"
CERDOS	"Animales: número de cerdos"
CONEJOS	"Animales: número de conejos"
PROYECTO	"Proyecto: desean realizar un proyecto productivo o de servicios"
FCH_CREACION	"Atributo de Auditoria - guarda la fecha en que se crea el registro"
USR_CREACION	"Atributo de Auditoria - guarda el usuario que crea el registro"
PISO_PROG	"Materiales de la Vivienda: Piso - lo puso el gobierno"
ESCUSADO_PROG	"Escusado: lo puso el gobierno"
COMPU_PROG	"Enseres: Computadora - la dio el gobierno"
CSC_HOGAR	"Consecutivo hogar CUIS 2012 y 2013".


VALUE LABELS C_SALUD_HOGA C_SALUD_HOGB
 1	"CENTRO DE SALUD, HOSPITAL O INSTITUTO DE LA SECRETARÍA DE SALUD "
2	"IMSS"
3	"IMSS-PROSPERA"
4	"ISSSTE"
5	"OTRO SERVICIO MÉDICO PÚBLICO (PEMEX, DEFENSA, MARINA, DIF)"
6	"CONSULTORIO Y/O HOSPITAL PRIVADO"
7	"CONSULTORIO DE FARMACIA"
8	"CURANDERO, HIERBERO, COMADRONA, BRUJO"
9	"SE AUTOMEDICA"
10	"OTRO"
11	"NO SE ATIENDEN"
98	"NO SABE / NO RESPONDE".

VALUE LABELS UT_CUIDA1
UT_CUIDA2
UT_VOLUN1
UT_VOLUN2
UT_REPARA1
UT_REPARA2
UT_LIMPIA1
UT_LIMPIA2
UT_ACARREA1
UT_ACARREA2
95	"TODOS LOS INTEGRANTES DEL HOGAR "
96	"NO SE REALIZA LA ACTIVIDAD "
97	"PERSONA QUE NO PERTENECE AL HOGAR"
98	"NO SABE/NO RESPONDE".

VALUE LABELS CON_REMESA
1	"SÍ RECIBE DINERO DE OTROS PAÍSES"
2	"NO RECIBE DINERO DE OTROS PAÍSES".

VALUE LABELS DESAY_LUGAR
1	"EN EL HOGAR PROPIO O CON ALGÚN FAMILIAR O CONOCIDO"
2	"EN LA ESCUELA, ESTANCIA O GUARDERÍA"
3	"OTRO LUGAR".

VALUE LABELS DESAY_RAZON
1	"NO LO ACOSTUMBRAN"
2	"NO LES DA HAMBRE"
3	"NO LES ALCANZA EL TIEMPO"
4	"NO LES ALCANZA EL DINERO".

VALUE LABELS C_PISO_VIV
1	"TIERRA"
2	"CEMENTO O FIRME "
3	"MOSAICO, MADERA U OTRO  RECUBRIMIENTO".

VALUE LABELS C_TECH_VIV
1	"MATERIAL DE DESECHO (CARTÓN, HULE, TELA, LLANTAS, ETC.)"
2	"LÁMINA DE CARTÓN"
3	"LÁMINA METÁLICA"
4	"LÁMINA DE ASBESTO"
5	"PALMA O PAJA"
6	"MADERA O TEJAMANIL"
7	"TERRADO CON VIGUERÍA"
8	"TEJA"
9	"LOSA DE CONCRETO O VIGUETAS  CON BOVEDILLA".

VALUE LABELS C_MURO_VIV
1	"MATERIAL DE DESECHO (CARTÓN, HULE, TELA, LLANTAS, ETC.)"
2	"LÁMINA DE CARTÓN"
3	"LÁMINA METÁLICA O DE ASBESTO"
4	"CARRIZO, BAMBÚ O PALMA"
5	"EMBARRO O BAJAREQUE"
6	"MADERA"
7	"ADOBE"
8	"TABIQUE, LADRILLO, BLOCK, PIEDRA, CANTERA, CEMENTO O  CONCRETO".

VALUE LABELS C_ESCUSADO
1	"CON CONEXIÓN DE AGUA/CON DESCARGA DIRECTA DE AGUA"
2	"LE ECHAN AGUA CON CUBETA"
3	"SIN ADMISIÓN DE AGUA  (LETRINA SECA O HÚMEDA)"
4	"POZO U HOYO NEGRO"
97	"NO TIENE".

VALUE LABELS C_AGUA_A
1	"AGUA ENTUBADA DENTRO DE LA VIVIENDA"
2	"AGUA ENTUBADA FUERA DE VIVIENDA, PERO DENTRO DEL TERRENO"
3	"AGUA ENTUBADA DE LLAVE PÚBLICA (O HIDRANTE)"
4	"AGUA ENTUBADA QUE ACARREAN DE OTRA VIVIENDA"
5	"AGUA DE PIPA"
6	"AGUA DE UN POZO, RÍO, LAGO, ARROYO "
7	"AGUA CAPTADA DE LLUVIA U OTRO MEDIO".

VALUE LABELS TS_REFRI
TS_LAVADORA
TS_VHS_DVD_BR
TS_VEHI
TS_TELEFON
TS_MICRO
TS_COMPU
TS_EST_GAS
TS_BOILER
TS_INTERNET
TS_CELULAR
TS_TELEVISION
TS_TV_DIGITAL
TS_TV_PAGA
TS_TINACO
TS_CLIMA
11	"SÍ TIENE Y SÍ SIRVE"
12	"SÍ TIENE Y NO SIRVE"
22	"NO TIENE".

VALUE LABELS C_LUZ_ELE
1	"SERVICIO PÚBLICO"
2	"PLANTA PARTICULAR"
3	"PANEL SOLAR"
4	"OTRA FUENTE"
97	"NO TIENEN LUZ ELÉCTRICA".

VALUE LABELS FOGON_CHIM
10	"FOGÓN DE LEÑA O CARBÓN CON CHIMENEA  FUERA DE LA VIVIENDA"
11	"FOGÓN DE LEÑA O CARBÓN CON CHIMENEA DENTRO DE LA VIVIENDA"
20	"FOGÓN DE LEÑA O CARBÓN SIN CHIMENEA FUERA DE LA VIVIENDA"
21	"FOGÓN DE LEÑA O CARBÓN SIN CHIMENEA DENTRO DE LA VIVIENDA"
30	"FOGÓN ECOLÓGICO DE LEÑA O CARBÓN CON CHIMENEA FUERA DE LA VIVIENDA"
31	"FOGÓN ECOLÓGICO DE LEÑA O CARBÓN CON CHIMENEA DENTRO DE LA VIVIENDA".

VALUE LABELS C_COMBUS_COCIN
1	"GAS DE CILINDRO O TANQUE"
2	"GAS NATURAL O DE TUBERÍA"
3	"ELECTRICIDAD"
4	"OTRO COMBUSTIBLE"
5	"LEÑA O CARBÓN".

VALUE LABELS C_SIT_VIV
1	"PROPIA Y TOTALMENTE PAGADA"
2	"PROPIA Y LA ESTÁ PAGANDO"
3	"PROPIA Y ESTÁ HIPOTECADA"
4	"RENTADA O ALQUILADA"
5	"PRESTADA O LA ESTÁ CUIDANDO"
6	"INTESTADA O ESTÁ EN LITIGIO".

VALUE LABELS ESCRITURA1 ESCRITURA2
96	"ASOCIACIÓN EJIDAL"
97	"NO TIENE ESCRITURAS".

*************REVISAR DUPLICADOS DE BASES
****BORRAR LA VARIABLE MANUAL

DATASET ACTIVATE SEVIV.
* Identificar casos duplicados.
SORT CASES BY LLAVE_HOGAR_H(A).
MATCH FILES
  /FILE=*
  /BY LLAVE_HOGAR_H
  /FIRST=PrimarioPrimero
  /LAST=PrimarioÚltimo.
DO IF (PrimarioPrimero).
COMPUTE  SecuenciaCoincidencia=1-PrimarioÚltimo.
ELSE.
COMPUTE  SecuenciaCoincidencia=SecuenciaCoincidencia+1.
END IF.
LEAVE  SecuenciaCoincidencia.
FORMATS  SecuenciaCoincidencia (f7).
COMPUTE  InDupGrp=SecuenciaCoincidencia>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimarioPrimero InDupGrp SecuenciaCoincidencia.
VARIABLE LABELS  PrimarioÚltimo 'Indicador de cada último caso de coincidencia como primario'.
VALUE LABELS  PrimarioÚltimo 0 'Caso duplicado' 1 'Caso primario'.
VARIABLE LEVEL  PrimarioÚltimo (ORDINAL).
FREQUENCIES VARIABLES=PrimarioÚltimo.
EXECUTE.

*********  VIVIENDA
*****

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\VIVIENDA.sav'.
DATASET NAME VIV WINDOW=FRONT.


*****ETIQUETAS

VARIABLE LABELS LLAVE_HOGAR_H	"Identifica Encuestas Únicas, se integra por el o los folios declarados por el Programa para determinar 1 encuesta única"
ID_MDM_H	"Identifica Hogares Únicos (RM)"
C_TIPO_VIV "Vivienda: Tipo de la vivienda"
TOT_PER_VIV "Total de personas en la vivienda"
TOT_HOG "Total de hogares en la vivienda"
TOT_PER "Total de personas en el hogar"
PER_GASTO "Personas que comparten gastos del hogar"
PER_ALIM  "Personas que comparten alimentos del hogar"
FCH_CREACION	"Atributo de Auditoria - guarda la fecha en que se crea el registro"
USR_CREACION	"Atributo de Auditoria - guarda el usuario que crea el registro"
CSC_HOGAR	"Consecutivo hogar CUIS 2012 y 2013".

VALUE LABELS C_TIPO_VIV
1	"CASA INDEPENDIENTE"
2	"DEPARTAMENTO EN EDIFICIO  / UNIDAD HABITACIONAL"
3	"VIVIENDA O CUARTO EN VECINDAD"
4	"VIVIENDA O CUARTO EN LA AZOTEA"
5	"ANEXO A CASA"
6	"LOCAL NO CONSTRUIDO PARA HABITACIÓN"
7	"VIVIENDA EN TERRENO FAMILIAR  COMPARTIDO"
8	"VIVIENDA MÓVIL"
9	"REFUGIO"
10	"VIVIENDA EN CONSTRUCCIÓN NO HABITADA"
11	"ASILO, ORFANATO O CONVENTO".

******REVISAR DUPLICADOS
***BORRAR MANUAL LA VARIABLE

DATASET ACTIVATE VIV.
* Identificar casos duplicados.
SORT CASES BY LLAVE_HOGAR_H(A).
MATCH FILES
  /FILE=*
  /BY LLAVE_HOGAR_H
  /FIRST=PrimarioPrimero
  /LAST=PrimarioÚltimo.
DO IF (PrimarioPrimero).
COMPUTE  SecuenciaCoincidencia=1-PrimarioÚltimo.
ELSE.
COMPUTE  SecuenciaCoincidencia=SecuenciaCoincidencia+1.
END IF.
LEAVE  SecuenciaCoincidencia.
FORMATS  SecuenciaCoincidencia (f7).
COMPUTE  InDupGrp=SecuenciaCoincidencia>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimarioPrimero InDupGrp SecuenciaCoincidencia.
VARIABLE LABELS  PrimarioÚltimo 'Indicador de cada último caso de coincidencia como primario'.
VALUE LABELS  PrimarioÚltimo 0 'Caso duplicado' 1 'Caso primario'.
VARIABLE LEVEL  PrimarioÚltimo (ORDINAL).
FREQUENCIES VARIABLES=PrimarioÚltimo.
EXECUTE.

******DOMICILIO 

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\DOMICILIO.sav'.
DATASET NAME DOM WINDOW=FRONT.

***ETIQUETAS

VARIABLE LABELS CVE_ENTIDAD_FEDERATIVA "Clave de entidad federativa (INEGI)"
NOM_ENTIDAD_FEDERATIVA "Nombre de entidad federativa (INEGI)"
CVE_MUNICIPIO "Clave de municipio (INEGI)"
NOM_MUNICIPIO "Nombre de municipio (INEGI)"
CVE_LOCALIDAD "Clave de localidad (INEGI)"
NOM_LOCALIDAD "Nombre de localidad (INEGI)".

VALUE LABELS CVE_ENTIDAD_FEDERATIVA 
1 "AGUASCALIENTES" 
2 "BAJA CALIFORNIA" 
3 "BAJA CALIFORNIA SUR" 
4 "CAMPECHE" 
5 "COAHUILA" 
6 "COLIMA" 
7 "CHIAPAS" 
8 "CHIHUAHUA" 
9 "DISTRITO FEDERAL" 
10 "DURANGO" 
11 "GUANAJUATO" 
12 "GUERRERO" 
13 "HIDALGO" 
14 "JALISCO" 
15 "MÉXICO" 
16 "MICHOACÁN" 
17 "MORELOS" 
18 "NAYARIT" 
19 "NUEVO LEÓN" 
20 "OAXACA" 
21 "PUEBLA" 
22 "QUERÉTARO" 
23 "QUINTANA ROO" 
24 "SAN LUIS POTOSÍ" 
25 "SINALOA" 
26 "SONORA" 
27 "TABASCO" 
28 "TAMAULIPAS" 
29 "TLAXCALA" 
30 "VERACRUZ" 
31 "YUCATÁN" 
32 "ZACATECAS".

******REVISAR DUPLICADOS
***BORRAR MANUAL LA VARIABLE

DATASET ACTIVATE DOM.
* Identificar casos duplicados.
SORT CASES BY LLAVE_HOGAR_H(A).
MATCH FILES
  /FILE=*
  /BY LLAVE_HOGAR_H
  /FIRST=PrimarioPrimero
  /LAST=PrimarioÚltimo.
DO IF (PrimarioPrimero).
COMPUTE  SecuenciaCoincidencia=1-PrimarioÚltimo.
ELSE.
COMPUTE  SecuenciaCoincidencia=SecuenciaCoincidencia+1.
END IF.
LEAVE  SecuenciaCoincidencia.
FORMATS  SecuenciaCoincidencia (f7).
COMPUTE  InDupGrp=SecuenciaCoincidencia>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimarioPrimero InDupGrp SecuenciaCoincidencia.
VARIABLE LABELS  PrimarioÚltimo 'Indicador de cada último caso de coincidencia como primario'.
VALUE LABELS  PrimarioÚltimo 0 'Caso duplicado' 1 'Caso primario'.
VARIABLE LEVEL  PrimarioÚltimo (ORDINAL).
FREQUENCIES VARIABLES=PrimarioÚltimo.
EXECUTE.

******ENCUESTA - 

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\ENCUESTA.sav'.
DATASET NAME ENCUE WINDOW=FRONT.

***ETIQUETAS

VARIABLE LABELS  LLAVE_HOGAR_H  "Identifica Encuestas Únicas, se integra por el o los folios declarados por el Programa para determinar 1 encuesta única"
ID_MDM_H "Identifica Hogares Únicos (RM)"
FOLIO_SEDESOL 
FOLIO_CUIS "Consecutivo de la encuesta por herramienta de captura"
FOLIO_PROG_PROY "Folio asignado por el Programa 1"
FOLIO_PROG_PROY2 "Folio asignado por el Programa 2"
C_TIPO_PROC  "Tipo de Proceso"
HORA_INI  "Hora de inicio de la encuesta"
HORA_TERM "Hora de término de la encuesta"
EJERCICIO "Año de formato del instrumento de captura"
FH_LEVANTA "Fecha al iniciar el cuestionario"
C_ORIGEN_ENCUESTA "Tipo de dispositivo de captura"
C_PROGRAMA_SOCIAL "Programa social que recolectó la encuesta"
VCALIDAD "Validación mínima de calidad de datos"
FCH_CREACION "Atributo de Auditoria - guarda la fecha en que se crea el registro"
USO_S "Si la encuesta es nueva o ha sido tomada del SIFODE"
USR_CREACION "Atributo de Auditoria - guarda el usuario que crea el registro".

 * ENVIADO "Si la encuesta ha sido enviada al SIFODE"
SOLO_MODIFICAR "La encuesta no puede ser usada, debido a falta de información"


VALUE LABELS C_TIPO_PROC
1 " Identificación"
2 " Recertificación"
3 " Verificaciones Permanentes de Condiciones Socioeconómicas"
4 " Reevaluación"
5 " Evaluación a solicitud"
6 "Actualización"
7 "Modificación".

VALUE LABELS C_ORIGEN_ENCUESTA
1 "WEB CUIS 2015"
2 "WEB CUIS 2014"
3 "ESCRITORIO CUIS 2015"
4 "ESCRITORIO CUIS 2015 ESTRATEGIA 5.5"
5 "DM CUIS 2015"
6 "DM CUIS 2014"
7 "DM CUIS 2015 ESTRATEGIA 5.5"
8 "VENTANILLAS"
9 "WEB"
10 "DM"
11 "ESCRITORIO".

VALUE LABELS C_PROGRAMA_SOCIAL
1 "3x1"
5 "PET"
6 "PAJA"
7 "POP"
9 "PETI"
13 "PEI"
15 "HABITAT"
19 "PDZP"
21 "PASPRAH"
23 "PPAM"
39 "FONHAPO"
40 "FONART"
41 "GP"
45 "PROSPERA"
47 "CNCH"
65 "SVJF"
66 "OPFF"
67 "FAIS"
68 "DICONSA"
69 "PAL"
70 "INAPAM"
71 "LICONSA"
72 "IMJUVE"
73 "OTRAS"
74 "Unidad Coordinación de Delegaciones".


******REVISAR DUPLICADOS
***BORRAR MANUAL LA VARIABLE

DATASET ACTIVATE ENCUE.
* Identificar casos duplicados.
SORT CASES BY LLAVE_HOGAR_H(A).
MATCH FILES
  /FILE=*
  /BY LLAVE_HOGAR_H
  /FIRST=PrimarioPrimero
  /LAST=PrimarioÚltimo.
DO IF (PrimarioPrimero).
COMPUTE  SecuenciaCoincidencia=1-PrimarioÚltimo.
ELSE.
COMPUTE  SecuenciaCoincidencia=SecuenciaCoincidencia+1.
END IF.
LEAVE  SecuenciaCoincidencia.
FORMATS  SecuenciaCoincidencia (f7).
COMPUTE  InDupGrp=SecuenciaCoincidencia>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimarioPrimero InDupGrp SecuenciaCoincidencia.
VARIABLE LABELS  PrimarioÚltimo 'Indicador de cada último caso de coincidencia como primario'.
VALUE LABELS  PrimarioÚltimo 0 'Caso duplicado' 1 'Caso primario'.
VARIABLE LEVEL  PrimarioÚltimo (ORDINAL).
FREQUENCIES VARIABLES=PrimarioÚltimo.
EXECUTE.

***************************************************************************** Pegar tablas de Hogares (base: sc_vivienda) ********************************************************************

DATASET ACTIVATE SEVIV.
SORT CASES BY LLAVE_HOGAR_H(A).

DATASET ACTIVATE VIV.
SORT CASES BY LLAVE_HOGAR_H(A).

 * DATASET ACTIVATE ENCUE.
 * SORT CASES BY LLAVE_HOGAR_H(A).

DATASET ACTIVATE DOM.
SORT CASES BY LLAVE_HOGAR_H(A).

DATASET ACTIVATE SEVIV.

***Pegado de tablas

MATCH FILES /FILE=*
  /TABLE='VIV'
  /RENAME (USR_CREACION FCH_CREACION CSC_HOGAR ID_MDM_H = d0 d1 d2 d3) 
  /BY LLAVE_HOGAR_H
  /DROP= d0 d1 d2 d3.
EXECUTE.

 * MATCH FILES /FILE=*
  /TABLE='ENCUE'
  /RENAME (USR_CREACION FCH_CREACION CSC_HOGAR ID_MDM_H = d0 d1 d2 d3) 
  /BY LLAVE_HOGAR_H
  /DROP= d0 d1 d2 d3.
 * EXECUTE.

MATCH FILES /FILE=*
  /TABLE='DOM'
  /RENAME (A_ESTATUS A_FCH_CORTE A_MOV A_VIGENTE C_AGEB C_ASENTAMIENTO C_CODIGO_POSTAL 
    C_ENTIDAD_FEDERATIVA C_LOCALIDAD C_MANZANA C_MUNICIPIO C_TERMINO_GENERICO C_TIPO_ADMINISTRACION 
    C_TIPO_ASENTAMIENTO C_TIPO_ENTRE_VIAL_1 C_TIPO_ENTRE_VIAL_2 C_TIPO_MARGEN C_TIPO_TRANSITO 
    C_TIPO_VIAL C_TIPO_VIAL_POS C_VIALIDAD C_VIALIDAD_ENTRE_1 C_VIALIDAD_ENTRE_2 C_VIALIDAD_POS CAMINO 
    CARRETERA CODIGO_CARRETERA CP CSC_HOGAR DESC_UBIC DESTINO DOM_CONOCIDO FCH_CREACION ID_MDM_H 
    KM_VIAL LATITUD LETRA_EXT LETRA_INT LONGITUD M_VIAL NOMBRE_ASEN NOMBRE_ENTRE_VIAL_1 
    NOMBRE_ENTRE_VIAL_2 NOMBRE_VIAL NOMBRE_VIAL_POS NUM_EXT NUM_EXT_ANT NUM_INT NUMEXTNUM2 ORIGEN 
    S_C_TIPO_ASENTAMIENTO S_C_TIPO_ENTRE_VIAL_1 S_C_TIPO_ENTRE_VIAL_2 S_C_TIPO_VIAL S_C_TIPO_VIAL_POS 
    S_CAMINO S_CARRETERA S_CP S_CVE_ENTIDAD_FEDERATIVA S_CVE_LOCALIDAD S_CVE_MUNICIPIO S_DESC_UBIC 
    S_LETRA_EXT S_LETRA_INT S_NOM_ENTIDAD_FEDERATIVA S_NOM_LOCALIDAD S_NOM_MUNICIPIO 
    S_NOMBRE_ASENTAMIENTO S_NOMBRE_ENTRE_VIAL_1 S_NOMBRE_ENTRE_VIAL_2 S_NOMBRE_VIAL S_NOMBRE_VIAL_POS 
    S_NUM_EXT S_NUM_INT S_ORIGEN_DOMICILIO S_TIPOLOC SIN_NUM_EXT SIN_NUM_INT USR_CREACION = d0 d1 d2 d3 
    d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 
    d30 d31 d32 d33 d34 d35 d36 d37 d38 d39 d40 d41 d42 d43 d44 d45 d46 d47 d48 d49 d50 d51 d52 d53 d54 
    d55 d56 d57 d58 d59 d60 d61 d62 d63 d64 d65 d66 d67 d68 d69 d70 d71 d72 d73 d74 d75 d76 d77 d78) 
  /BY LLAVE_HOGAR_H
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 
    d25 d26 d27 d28 d29 d30 d31 d32 d33 d34 d35 d36 d37 d38 d39 d40 d41 d42 d43 d44 d45 d46 d47 d48 d49 
    d50 d51 d52 d53 d54 d55 d56 d57 d58 d59 d60 d61 d62 d63 d64 d65 d66 d67 d68 d69 d70 d71 d72 d73 d74 
    d75 d76 d77 d78.
EXECUTE.

SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\hogares2.sav'
  /COMPRESSED.

***Cerrar tablas

DATASET ACTIVATE VIV.
DATASET CLOSE SEVIV.

DATASET ACTIVATE VIV.
SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\VIVIENDA.sav'
  /COMPRESSED.

DATASET ACTIVATE DOM.
SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\DOMICILIO.sav'
  /COMPRESSED.

 * DATASET ACTIVATE ENCUE.
 * SAVE OUTFILE='I:\calif\calif2\CUIS13\Bases_S\ENCUESTA.sav'
  /COMPRESSED.

GET
  FILE=
   'D:\Desktop\Prueba_2_Diego\Spss_Diego\hogares2.sav'.
DATASET NAME HOGARES2 WINDOW=FRONT.

DATASET ACTIVATE HOGARES2. 
 * DATASET CLOSE ENCUE.
DATASET CLOSE DOM.
DATASET CLOSE VIV.

************************************************PEGAR TABLA DE HOGARES CON AGREGADOS DE PERSONAS + CONYUGE + JEFE ****************

DATASET ACTIVATE HOGARES2. 

SORT CASES BY LLAVE_HOGAR_H(A).

MATCH FILES /FILE=*
 /TABLE=
 'D:\Desktop\Prueba_2_Diego\Spss_Diego\agr_pers.sav'
 /BY LLAVE_HOGAR_H.
EXECUTE.

MATCH FILES /FILE=*
 /TABLE=
 'D:\Desktop\Prueba_2_Diego\Spss_Diego\var_jefe.sav'
 /BY LLAVE_HOGAR_H .
EXECUTE.

MATCH FILES /FILE=*
 /TABLE=
 'D:\Desktop\Prueba_2_Diego\Spss_Diego\var_cony.sav'
 /BY LLAVE_HOGAR_H.
EXECUTE. 

*********************************************************************************COMIENZA CALIFICACIÓN DE HOGARES + PERSONAS *******************
***************CREAR VARIABLES DE LOCALIZACION EN CADENA

STRING CVE_ENT (A2).
STRING CVE_LOC (A9).
STRING CVE_MUN (A5).
EXECUTE.

COMPUTE CVE_ENT= char.LPAD(ltrim(STRING(CVE_ENTIDAD_FEDERATIVA,F2)),2,'0').
COMPUTE CVE_MUN= char.LPAD(ltrim(STRING(CVE_MUNICIPIO,F5)),5,'0').
COMPUTE CVE_LOC= char.LPAD(ltrim(STRING(CVE_LOCALIDAD,F9)),9,'0').
EXECUTE.

*DEPENDENCIA DEMOGRÁFICA*
*****************************************
***** Índice de dependencia demográfica: 
razón entre el número de integrantes del hogar de 0 a 15 años y mayores de 64 años 
respecto a los integrantes del hogar entre 16 y 64 años. (Depdemog).

COMPUTE depdemog = tot_perV.
IF (int16a64 ~= 0) depdemog = (int0a15 + int65a98) / (int16a64) .
EXECUTE .

*****Número de mujeres en el hogar entre 15 y 49 años. (Muj15a49)
******Logaritmo del total de integrantes del hogar. (ltotper).

COMPUTE ltotper=ln(tot_perV).
EXECUTE .


******EDUCATIVAS
*****Indicadora de escolaridad promedio del jefe y cónyuge con primaria completa pero secundaria incompleta. (p_esc3)
**** si alguna scolaridad es sysmis se imputa la del jefe o la del conyuge

FREQUENCIES
  VARIABLES=j_esc c_esc 
  /ORDER=  ANALYSIS .

IF (~sysmis(j_esc) & ~sysmis(c_esc)) p_esc = (c_esc + j_esc) / 2 .
IF (sysmis(c_esc)) p_esc = j_esc .
IF (sysmis(j_esc)) p_esc = c_esc .
EXECUTE.

COMPUTE p_esc3 = p_esc >= 6 & p_esc < 9 .
COMPUTE p_esc4 = p_esc >= 9 & p_esc < 12 .
COMPUTE p_esc5 = p_esc >= 12 .
EXECUTE.

FREQUENCIES
  VARIABLES=p_esc p_esc3  p_esc4 p_esc5
  /ORDER=  ANALYSIS .


*****Indicadora de escolaridad promedio del jefe y cónyuge con secundaria completa o más. (p_esc5b).

IF  (p_esc4 = 1 | p_esc5 = 1) p_esc5b=1.
IF  (p_esc4 = 0 & p_esc5 = 0) p_esc5b=0.
EXECUTE . 

FREQUENCIES
  VARIABLES=p_esc5b
  /ORDER=  ANALYSIS .

**********LABORALES
*********Número de personas del hogar con trabajo subordinado. (trab_sub).

IF (trabsub > 0) trab_sub = trabsub .
IF (trabsub = 0 & systs = 0 & tot_perV > 0) trab_sub = 0 .
EXECUTE.

*****Número de personas del hogar con trabajo independiente. (trab_ind)

IF (trabind > 0) trab_ind = trabind .
IF (trabind = 0 & systi = 0 & tot_perV > 0) trab_ind = 0 .
EXECUTE.

*****Número de personas del hogar con trabajo subordinado sin pago. (trab_s_pago)

IF (trab_s_pag > 0) trab_s_pago = trab_s_pag .
IF (trab_s_pag = 0 & systsp = 0 & tot_perV > 0) trab_s_pago = 0 .
EXECUTE .

FREQUENCIES
  VARIABLES=trab_s_pago trab_ind trab_sub
  /ORDER=  ANALYSIS .

*ACCESO A ALIMENTACIÓN*
*****************************************

FREQUENCIES
  VARIABLES=seg_alim_2 seg_alim_A 
  /ORDER=  ANALYSIS. 

*****Indicadora de que por falta de recursos algún adulto del hogar dejo de 
desayunar, comer o cenar al menos una vez - seguridad alimentaria 1 (seg_alim2)

IF (seg_alim_2 = 1) seg_alim2 = 1 .
IF (seg_alim_2 = 2) seg_alim2 = 0 .

*****Indicadora de que por falta de recursos algún adulto 
comió una vez al día o dejo de comer todo el día - seguridad alimentaria 2 (seg_alim3).

IF (seg_alim_A = 1) seg_alim3 = 1 .
IF (seg_alim_A = 2) seg_alim3 = 0 .
EXECUTE.


*****Indicadora de que se presenta alguno de los dos casos descritos anteriormente - seguridad 
alimentaria conjunta (seg_alim_a2).

IF (seg_alim2 = 1 | seg_alim3 = 1) seg_alim_a2 = 1 .
IF (seg_alim2 = 0 & seg_alim3 = 0) seg_alim_a2 = 0 .
EXECUTE .

FREQUENCIES
  VARIABLES=seg_alim_a2
  /ORDER=  ANALYSIS. 

***ACCESO A SERVICIOS DE SALUD*
******Número de integrantes del hogar que cuentan con seguro popular (seg_pop)

IF (segpop > 0) seg_pop = segpop .
IF (segpop = 0 & syssp = 0 & tot_perV > 0) seg_pop = 0 .
EXECUTE .

FREQUENCIES
  VARIABLES=seg_pop segpop
  /ORDER=  ANALYSIS. 

*****Indicadora de hogar donde al menos uno de sus integrantes cuenta con acceso a servicio médico 
derivado de su trabajo. (ss)

IF (segsoc1 > 0) ss = 1 .
IF (segsoc1 = 0 & sysss = 0 & tot_perV > 0) ss = 0 .
EXECUTE .

FREQUENCIES
  VARIABLES=ss
  /ORDER=  ANALYSIS. 

*****Indicadora de hogar donde el jefe es trabajador independiente y al menos uno de sus integrantes
cuenta con acceso a servicio médico 
derivado de su trabajo. (ssjtrabind)

IF (sysjti=0) ssjtrabind=ss*jtrab_ind.
IF(jtrab_ind=0 &sysjti=0) ssjtrabind=0.
IF(sysjti=1 & ss=0 ) ssjtrabind=0.
EXECUTE .

*ACCESO A OTROS INGRESOS*
*****************************************
*****Indicadora de hogar que recibe remesas. (con_remesas)

FREQUENCIES
  VARIABLES=con_remesa
  /ORDER=  ANALYSIS. 

IF (con_remesa = 2) con_remesas = 0 .
IF (con_remesa = 1) con_remesas = 1 .
EXECUTE .

*********CARACTERÍSTICAS DE LA VIVIENDA, 
ACCESO A SERVICIOS Y POSESIÓN DE BIENES*
*****************************************

FREQUENCIES
  VARIABLES=C_SIT_VIV COC_DUER CUART
  /ORDER=  ANALYSIS. 

*****Indicadora de vivienda propia. (viv_prop).

IF (C_SIT_VIV = 1 | C_SIT_VIV = 2 | C_SIT_VIV = 3 ) viv_prop = 1 .
IF (C_SIT_VIV = 4 | C_SIT_VIV = 5 | C_SIT_VIV = 6) viv_prop = 0 .
EXECUTE.

*****Indicadora de vivienda rentada (viv_rent).

IF (C_SIT_VIV = 4) viv_rent = 1 .
IF (C_SIT_VIV >= 1 & C_SIT_VIV <= 3) | (C_SIT_VIV >= 5 & C_SIT_VIV <= 6) viv_rent= 0 .
EXECUTE.

*****Total de cuartos en la vivienda, sin incluir cocina, pasillos ni baños. (tot_cuar). - se descuenta cocina

IF (COC_DUER = 2 & CUART > 1) tot_cuar = CUART - 1.
IF (COC_DUER = 2 & CUART = 1) tot_cuar = CUART.
IF (COC_DUER = 1) tot_cuar = CUART.
EXECUTE.

FREQUENCIES
  VARIABLES=viv_prop viv_rent tot_cuar
  /ORDER=  ANALYSIS. 

***Tipo de baño - Sin importar si se pone agua manual o no pero es compartido se marca, si es manual el agua y
** es exclusivo también se marca

FREQUENCIES
  VARIABLES=C_ESCUSADO USO_EXC
  /ORDER=  ANALYSIS. 

IF ((C_ESCUSADO = 1 | C_ESCUSADO =2 | C_ESCUSADO = 3 | C_ESCUSADO = 4) & (USO_EXC = 2)) bao1 = 1.
IF (C_ESCUSADO = 97 & sysmis(USO_EXC)) bao1 = 1. 
IF ((C_ESCUSADO = 2 | C_ESCUSADO = 3 | C_ESCUSADO = 4) & (USO_EXC = 1 )) bao1 = 2. 
IF (C_ESCUSADO  = 1 & USO_EXC = 1) bao1 = 3.
EXECUTE .

FREQUENCIES
  VARIABLES=bao1
  /ORDER=  ANALYSIS. 

*****Indicadora de baño de uso exclusivo del hogar con acceso a agua. (bao13)

IF (bao1 = 3)  bao13 =1.
IF (bao1 = 2)  bao13 =0.
IF (bao1 = 1)  bao13 =0.
EXECUTE .

FREQUENCIES
  VARIABLES=bao13
  /ORDER=  ANALYSIS. 

******

FREQUENCIES
  VARIABLES=C_PISO_VIV C_COMBUS_COCI TS_REFRI TS_VEHI TS_COMPU TS_TELEFON TS_MICRO TS_VHS_DVD_BR
  /ORDER=  ANALYSIS. 

*****Indicadora de piso firme en la mayor parte de la vivienda. (piso_fir)

IF ( C_PISO_VIV=2) piso_fir=1.
IF ( C_PISO_VIV=1 | C_PISO_VIV=3 ) piso_fir=0.
EXECUTE.

IF ( C_PISO_VIV=3) piso_rec=1.
IF ( C_PISO_VIV=1 | C_PISO_VIV=2 ) piso_rec=0.
EXECUTE.

*********ACCESO A SERVICIOS BÁSICOS DE LA VIVIENDA
*****Indicadora de utilización de combustibles como leña, carbón o petróleo para cocinar. (combustible).

IF (C_COMBUS_COCI = 4 | C_COMBUS_COCI = 5) combustible = 1.
IF (C_COMBUS_COCI = 1 | C_COMBUS_COCI = 2 | C_COMBUS_COCI = 3) combustible = 0.
EXECUTE.

FREQUENCIES
  VARIABLES=piso_rec piso_fir combustible
  /ORDER=  ANALYSIS. 

*************POSESIÓN DE BIENES
***************************************** TIENE Y NO SIRVE = NO TIENE
*****Indicadora de no tenencia de refrigerador. (sin_refri) 

IF (TS_REFRI = 22 | TS_REFRI = 12) sin_refri=1.
IF (TS_REFRI = 11) sin_refri=0.

*****Indicadora de no tenencia de vehículo. (sin_vehi)

IF (TS_VEHI = 22 | TS_VEHI = 12) sin_vehi=1.
IF (TS_VEHI = 11) sin_vehi=0.

*****Indicadora de no tenencia de computadora. (sin_compu)

IF (TS_COMPU = 22 | TS_COMPU = 12) sin_compu=1.
IF (TS_COMPU = 11) sin_compu=0.

*****Indicadora de no tenencia de videocasetera ni DVD. (sin_vidvd)

IF (TS_VHS_DVD_BR = 22 | TS_VHS_DVD_BR = 12) sin_vidvd=1.
IF (TS_VHS_DVD_BR = 11) sin_vidvd=0.

*****Indicadora de no tenencia de teléfono fijo. (sin_telf)

IF (TS_TELEFON = 22 | TS_TELEFON = 12) sin_telff =1.
IF (TS_TELEFON= 11) sin_telff =0.

*****Indicadora de no tenencia de horno eléctrico o microondas. (sin_horno)

IF (TS_MICRO = 22 | TS_MICRO = 12) sin_horno =1.
IF (TS_MICRO= 11) sin_horno =0.
EXECUTE.

*****************************************************************SE COMIENZA CALIFICACIÓN FINAL - PEGAR LOCALIDADES Y ESTRATOS
**** GUARDAR TABLA DE HOGARES DESPUES DE ABRIR LOCALIDADES

SORT CASES BY
CVE_LOC (A) .

 SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\hogares2.sav' 
  /COMPRESSED.

GET
  FILE='C:\calif\LOCS\C_LOCALIDAD_REV14MARZO16.sav'.
DATASET NAME LOCS WINDOW=FRONT.

SORT CASES BY
CVE_LOC (A) .


DATASET ACTIVATE HOGARES2. 
MATCH FILES /FILE=*
  /TABLE='LOCS'
  /RENAME (AGEB_URBANA C_LOCALIDAD C_LOCALIDAD_CORTA C_MUNICIPIO CVE_LOCALIDAD CVE_LOCALIDAD_CORTA 
    CVE_MUN ESTATUS Estr_nulo FCH_FINAL FCH_INICIO FCH_SISTEMA grado2000 INDICE_REZAGO_SOCIAL irs_2000 
    lugar2000 lugar2005 lugar2010 NOM_LOCALIDAD pobl2000 pobl2005 pobl2010 SITUACION_LOCALIDAD 
    USUARIO_CAPTURA = d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 
    d23) 
  /BY CVE_LOC
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23.
EXECUTE.

********SE CAEN LOCALIDADES VER
*LOCS SIN DATOS

**********************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************.
STRING AMBITO (a2).
COMPUTE AMBITO='U'.
EXECUTE.

COMPUTE ESTRATO= 1.
COMPUTE IRS= -1.5585.
EXECUTE.
**********************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************.

FREQUENCIES VARIABLES=ESTRATO AMBITO 
  /ORDER=ANALYSIS.

DATASET DECLARE agr_locs1.
AGGREGATE
  /OUTFILE='agr_locs1'
  /BREAK=CVE_LOC
  /AMBITO_first=FIRST(AMBITO)
  /TOT_h=N.

DATASET ACTIVATE agr_locs1. 

COMPUTE sin_locs=AMBITO_first="  ". 
EXECUTE. 

FREQUENCIES VARIABLES=AMBITO_first sin_locs 
  /ORDER=ANALYSIS.

IF  (sin_locs = 1) hogsin_locs=TOT_h. 
EXECUTE. 

FREQUENCIES VARIABLES=hogsin_locs sin_locs 
  /STATISTICS=SUM 
  /ORDER=ANALYSIS.


FILTER OFF. 
USE ALL. 
SELECT IF (sin_locs = 1). 
EXECUTE. 
 
DESCRIPTIVES VARIABLES=TOT_h sin_locs hogsin_locs 
  /STATISTICS=SUM.

DATASET ACTIVATE  agr_locs1. 
SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\locs_faltan_23.sav'
  /COMPRESSED.

DATASET ACTIVATE  HOGARES2. 
DATASET COPY  hogs_sin_locs_117.
DATASET ACTIVATE  hogs_sin_locs_117.
FILTER OFF.
USE ALL.
SELECT IF (AMBITO = "   ").
EXECUTE.

DATASET ACTIVATE  hogs_sin_locs_117.
SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\hogs_sin_locs_117.sav'
  /COMPRESSED.

**CERRAR BASES DEJAR PARA REVISIÓN

DATASET ACTIVATE HOGARES2. 
DATASET CLOSE hogs_sin_locs_117. 
DATASET CLOSE LOCS. 
DATASET CLOSE agr_locs1.

*********Crear varibales para estrato y tipo loc

COMPUTE estrato1=(ESTRATO=1).
COMPUTE estrato2=(ESTRATO=2).
COMPUTE estrato3=(ESTRATO=3).
COMPUTE estrato4=(ESTRATO=4).
IF (ESTRATO=4) tipoloc=1.
IF (ESTRATO=1 | ESTRATO=2 | ESTRATO=3) tipoloc=2.
EXECUTE.

FREQUENCIES VARIABLES=tipoloc 
  /STATISTICS=SUM 
  /ORDER=ANALYSIS.

**COMO HAY ESTRATO "0" PONER DATO DE AMBITO
*como el estrato no coincide con el ambito no se puede recodificar directo
*IF (AMBITO="R") tipoloc2=1.
*IF (AMBITO="U") tipoloc2=2.
*EXECUTE.

IF (ESTRATO=0 & (AMBITO="R")) tipoloc=1.
IF (ESTRATO=0 & (AMBITO="U")) tipoloc=2.
EXECUTE.

FREQUENCIES VARIABLES=tipoloc
  /STATISTICS=SUM 
  /ORDER=ANALYSIS.

****IRS DE TABLA

COMPUTE irs=IRS.
EXECUTE.

*** Rural - tipo loc=1 - Estrato =4

if (tipoloc = 1) punt_cte = 7.389 .
if (tipoloc = 1) punt_seg_a = -0.096 * seg_alim_a2 . 
if (tipoloc = 1) punt_bao = 0.074 * bao13 .
if (tipoloc = 1) punt_pisof = 0.096 * piso_fir .
if (tipoloc = 1) punt_pisor = 0.302 * piso_rec .
if (tipoloc = 1) punt_vivr = 0.186 * viv_rent .
if (tipoloc = 1) punt_cuar = 0.024 * tot_cuar .
if (tipoloc = 1) punt_lpers = -0.624 * ltotper .
if (tipoloc = 1) punt_dep = -0.060 * depdemog .
if (tipoloc = 1) punt_pesc3 = 0.137 * p_esc3 .
if (tipoloc = 1) punt_pesc5 = 0.313 * p_esc5b .
if (tipoloc = 1) punt_trasu = 0.374 * trab_sub .
if (tipoloc = 1) punt_train = 0.101 * trab_ind .
if (tipoloc = 1) punt_refri = -0.121 * sin_refri .
if (tipoloc = 1) punt_vehi = -0.197 * sin_vehi .
if (tipoloc = 1) punt_vidvd = -0.111 * sin_vidvd .
if (tipoloc = 1) punt_horno = -0.114 * sin_horno .
if (tipoloc = 1) punt_combu = -0.271 * combustible .
if (tipoloc = 1) punt_ss = 0.388 * ss .
if (tipoloc = 1) punt_sstri = 0.219 * ssjtrabind .
if (tipoloc = 1) punt_irs = -0.071 * irs .
if (tipoloc = 1) punt_rem = 0.279 * con_remesas .
EXECUTE.

*** Urbano / tipoloc=2 - Estrato de 1 a 3

if (tipoloc = 2) punt_cte = 8.245 .
if (tipoloc = 2) punt_sega2 = -0.100 * seg_alim2 . 
if (tipoloc = 2) punt_sega3 = -0.058 * seg_alim3 . 
if (tipoloc = 2) punt_bao = 0.015 * bao13 .
if (tipoloc = 2) punt_pisor = 0.135 * piso_rec .
if (tipoloc = 2) punt_vivp = 0.035 * viv_prop .
if (tipoloc = 2) punt_vivr = 0.183 * viv_rent .
if (tipoloc = 2) punt_cuar = 0.051 * tot_cuar.
if (tipoloc = 2) punt_muj = -0.027 * muj15a49 .
if (tipoloc = 2) punt_lpers = -0.737 * ltotper .
if (tipoloc = 2) punt_dep = -0.034 * depdemog .
if (tipoloc = 2) punt_pesc3 = 0.066 * p_esc3 .
if (tipoloc = 2) punt_pesc5 = 0.257 * p_esc5b .
if (tipoloc = 2) punt_trasu = 0.240 * trab_sub .
if (tipoloc = 2) punt_train = 0.172 * trab_ind .
if (tipoloc = 2) punt_trasp = 0.060 * trab_s_pago .
if (tipoloc = 2) punt_refri = -0.023 * sin_refri .
if (tipoloc = 2) punt_vehi = -0.230 * sin_vehi .
if (tipoloc = 2) punt_compu = -0.288 * sin_compu .
if (tipoloc = 2) punt_vidvd = -0.128 * sin_vidvd .
if (tipoloc = 2) punt_telf = -0.072 * sin_telff .
if (tipoloc = 2) punt_horno = -0.115 * sin_horno .
if (tipoloc = 2) punt_combu = -0.112 * combustible .
if (tipoloc = 2) punt_segp = -0.009 * seg_pop .
if (tipoloc = 2) punt_ss = 0.224 * ss .
if (tipoloc = 2) punt_sstri = 0.055 * ssjtrabind .
if (tipoloc = 2) punt_irs = -0.047 * irs .
if (tipoloc = 2) punt_rem = 0.078 * con_remesas .
if (tipoloc = 2) punt_est1 = 0.058 * estrato1 .
if (tipoloc = 2) punt_est2 = 0.054 * estrato2 .
EXECUTE.

   *** sysmis o missing values

compute sys1_seg_a = sysmis(punt_seg_a) .
compute sys1_sega2 = sysmis(punt_sega2) .
compute sys1_sega3 = sysmis(punt_sega3) .
compute sys1_bao = sysmis(punt_bao) .
compute sys1_pisof = sysmis(punt_pisof) .
compute sys1_pisor = sysmis(punt_pisor) .
compute sys1_vivp = sysmis(punt_vivp) .
compute sys1_vivr = sysmis(punt_vivr) .
compute sys1_cuar = sysmis(punt_cuar) .
compute sys1_muj = sysmis(punt_muj) .
compute sys1_lpers = sysmis(punt_lpers) .
compute sys1_dep = sysmis(punt_dep) .
compute sys1_pesc3 = sysmis(punt_pesc3) .
compute sys1_pesc5 = sysmis(punt_pesc5) .
compute sys1_trasu = sysmis(punt_trasu) .
compute sys1_train = sysmis(punt_train) .
compute sys1_trasp = sysmis(punt_trasp) .
compute sys1_refri = sysmis(punt_refri) .
compute sys1_vehi = sysmis(punt_vehi) .
compute sys1_compu = sysmis(punt_compu) .
compute sys1_vidvd = sysmis(punt_vidvd) .
compute sys1_telf = sysmis(punt_telf) .
compute sys1_horno = sysmis(punt_horno) .
compute sys1_combu = sysmis(punt_combu) .
compute sys1_segp = sysmis(punt_segp) .
compute sys1_ss = sysmis(punt_ss) .
compute sys1_sstri = sysmis(punt_sstri) .
compute sys1_irs = sysmis(punt_irs) .
compute sys1_rem = sysmis(punt_rem) .
compute sys1_est1 = sysmis(punt_est1) .
compute sys1_est2 = sysmis(punt_est2) .
EXECUTE.

*** Rural - si se tienen valores perdidos de las variable (sysmis o missing values)

if (tipoloc =1 & sysmis(seg_alim_a2)) punt1_seg_a = -0.096 * 0.258. 
if (tipoloc =1 & ~sysmis(seg_alim_a2)) punt1_seg_a = punt_seg_a. 
if (tipoloc =1 & sysmis(bao13)) punt1_bao = 0.074 * 0.226 .
if (tipoloc =1 & ~sysmis(bao13)) punt1_bao = punt_bao .
if (tipoloc =1 & sysmis(piso_fir)) punt1_pisof = 0.096 * 0.702 .
if (tipoloc =1 & ~sysmis(piso_fir)) punt1_pisof =  punt_pisof .
if (tipoloc =1 & sysmis(piso_rec)) punt1_pisor = 0.302 * 0.104 .
if (tipoloc =1 & ~sysmis(piso_rec)) punt1_pisor = punt_pisor .
if (tipoloc =1 & sysmis(viv_rent)) punt1_vivr = 0.186 * 0.019 .
if (tipoloc =1 & ~sysmis(viv_rent)) punt1_vivr = punt_vivr .
if (tipoloc =1 & sysmis(tot_cuar)) punt1_cuar = 0.024 * 2.434 .
if (tipoloc =1 & ~sysmis(tot_cuar)) punt1_cuar = punt_cuar .
if (tipoloc =1 & sysmis(ltotper)) punt1_lpers = -0.624 * 1.320 .
if (tipoloc =1 & ~sysmis(ltotper)) punt1_lpers = punt_lpers .
if (tipoloc =1 & sysmis(depdemog)) punt1_dep = -0.060 * 0.985 .
if (tipoloc =1 & ~sysmis(depdemog)) punt1_dep = punt_dep .
if (tipoloc =1 & sysmis(p_esc3)) punt1_pesc3 = 0.137 * 0.226 .
if (tipoloc =1 & ~sysmis(p_esc3)) punt1_pesc3 = punt_pesc3 .
if (tipoloc =1 & sysmis(p_esc5b)) punt1_pesc5 = 0.313 * 0.146 .
if (tipoloc =1 & ~sysmis(p_esc5b)) punt1_pesc5 = punt_pesc5 .
if (tipoloc =1 & sysmis(trab_sub)) punt1_trasu = 0.374 * 0.860 .
if (tipoloc =1 & ~sysmis(trab_sub)) punt1_trasu = punt_trasu .
if (tipoloc =1 & sysmis(trab_ind)) punt1_train = 0.101 * 0.515 .
if (tipoloc =1 & ~sysmis(trab_ind)) punt1_train = punt_train .
if (tipoloc =1 & sysmis(sin_refri)) punt1_refri = -0.121 * 0.399 .
if (tipoloc =1 & ~sysmis(sin_refri)) punt1_refri = punt_refri .
if (tipoloc =1 & sysmis(sin_vehi)) punt1_vehi = -0.197 * 0.718 .
if (tipoloc =1 & ~sysmis(sin_vehi)) punt1_vehi = punt_vehi .
if (tipoloc =1 & sysmis(sin_vidvd)) punt1_vidvd = -0.111 * 0.645 .
if (tipoloc =1 & ~sysmis(sin_vidvd)) punt1_vidvd = punt_vidvd  .
if (tipoloc =1 & sysmis(sin_horno)) punt1_horno = -0.114 * 0.829 .
if (tipoloc =1 & ~sysmis(sin_horno)) punt1_horno = punt_horno .
if (tipoloc =1 & sysmis(combustible)) punt1_combu = -0.271 * 0.516 .
if (tipoloc =1 & ~sysmis(combustible)) punt1_combu = punt_combu .
if (tipoloc =1 & sysmis(ss)) punt1_ss = 0.388 * 0.158 .
if (tipoloc =1 & ~sysmis(ss)) punt1_ss = punt_ss .
if (tipoloc =1 & sysmis(ssjtrabind)) punt1_sstri = 0.219 * 0.026 .
if (tipoloc =1 & ~sysmis(ssjtrabind)) punt1_sstri = punt_sstri .
if (tipoloc =1 & sysmis(irs)) punt1_irs = -0.071 * 0.024 .
if (tipoloc =1 & ~sysmis(irs)) punt1_irs = punt_irs .
if (tipoloc =1 & sysmis(con_remesas)) punt1_rem = 0.279 * 0.114 .
if (tipoloc =1 & ~sysmis(con_remesas)) punt1_rem = punt_rem .
execute .

*** Urbano - si se tienen valores perdidos de las variable (sysmis o missing values)

if (tipoloc =2 & sysmis(seg_alim2)) punt1_sega2 = -0.100 * 0.130. 
if (tipoloc =2 & ~sysmis(seg_alim2)) punt1_sega2 = punt_sega2. 
if (tipoloc =2 & sysmis(seg_alim3)) punt1_sega3 = -0.058 * 0.084  . 
if (tipoloc =2 & ~sysmis(seg_alim3)) punt1_sega3 = punt_sega3. 
if (tipoloc =2 & sysmis(bao13)) punt1_bao = 0.015 * 0.711 .
if (tipoloc =2 & ~sysmis(bao13)) punt1_bao = punt_bao .
if (tipoloc =2 & sysmis(piso_rec)) punt1_pisor = 0.135 * 0.464 .
if (tipoloc =2 & ~sysmis(piso_rec)) punt1_pisor = punt_pisor .
if (tipoloc =2 & sysmis(viv_prop)) punt1_vivp =  0.035 * 0.676 .
if (tipoloc =2 & ~sysmis(viv_prop)) punt1_vivp =  punt_vivp .
if (tipoloc =2 & sysmis(viv_rent)) punt1_vivr = 0.183 * 0.173   .
if (tipoloc =2 & ~sysmis(viv_rent)) punt1_vivr = punt_vivr .
if (tipoloc =2 & sysmis(tot_cuar)) punt1_cuar = 0.051 * 3.164  .
if (tipoloc =2 & ~sysmis(tot_cuar)) punt1_cuar = punt_cuar .
if (tipoloc =2 & sysmis(muj15a49)) punt1_muj = -0.027 *  1.098.
if (tipoloc =2 & ~sysmis(muj15a49)) punt1_muj = punt_muj .
if (tipoloc =2 & sysmis(ltotper)) punt1_lpers = -0.737 * 1.230 .
if (tipoloc =2 & ~sysmis(ltotper)) punt1_lpers = punt_lpers .
if (tipoloc =2 & sysmis(depdemog)) punt1_dep =  -0.034 * 0.706   .
if (tipoloc =2 & ~sysmis(depdemog)) punt1_dep = punt_dep .
if (tipoloc =2 & sysmis(p_esc3)) punt1_pesc3 = 0.066 * 0.250  .
if (tipoloc =2 & ~sysmis(p_esc3)) punt1_pesc3 = punt_pesc3 .
if (tipoloc =2 & sysmis(p_esc5b)) punt1_pesc5 = 0.257 * 0.486  .
if (tipoloc =2 & ~sysmis(p_esc5b)) punt1_pesc5 = punt_pesc5 .
if (tipoloc =2 & sysmis(trab_sub)) punt1_trasu = 0.240 * 1.294 .
if (tipoloc =2 & ~sysmis(trab_sub)) punt1_trasu = punt_trasu .
if (tipoloc =2 & sysmis(trab_ind)) punt1_train = 0.172 * 0.304 .
if (tipoloc =2 & ~sysmis(trab_ind)) punt1_train = punt_train .
if (tipoloc =2 & sysmis(trab_s_pago)) punt1_trasp =  0.060 * 0.062.
if (tipoloc =2 & ~sysmis(trab_s_pago)) punt1_trasp = punt_trasp.
if (tipoloc =2 & sysmis(sin_refri)) punt1_refri = -0.023 * 0.117 .
if (tipoloc =2 & ~sysmis(sin_refri)) punt1_refri = punt_refri .
if (tipoloc =2 & sysmis(sin_vehi)) punt1_vehi = -0.230 * 0.543   .
if (tipoloc =2 & ~sysmis(sin_vehi)) punt1_vehi = punt_vehi .
if (tipoloc =2 & sysmis(sin_compu)) punt1_compu = -0.288 *  0.726.
if (tipoloc =2 & ~sysmis(sin_compu)) punt1_compu = punt_compu .
if (tipoloc =2 & sysmis(sin_vidvd)) punt1_vidvd = -0.128 * 0.344.
if (tipoloc =2 & ~sysmis(sin_vidvd)) punt1_vidvd = punt_vidvd  .
if (tipoloc =2 & sysmis(sin_telff)) punt1_telf  = -0.072 *  0.458.
if (tipoloc =2 & ~sysmis(sin_telff)) punt1_telf  = punt_telf   .
if (tipoloc =2 & sysmis(sin_horno)) punt1_horno = -0.115 * 0.503.
if (tipoloc =2 & ~sysmis(sin_horno)) punt1_horno = punt_horno .
if (tipoloc =2 & sysmis(combustible)) punt1_combu = -0.112 * 0.048   .
if (tipoloc =2 & ~sysmis(combustible)) punt1_combu = punt_combu .
if (tipoloc =2 & sysmis(seg_pop)) punt1_segp = -0.009 * 0.520.
if (tipoloc =2 & ~sysmis(seg_pop)) punt1_segp = punt_segp .
if (tipoloc =2 & sysmis(ss)) punt1_ss =  0.224 * 0.556   .
if (tipoloc =2 & ~sysmis(ss)) punt1_ss = punt_ss .
if (tipoloc =2 & sysmis(ssjtrabind)) punt1_sstri = 0.055 * 0.053 .
if (tipoloc =2 & ~sysmis(ssjtrabind)) punt1_sstri = punt_sstri .
if (tipoloc =2 & sysmis(irs)) punt1_irs = -0.047 * -1.163  .
if (tipoloc =2 & ~sysmis(irs)) punt1_irs = punt_irs .
if (tipoloc =2 & sysmis(con_remesas)) punt1_rem = 0.078 *  0.039.
if (tipoloc =2 & ~sysmis(con_remesas)) punt1_rem = punt_rem .
if (tipoloc =2 & sysmis(estrato1)) punt1_est1 = 0.058 * 0.657  .
if (tipoloc =2 & ~sysmis(estrato1)) punt1_est1 = punt_est1 .
if (tipoloc =2 & sysmis(estrato2)) punt1_est2 = 0.054 * 0.178 .
if (tipoloc =2 & ~sysmis(estrato2)) punt1_est2 = punt_est2 .
EXECUTE.

*** Rural - cálculo de puntaje

IF (tipoloc = 1) punt_i = punt_cte + punt1_seg_a +punt1_bao + punt1_pisof  + punt1_pisor + punt1_vivr + 
punt1_cuar + punt1_lpers+ punt1_dep +punt1_pesc3 + punt1_pesc5 +punt1_trasu + punt1_train + punt1_refri +
 punt1_vehi + punt1_vidvd +punt1_horno + punt1_combu+punt1_ss + punt1_sstri + punt1_irs + punt1_rem .
EXECUTE.

*** Urbano - cálculo de puntaje

IF(tipoloc = 2) punt_i = punt_cte + punt1_sega2 + punt1_sega3 +punt1_bao + punt1_pisor + punt1_vivp +
 punt1_vivr + punt1_cuar + punt1_muj + punt1_lpers + punt1_dep +punt1_pesc3 + punt1_pesc5 +punt1_trasu +
 punt1_train + punt1_trasp + punt1_refri + punt1_vehi + punt1_compu + punt1_vidvd+ punt1_telf +punt1_horno + 
punt1_combu+ punt1_segp+punt1_ss + punt1_sstri + punt1_irs + punt1_rem + punt1_est1 + punt1_est2 .
EXECUTE.

IF (tipoloc=1 | tipoloc=2)  ing_est_i = exp(punt_i) .
EXECUTE.

***Líneas de corte de CONEVAL
**Linea de Bienestar Mínimo (agosto 12)

IF (tipoloc=1) lbm=800.26.
IF (tipoloc=2) lbm=1125.42.

**Linea de Bienestar Mínimo (agosto 12)

IF (tipoloc=1) lb=1489.78.
IF (tipoloc=2) lb=2328.82.
EXECUTE.

****CLASIFICACIÓN DE INGRESO RESPECTO LÍNEAS DE CONEVAL

COMPUTE pob_lbm = (ing_est_i < lbm).
COMPUTE pob_lb = (ing_est_i < lb).
EXECUTE.

FREQUENCIES VARIABLES=pob_lbm pob_lb
  /STATISTICS=SUM 
  /ORDER=ANALYSIS.

*** se suman las medias

If(tipoloc = 1 & (sys1_trasu=1 | sys1_train=1)) sys1_trab = 1 .
If(tipoloc = 1 & (sys1_trasu=0 & sys1_train=0)) sys1_trab = 0 .
If(tipoloc = 2 & (sys1_trasu=1 | sys1_train=1 | sys1_trasp=1)) sys1_trab = 1 .
If(tipoloc = 2 & (sys1_trasu=0 & sys1_train=0 & sys1_trasp=0)) sys1_trab = 0 .
If(tipoloc = 1 & (sys1_pisof=1 | sys1_pisor=1)) sys1_piso = 1 .
If(tipoloc = 1 & (sys1_pisof=0 & sys1_pisor=0)) sys1_piso = 0 .
If(tipoloc = 2 & (sys1_pisor=1)) sys1_piso = 1 .
If(tipoloc = 2 & (sys1_pisor=0)) sys1_piso = 0 .
If(tipoloc = 1 & (sys1_vivr=1 )) sys1_viv = 1 .
If(tipoloc = 1 & (sys1_vivr=0 )) sys1_viv = 0 .
If(tipoloc = 2 & (sys1_vivp=1 | sys1_vivr=1)) sys1_viv = 1 .
If(tipoloc = 2 & (sys1_vivp=0 & sys1_vivr=0)) sys1_viv = 0 .
If(sys1_pesc3=1 | sys1_pesc5=1) sys1_pesc = 1 .
If(sys1_pesc3=0 & sys1_pesc5=0) sys1_pesc = 0 .
Execute .

if (tipoloc = 1) sys1_i = sys1_seg_a +sys1_bao + sys1_piso + sys1_viv + sys1_cuar + sys1_lpers
+ sys1_dep +sys1_pesc +sys1_trab + sys1_refri + sys1_vehi + sys1_vidvd +sys1_horno 
+ sys1_combu+sys1_ss + sys1_sstri + sys1_irs + sys1_rem .

if (tipoloc = 2) sys1_i = sys1_sega2 + sys1_sega3 +sys1_bao + sys1_piso + sys1_viv + sys1_cuar + 
sys1_muj + sys1_lpers + sys1_dep +sys1_pesc +sys1_trab + sys1_refri + sys1_vehi + sys1_compu + sys1_vidvd
+ sys1_telf +sys1_horno + sys1_combu+ sys1_segp+sys1_ss + sys1_sstri + sys1_irs + sys1_rem + sys1_est1 
+ sys1_est2 .
execute .

FREQUENCIES VARIABLES=sys1_i
  /STATISTICS=SUM 
  /ORDER=ANALYSIS.

***frec tipo loc 1
**SE PUEDE SEGMENTAR POR TIPOLOC

SORT CASES  BY tipoloc. 
SPLIT FILE SEPARATE BY tipoloc.

FREQUENCIES VARIABLES=sys1_seg_a sys1_bao sys1_piso sys1_viv sys1_cuar 
sys1_lpers sys1_dep sys1_pesc sys1_trab sys1_refri sys1_vehi sys1_vidvd sys1_horno 
sys1_combu sys1_ss sys1_sstri sys1_irs sys1_rem 
  /ORDER=ANALYSIS.

***frec tipo loc 2

FREQUENCIES VARIABLES=sys1_sega2  sys1_sega3 sys1_bao  sys1_piso  sys1_viv  sys1_cuar  
sys1_muj  sys1_lpers  sys1_dep sys1_pesc sys1_trab  sys1_refri  sys1_vehi  sys1_compu  sys1_vidvd
 sys1_telf sys1_horno  sys1_combu sys1_segp sys1_ss  sys1_sstri  sys1_irs  sys1_rem  sys1_est1 
 sys1_est2 
  /ORDER=ANALYSIS.


***En ambos casos las medias se imputan en su mayoría por IRS y trabajo, no es representativa la cantidad

SORT CASES BY LLAVE_HOGAR_H(A).

SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\hogares2.sav' 
  /COMPRESSED.

****SELECCIONAR HOGARES VÁLIDOS - QUITAR LOCALIDADES NO EN CENFEMUL

DATASET COPY  HOGARES_CALIF. 
DATASET ACTIVATE  HOGARES_CALIF. 
FILTER OFF. 
USE ALL. 
SELECT IF (AMBITO  ~= "  "). 
EXECUTE.  
DATASET ACTIVATE  HOGARES_CALIF.

ALTER TYPE 
punt_cte  punt1_seg_a		punt1_sega2   	punt1_sega3
punt1_bao			punt1_pisof			punt1_pisor		punt1_vivp
punt1_vivr			punt1_cuar			punt1_lpers		punt1_muj
punt1_dep			punt1_pesc3		punt1_pesc5	punt1_trasu
punt1_train			punt1_trasp			punt1_refri		punt1_vehi			
punt1_compu		punt1_telf 			punt1_vidvd		punt1_horno
punt1_combu		punt1_ss 			punt1_sstri		punt1_segp
punt1_irs			punt1_rem 			punt1_est1		punt1_est2
ing_est_i(f12.4).

SAVE OUTFILE='D:\Desktop\Prueba_2_Diego\Spss_Diego\HOGARES_CALIF.sav' 
  /COMPRESSED.

*********************************************************************************GUARDAR TABLA DE HOGARES_CALIF Y ESTIMAR CARENCIAS
*********************************************************************************SE PUEDEN RETOMAR VARIABLES DE LAS TABLAS TRABAJADAS EN PERSONAS2 Y HOGARES2
**********************************************************************************
***ABRIR SINTAX - CARENCIAS 2016 SEDESOL ************************
***










PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="C:\Users\jcmo\Google Drive\JCMO.Sedesol.V\BasesDatos\CUIS\CUIS\integrante_cuis.csv"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  LLAVE_HOGAR_H AUTO
  C_INTEGRANTE AUTO
  ID_MDM_H AUTO
  ID_MDM_P AUTO
  C_CON_RES AUTO
  C_CD_PARENTESCO AUTO
  RESIDE AUTO
  PADRE AUTO
  MADRE AUTO
  C_CD_EDO_CIVIL AUTO
  EDAD AUTO
  VAL_NB_RENAPO AUTO
  NUM_PER AUTO
  FCH_CREACION AUTO
  USR_CREACION AUTO
  S_VAL_NB_RENAPO AUTO
  CONYUGE AUTO
  CSC_HOGAR AUTO
  /MAP.
RESTORE.

CACHE.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.
