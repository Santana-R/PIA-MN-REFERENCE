
nodos_legendre <- function(n) {
  anteriores <- numeric()
  for (grado in seq_len(n)) {
    limites <- c(-1,anteriores,1);actuales <- numeric(grado)
    for (i in seq_len(grado)) {
      actuales[i] <- biseccion_aux(function(x) legendre_polinomio(grado,x),limites[i],limites[i+1L])
    }
    anteriores <- actuales
  }
  anteriores
}
