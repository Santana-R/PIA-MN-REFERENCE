
# Q02 - Gauss-Chebyshev de primera especie [20,21].
# Aproxima integral_{-1}^{1} g(t)/sqrt(1-t^2) dt, NO integral de g sin el peso.
gauss_chebyshev <- function(g,n=4L) {
  validar_entero(n);x <- numeric(n);w <- rep(pi/n,n);v <- numeric(n)
  for (k in seq_len(n)) { x[k] <- cos((2*k-1)*pi/(2*n));v[k] <- evaluar(g,x[k]) }
  resultado(sum(w*v),detalles=list(nodos=x,pesos=w,peso="1/sqrt(1-t^2)"))
}
