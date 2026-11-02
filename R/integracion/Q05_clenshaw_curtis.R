
# Q05 - Clenshaw-Curtis [23]. Calculo directo de pesos por sumas de cosenos.
clenshaw_curtis <- function(f,a,b,n=5L) {
  validar_numero(a,"a");validar_numero(b,"b");validar_entero(n,3L)
  if (a>=b) stop("Use a < b")
  N <- n-1L;theta <- pi*(0L:N)/N;x <- cos(theta);w <- numeric(n);v <- numeric(n)
  for (j in 0L:N) {
    q <- 1;limite <- floor((N-1L)/2L)
    if (limite>0L) for (k in seq_len(limite)) q <- q-2*cos(2*k*theta[j+1L])/(4*k*k-1)
    if (N%%2L==0L) q <- q-cos(N*theta[j+1L])/(N*N-1)
    w[j+1L] <- 2*q/N
    if (j==0L || j==N) w[j+1L] <- w[j+1L]/2
    v[j+1L] <- evaluar(f,(a+b)/2+(b-a)*x[j+1L]/2)
  }
  resultado((b-a)*sum(w*v)/2,detalles=list(nodos=(a+b)/2+(b-a)*x/2,pesos=(b-a)*w/2))
}
