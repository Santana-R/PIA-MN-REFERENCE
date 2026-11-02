
# I02 - Spline cubico NATURAL [2]. Los extremos tienen segunda derivada cero.
spline_natural <- function(x, y, consulta) {
  validar_nodos(x, y); validar_numero(consulta, "consulta")
  n <- length(x)
  if (consulta < x[1L] || consulta > x[n]) stop("La consulta debe estar dentro de los datos")
  h <- diff(x); M <- numeric(n)
  if (n > 2L) {
    A <- matrix(0, n - 2L, n - 2L); b <- numeric(n - 2L)
    for (r in seq_len(n - 2L)) {
      i <- r + 1L
      A[r, r] <- 2 * (h[i - 1L] + h[i])
      if (r > 1L) A[r, r - 1L] <- h[i - 1L]
      if (r < n - 2L) A[r, r + 1L] <- h[i]
      b[r] <- 6 * ((y[i + 1L] - y[i]) / h[i] - (y[i] - y[i - 1L]) / h[i - 1L])
    }
    M[2L:(n - 1L)] <- gauss_propio(A, b)
  }
  i <- min(n - 1L, max(which(x <= consulta)))
  a <- (x[i + 1L] - consulta) / h[i]; b <- (consulta - x[i]) / h[i]
  valor <- a * y[i] + b * y[i + 1L] +
    ((a^3 - a) * M[i] + (b^3 - b) * M[i + 1L]) * h[i]^2 / 6
  resultado(valor, detalles = list(segundas_derivadas = M, intervalo = i))
}
