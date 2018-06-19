raldm <- function(sigmas, p) {
  #
  # Generates random samples from ALD(alpha) multiple
  #
  unique_sigmas <- unique(sigmas)
  error <- vector(length = length(sigmas))
  
  for (sigma in unique_sigmas) {
    dim <- sum(sigmas == sigma)
    simulations <- ralp(dim, sigma = sigma, p)
    error[sigmas == sigma] <- simulations
  }
  
  return(error)
}
