
# Nodos por intercalacion de ceros y biseccion propia. Limite de esta implementacion: n<=20.
nodos_hermite <- function(n) {
  anteriores <- numeric()
  for (grado in seq_len(n)) {
    cota <- sqrt(2*grado+1)
    limites <- c(-cota,anteriores,cota);actuales <- numeric(grado)
    for (i in seq_len(grado)) {
      actuales[i] <- biseccion_aux(function(x) hermite_polinomio(grado,x),limites[i],limites[i+1L])
    }
    anteriores <- actuales
  }
  anteriores
}
