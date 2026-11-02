
# Horner simultaneo para P, P' y P''. Coeficientes del mayor grado al independiente.
polinomio_derivadas <- function(coef, x) {
  p <- coef[1L]; dp <- 0; ddp <- 0
  if (length(coef)>1L) for (i in 2L:length(coef)) {
    ddp <- ddp*x+2*dp; dp <- dp*x+p; p <- p*x+coef[i]
  }
  c(p,dp,ddp)
}
