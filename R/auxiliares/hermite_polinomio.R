
hermite_polinomio <- function(n,x) {
  if (n==0L) return(1)
  p0 <- 1;p1 <- 2*x
  if (n>1L) for (k in 2L:n) { nuevo <- 2*x*p1-2*(k-1)*p0;p0 <- p1;p1 <- nuevo }
  p1
}
