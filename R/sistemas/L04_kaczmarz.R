
# L04 - Kaczmarz ciclico [16]. Se conservan barridos Y proyecciones por separado.
# Su equivalencia comparativa con un barrido de otros metodos sigue pendiente.
kaczmarz <- function(A,b,x0=rep(0,ncol(A)),tol=1e-8,max_iter=10000L) {
  control_iterativo(tol,max_iter)
  if (!is.matrix(A) || !is.numeric(A) || nrow(A)<1 || ncol(A)<1 ||
      length(b)!=nrow(A) || length(x0)!=ncol(A) || any(!is.finite(c(A,b,x0)))) stop("Revise A, b y x0")
  normas <- rowSums(A*A)
  if (any(normas==0)) stop("Kaczmarz necesita filas no nulas")
  x <- as.numeric(x0);H <- data.frame(barrido=integer(),proyecciones=integer(),residuo=numeric())
  if (norma_residuo(A,b,x)<=tol) return(resultado(x,historial=H,detalles=list(barridos=0L,proyecciones=0L)))
  for (k in seq_len(max_iter)) {
    for (i in seq_len(nrow(A))) x <- x+(b[i]-sum(A[i,]*x))/normas[i]*A[i,]
    r <- norma_residuo(A,b,x);H[nrow(H)+1L,] <- c(k,k*nrow(A),r)
    if (r<=tol) return(resultado(x,historial=H,detalles=list(barridos=k,proyecciones=k*nrow(A))))
  }
  resultado(x,historial=H,convergio=FALSE,mensaje="No se alcanzo la tolerancia",
            detalles=list(barridos=nrow(H),proyecciones=nrow(H)*nrow(A)))
}
