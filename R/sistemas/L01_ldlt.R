# L01 - LDLt sin pivoteo [13]. Variante limitada a matrices simetricas definidas positivas.
ldlt <- function(A, b) {
  validar_sistema(A,b); n <- nrow(A)
  if (max(abs(A-t(A))) > 1e-12*max(1,max(abs(A)))) stop("LDLt necesita una matriz simetrica")
  L <- diag(n); D <- numeric(n)
  for (j in seq_len(n)) {
    suma <- 0
    if (j>1L) for (k in seq_len(j-1L)) suma <- suma+L[j,k]^2*D[k]
    D[j] <- A[j,j]-suma
    if (D[j]<=0) stop("Esta variante de LDLt requiere pivotes positivos")
    if (j<n) for (i in (j+1L):n) {
      suma <- 0
      if (j>1L) for (k in seq_len(j-1L)) suma <- suma+L[i,k]*L[j,k]*D[k]
      L[i,j] <- (A[i,j]-suma)/D[j]
    }
  }
  z <- numeric(n)
  for (i in seq_len(n)) {
    suma <- 0
    if (i>1L) for (j in seq_len(i-1L)) suma <- suma+L[i,j]*z[j]
    z[i] <- b[i]-suma
  }
  w <- z/D; x <- numeric(n)
  for (i in n:1L) {
    suma <- 0
    if (i<n) for (j in (i+1L):n) suma <- suma+L[j,i]*x[j]
    x[i] <- w[i]-suma
  }
  resultado(x,detalles=list(L=L,D=D,residuo=norma_residuo(A,b,x)))
}
