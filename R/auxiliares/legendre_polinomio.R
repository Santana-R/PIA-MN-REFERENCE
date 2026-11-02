
legendre_polinomio <- function(n,x) {
  if (n==0L) return(1)
  p0 <- 1;p1 <- x
  if (n>1L) for (k in 2L:n) { nuevo <- ((2*k-1)*x*p1-(k-1)*p0)/k;p0 <- p1;p1 <- nuevo }
  p1
}
