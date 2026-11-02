
# L05 - Schur [17]. Resuelve con el primer bloque; no forma inversas.
schur <- function(A,b,corte) {
  validar_sistema(A,b);n <- nrow(A);validar_entero(corte,1L,"corte")
  if (corte>=n) stop("corte debe separar dos bloques no vacios")
  u <- seq_len(corte);v <- (corte+1L):n
  B <- A[u,u,drop=FALSE];C <- A[u,v,drop=FALSE]
  D <- A[v,u,drop=FALSE];E <- A[v,v,drop=FALSE]
  Y <- matrix(0,length(u),length(v))
  for (j in seq_along(v)) Y[,j] <- gauss_propio(B,C[,j])
  z <- gauss_propio(B,b[u]);S <- E-D%*%Y
  xv <- gauss_propio(S,as.numeric(b[v]-D%*%z))
  xu <- gauss_propio(B,as.numeric(b[u]-C%*%xv))
  resultado(c(xu,xv),detalles=list(complemento=S,corte=corte))
}
