rald <- function(n, sigma = 1, p = 0.5){
  #
  # Generates random samples from ALD(alpha) singular
  #
  x <- seq(-10, 10, 0.05)
  prob <- dalp(x, sigma, p)
  
  if (any(prob > 0)) {
    sample_alp <- sample(
      x = x,
      size = n,
      prob = prob
    )
  } else {
    sample_alp <- rep(0, n)
  }
  
  return(sample_alp)
}
