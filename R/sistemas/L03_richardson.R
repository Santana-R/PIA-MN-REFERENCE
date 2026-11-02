
# L03 - Richardson [15]. Una iteracion actualiza el vector completo.
richardson <- function(A,b,x0=rep(0,length(b)),omega,tol=1e-8,max_iter=10000L) {
  validar_sistema(A,b);control_iterativo(tol,max_iter);validar_numero(omega,"omega",TRUE)
  if (length(x0)!=length(b) || any(!is.finite(x0))) stop("Revise el vector inicial")
  x <- as.numeric(x0);H <- data.frame(k=integer(),residuo=numeric())
  if (norma_residuo(A,b,x)<=tol) return(resultado(x,0L,H,unidad="Actualizacion de vector"))
  for (k in seq_len(max_iter)) {
    x <- x+omega*as.numeric(b-A%*%x)
    if (any(!is.finite(x))) stop("Richardson dejo de producir valores finitos")
    r <- norma_residuo(A,b,x);H[nrow(H)+1L,] <- c(k,r)
    if (r<=tol) return(resultado(x,k,H,unidad="Actualizacion de vector",detalles=list(omega=omega)))
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Actualizacion de vector")
}
