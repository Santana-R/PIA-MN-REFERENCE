# Q01 - Boole compuesta [19]. n es el numero de SUBINTERVALOS.
boole <- function(f,a,b,n=4L) {
  validar_numero(a,"a");validar_numero(b,"b");validar_entero(n,4L)
  if (a>=b || n%%4L!=0L) stop("Use a < b y un numero de subintervalos multiplo de cuatro")
  h <- (b-a)/n;total <- 0
  for (j in seq.int(0L,n-4L,by=4L)) {
    valores <- numeric(5L)
    for (i in 0L:4L) valores[i+1L] <- evaluar(f,a+(j+i)*h)
    total <- total+(2*h/45)*sum(c(7,32,12,32,7)*valores)
  }
  resultado(total,detalles=list(subintervalos=n,paneles=n/4L))
}
