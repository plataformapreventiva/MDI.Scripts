mdi.pred <- function(caso,localidades,lineas_bienestar,
                     modelo_actual_rur,modelo_actual_urb, 
                     modelo_lm_rur,modelo_lm_urb,
                     modelo_qr_rur_lb,modelo_qr_urb_lb, 
                     modelo_qr_rur_lbm,modelo_qr_urb_lbm,
                     modelo_seg_rur,modelo_seg_rur_tab,
                     modelo_seg_urb,modelo_seg_urb_tab){
  #
  # Distribucion predictiva del Modelo de Ingreso Sedesol
  #
  # Input:
  
  # Empate RURURB
  caso <- merge(caso,
                localidades,
                by=c("ENTIDAD","MUN","LOC"),
                all.x = TRUE,
                sort = FALSE)

#  caso
  
  # Tipos de variables p/ segmentacion
  # Numericas
  caso[,var_enighcuis_seg_num] <- lapply(caso[,var_enighcuis_seg_num],as.numeric)
  # Categoricas
  caso[,var_enighcuis_seg_cat] <- lapply(caso[,var_enighcuis_seg_cat],factor)
  

  # Definicion del tipo de variables en `caso` en lista
  caso.list <- list(caso[,var_enighcuis_seg_num],caso[,var_enighcuis_seg_cat])
  caso.x <- cbind(1,caso[,c(var_enighcuis_reg_num,var_enighcuis_reg_cat)]) 

  # Prediccion de Segmento & Probabilidad
  # Rural
  if(caso$RURURB==1){
    # Segmento
    caso$pred.segm <- classifyKamila(modelo_seg_rur, caso.list)
    # Modelo Actual
    caso$pred.mactual.lev <- predict.lm(object=modelo_actual_rur,newdata=caso.x)
    if(caso$pred.mactual.lev<=lb_rur){caso$pred.mactual.lb <- 1}else{caso$pred.mactual.lb <- 0}
    if(caso$pred.mactual.lev<=lbm_rur){caso$pred.mactual.lbm <- 1}else{caso$pred.mactual.lbm <- 0}
  }
  # Urbano
  if(caso$RURURB==2){
    # Segmento
    caso$pred.segm <- classifyKamila(modelo_seg_urb, caso.list)
    # Modelo Actual
    caso$pred.mactual.lev <- predict.lm(object=modelo_actual_urb,newdata=caso.x)
    if(caso$pred.mactual.lev<=lb_urb){caso$pred.mactual.lb <- 1}else{caso$pred.mactual.lb <- 0}
    if(caso$pred.mactual.lev<=lbm_urb){caso$pred.mactual.lbm <- 1}else{caso$pred.mactual.lbm <- 0}
    # Modelo Blasso
    modelo_blasso_urb$beta
  }
  
  # Output
  return(caso)
}