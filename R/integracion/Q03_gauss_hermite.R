
# Q03 - Gauss-Hermite, convencion de fisicos [20,22].
# Integral sobre toda la recta de exp(-x^2)*g(x).
gauss_hermite <- function(g,n=4L) {
  validar_entero(n)
  if (n>20L) stop("Esta implementacion academica admite de 1 a 20 nodos de Hermite")
  x <- nodos_hermite(n);w <- numeric(n);v <- numeric(n)
  factorial_n <- 1
  for (k in seq_len(n)) factorial_n <- factorial_n*k
  for (i in seq_len(n)) {
    w[i] <- 2^(n-1)*factorial_n*sqrt(pi)/(n*n*hermite_polinomio(n-1L,x[i])^2)
    v[i] <- evaluar(g,x[i])
  }
  resultado(sum(w*v),detalles=list(nodos=x,pesos=w,peso="exp(-x^2)"))
}
