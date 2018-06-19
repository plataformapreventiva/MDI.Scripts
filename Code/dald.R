dald <- function(x, sigma, p){
  #
  # Density evaluation of the ALD
  #
  kernel <- ifelse (
    x >= 0,
    exp(- p * x / sigma),
    exp((1 - p) * x / sigma)
  )
  d <- (p * (1 - p) / sigma) * kernel
  return(d)
}
