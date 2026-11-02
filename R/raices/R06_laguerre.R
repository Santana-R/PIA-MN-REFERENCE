
# R06 - Laguerre [10]. Calcula UNA raiz, sin deflacion.
laguerre <- function(coef, x0 = 0+0i, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol,max_iter); validar_numero(x0,"x0")
  if (length(coef)<2L || any(!is.finite(coef)) || coef[1L]==0) stop("Revise los coeficientes del polinomio")
  n <- length(coef)-1L; x <- as.complex(x0); H <- tabla_raices()
  if (abs(polinomio_derivadas(coef,x)[1L])<=tol) return(resultado(x,0L,H,unidad="Actualizacion de raiz"))
  for (k in seq_len(max_iter)) {
    v <- polinomio_derivadas(coef,x); G <- v[2L]/v[1L]; H0 <- G*G-v[3L]/v[1L]
    D <- sqrt(as.complex((n-1)*(n*H0-G*G)))
    e1 <- G+D; e2 <- G-D; den <- if (abs(e1)>=abs(e2)) e1 else e2
    if (den==0) stop("Laguerre tiene denominador cero; cambie x0")
    x <- x-n/den; residuo <- abs(polinomio_derivadas(coef,x)[1L])
    H[nrow(H)+1L, ] <- list(k,x,residuo)
    if (residuo<=tol) return(resultado(x,k,H,unidad="Actualizacion de raiz"))
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Actualizacion de raiz")
}
