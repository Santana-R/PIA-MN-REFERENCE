
# I03 - PCHIP [3,4]. Se implementan las pendientes; no se llama a una biblioteca.
pchip <- function(x, y, consulta) {
  validar_nodos(x, y); validar_numero(consulta, "consulta")
  n <- length(x)
  if (consulta < x[1L] || consulta > x[n]) stop("La consulta debe estar dentro de los datos")
  h <- diff(x); d <- diff(y) / h; m <- numeric(n)
  extremo <- function(h1, h2, d1, d2) {
    z <- ((2 * h1 + h2) * d1 - h1 * d2) / (h1 + h2)
    if (sign(z) != sign(d1)) z <- 0
    else if (sign(d1) != sign(d2) && abs(z) > abs(3 * d1)) z <- 3 * d1
    z
  }
  if (n == 2L) m[] <- d[1L] else {
    m[1L] <- extremo(h[1L], h[2L], d[1L], d[2L])
    m[n] <- extremo(h[n - 1L], h[n - 2L], d[n - 1L], d[n - 2L])
    for (i in 2L:(n - 1L)) {
      if (d[i - 1L] == 0 || d[i] == 0 || sign(d[i - 1L]) != sign(d[i])) m[i] <- 0
      else {
        w1 <- 2 * h[i] + h[i - 1L]; w2 <- h[i] + 2 * h[i - 1L]
        m[i] <- (w1 + w2) / (w1 / d[i - 1L] + w2 / d[i])
      }
    }
  }
  i <- min(n - 1L, max(which(x <= consulta)))
  t <- (consulta - x[i]) / h[i]
  valor <- (2 * t^3 - 3 * t^2 + 1) * y[i] + (t^3 - 2 * t^2 + t) * h[i] * m[i] +
    (-2 * t^3 + 3 * t^2) * y[i + 1L] + (t^3 - t^2) * h[i] * m[i + 1L]
  resultado(valor, detalles = list(pendientes = m, intervalo = i))
}
