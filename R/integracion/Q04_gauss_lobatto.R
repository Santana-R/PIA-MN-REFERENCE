
# Q04 - Gauss-Lobatto-Legendre [20]. n NODOS TOTALES, incluidos los extremos.
gauss_lobatto <- function(f,a,b,n=4L) {
  validar_numero(a,"a");validar_numero(b,"b");validar_entero(n,2L)
  if (a>=b || n>20L) stop("Use a < b y entre 2 y 20 nodos para esta implementacion")
  grado <- n-1L;x <- c(-1,rep(0,n-2L),1)
  if (n>2L) {
    ceros <- nodos_legendre(grado)
    derivada <- function(t) grado*(t*legendre_polinomio(grado,t)-legendre_polinomio(grado-1L,t))/(t*t-1)
    for (i in seq_len(n-2L)) x[i+1L] <- biseccion_aux(derivada,ceros[i],ceros[i+1L])
  }
  w <- numeric(n);valores <- numeric(n);xp <- (a+b)/2+(b-a)*x/2
  for (i in seq_len(n)) {
    w[i] <- 2/(n*(n-1)*legendre_polinomio(n-1L,x[i])^2)
    valores[i] <- evaluar(f,xp[i])
  }
  resultado((b-a)*sum(w*valores)/2,detalles=list(nodos=xp,pesos=(b-a)*w/2))
}
