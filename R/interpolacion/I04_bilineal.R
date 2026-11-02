
# I04 - Bilineal [5]. Filas de Z: y1,y2; columnas: x1,x2.
bilineal <- function(x, y, Z, consulta_x, consulta_y) {
  if (length(x) != 2L || length(y) != 2L || any(!is.finite(c(x, y))) ||
      x[2L] <= x[1L] || y[2L] <= y[1L] || !is.matrix(Z) ||
      !all(dim(Z) == c(2L, 2L)) || any(!is.finite(Z))) stop("Revise el rectangulo y la matriz Z de 2 por 2")
  validar_numero(consulta_x, "consulta_x"); validar_numero(consulta_y, "consulta_y")
  u <- (consulta_x - x[1L]) / diff(x); v <- (consulta_y - y[1L]) / diff(y)
  if (u < 0 || u > 1 || v < 0 || v > 1) stop("La consulta debe estar dentro del rectangulo")
  valor <- (1-u)*(1-v)*Z[1L,1L] + u*(1-v)*Z[1L,2L] +
    (1-u)*v*Z[2L,1L] + u*v*Z[2L,2L]
  resultado(valor, detalles = list(u = u, v = v))
}
