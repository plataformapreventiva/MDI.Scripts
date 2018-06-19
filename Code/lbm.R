
lp1_urb <- 1310.94
lp1_rur <- 933.20


lp2_urb <- 2660.40
lp2_rur <- 1715.57

LB <- array(NaN, dim=c(2,2))
dim(LB)

colnames(LB) <- c("rural","urbano")
rownames(LB) <- c("lbm","lb")

LB["lbm","rural"] <- 933.20 # lp1_rur <- rual lbm
LB["lb","rural"] <- 1715.57 # lp2_rur <- rual lb
LB["lbm","urbano"] <- 1310.94 # lp1_urb <- urbano lbm
LB["lb","urbano"] <- 2660.40 # lp2_urb <- urbano lb
LB