dald.trunc <- function(y, mu, sigma, tau) {
  trunc <- -mu/sigma
  if ((y == 0) & (trunc <= 0)){
    u <- runif(n = 1)
    fn_val <- -(abs(trunc) - log(u)) / (1 - tau)
    } else if ((y == 1) & (trunc >= 0)) {
      u <- runif(n = 1)
      fn_val <- trunc - log(u) / p
      } else {
        g <- pALD(q = trunc, mu = 0, sigma = 1, tau = tau)
        if (y == 1) {
          min <- g
          max <- 1
          } else {
            min = 0
            max = g
            }
        u <- runif(n = 1)
        u <- min + (max - min) * u
        fn_val <- qALD(p = u, mu = 0, sigma = 1, tau = tau)
        }
  fn_val <- mu + fn_val * sigma
}