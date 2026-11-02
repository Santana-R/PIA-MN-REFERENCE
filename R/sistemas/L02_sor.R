
# L02 - SOR [14]. Una iteracion es un barrido completo de las n filas.
sor <- function(A,b,x0=rep(0,length(b)),omega=1,tol=1e-8,max_iter=10000L) {
  validar_sistema(A,b);control_iterativo(tol,max_iter);validar_numero(omega,"omega",TRUE)
  if (omega>=2) stop("Use omega entre 0 y 2; confirme ademas las condiciones de convergencia")
  n <- nrow(A)
  if (any(diag(A)==0) || length(x0)!=n || any(!is.finite(x0))) stop("Revise la diagonal y el vector inicial")
  x <- as.numeric(x0);H <- data.frame(k=integer(),residuo=numeric())
  if (norma_residuo(A,b,x)<=tol) return(resultado(x,0L,H,unidad="Barrido completo"))
  for (k in seq_len(max_iter)) {
    anterior <- x
    for (i in seq_len(n)) {
      suma <- 0
      if (i>1L) for (j in seq_len(i-1L)) suma <- suma+A[i,j]*x[j]
      if (i<n) for (j in (i+1L):n) suma <- suma+A[i,j]*anterior[j]
      x[i] <- (1-omega)*anterior[i]+omega*(b[i]-suma)/A[i,i]
    }
    if (any(!is.finite(x))) stop("El proceso dejo de producir valores finitos")
    r <- norma_residuo(A,b,x);H[nrow(H)+1L,] <- c(k,r)
    if (r<=tol) return(resultado(x,k,H,unidad="Barrido completo",detalles=list(omega=omega)))
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Barrido completo",list(omega=omega))
}
