
# Newton interno, derivada analitica o diferencia central propia.
resolver_implicita <- function(F,z0,dF=NULL,tol=1e-12,max_iter=100L) {
  z <- z0
  if (abs(evaluar(F,z))<=tol) return(list(valor=z,iteraciones=0L))
  for (k in seq_len(max_iter)) {
    if (is.null(dF)) {
      e <- .Machine$double.eps^(1/3)*max(1,abs(z))
      d <- (evaluar(F,z+e)-evaluar(F,z-e))/(2*e)
    } else d <- evaluar(dF,z)
    if (d==0) stop("La ecuacion implicita tiene derivada cero")
    z <- z-evaluar(F,z)/d
    if (abs(evaluar(F,z))<=tol) return(list(valor=z,iteraciones=k))
  }
  stop("La ecuacion implicita no alcanzo la tolerancia interna")
}
