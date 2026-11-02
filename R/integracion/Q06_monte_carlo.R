
# Q06 - Monte Carlo simple [24]. Usa el generador incluido en R, sin instalar paquetes.
# Restaura el estado aleatorio para que la funcion no altere los ejemplos siguientes.
monte_carlo <- function(f,a,b,n=10000L,semilla=2026L) {
  validar_numero(a,"a");validar_numero(b,"b");validar_entero(n,2L);validar_entero(semilla,0L,"semilla")
  if (a>=b) stop("Use a < b")
  habia_semilla <- exists(".Random.seed",envir=.GlobalEnv,inherits=FALSE)
  if (habia_semilla) semilla_previa <- get(".Random.seed",envir=.GlobalEnv)
  on.exit({
    if (habia_semilla) assign(".Random.seed",semilla_previa,envir=.GlobalEnv)
    else if (exists(".Random.seed",envir=.GlobalEnv,inherits=FALSE)) rm(".Random.seed",envir=.GlobalEnv)
  })
  set.seed(semilla);suma <- 0;media <- 0;M2 <- 0
  for (k in seq_len(n)) {
    valor <- evaluar(f,a+(b-a)*runif(1L))
    delta <- valor-media;media <- media+delta/k;M2 <- M2+delta*(valor-media)
    suma <- suma+valor
  }
  se <- (b-a)*sqrt((M2/(n-1L))/n)
  resultado((b-a)*suma/n,detalles=list(muestras=n,semilla=semilla,error_estandar=se))
}
