# I01 - Neville [1]. Requiere utilidades.
neville <- function(x, y, consulta) {
  validar_nodos(x, y); validar_numero(consulta, "consulta")
  n <- length(x)
  Q <- matrix(0, n, n); Q[, 1L] <- y
  for (j in 2L:n) for (i in j:n) {
    Q[i, j] <- ((consulta - x[i - j + 1L]) * Q[i, j - 1L] -
               (consulta - x[i]) * Q[i - 1L, j - 1L]) / (x[i] - x[i - j + 1L])
  }
  resultado(Q[n, n], historial = Q, detalles = list(nodos = n))
}
