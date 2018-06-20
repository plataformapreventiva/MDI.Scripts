rm(list=ls())

# Segmentación
var_enighcuis_seg_num <- c("int0a12","int12a64","int65a98",
                           "trab_sub","trab_ind","trab_s_pago",
                           "seg_pop","ss",
                           "depdemog","muj12a49","tot_per","tot_cuar")

var_enighcuis_seg_cat <- c("p_esc3","p_esc5b",
                           "seg_alim2","seg_alim3","seg_alim_a",
                           "jtrab_ind","ssjtrabind",
                           "con_remesas")  

# Regresion
var_enighcuis_reg_num <- c("int0a12","int12a64","int65a98",
                           "trab_sub","trab_ind","trab_s_pago",
                           "seg_pop","ss",
                           "depdemog","muj12a49","tot_per","tot_cuar")

var_enighcuis_reg_cat <- c("p_esc3","p_esc5b",
                           "seg_alim2","seg_alim3","seg_alim_a",
                           "jtrab_ind","ssjtrabind",
                           "con_remesas",
                           "viv_prop","viv_rent",
                           "bao13",
                           "piso_fir","piso_rec",
                           "combustible",
                           "sin_refri","sin_vehi",
                           "sin_compu","sin_vidvd",
                           "sin_telef","sin_horno")  

# Unicas
var_enighcuis_num <- unique(c(var_enighcuis_seg_num,var_enighcuis_reg_num))
var_enighcuis_cat <- unique(c(var_enighcuis_seg_cat,var_enighcuis_reg_cat))

save(var_enighcuis_num,var_enighcuis_cat,
     var_enighcuis_seg_num,var_enighcuis_seg_cat,
     var_enighcuis_reg_num,var_enighcuis_reg_cat,
     file="../Datos.Modelo/mdi_variables_modelo.RData")
