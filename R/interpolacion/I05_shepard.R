
# I05 - Shepard bidimensional [6]. Escalado de distancias evita pesos enormes.
shepard <- function(x, y, z, consulta_x, consulta_y, p = 2) {
  if (length(x) < 1L || length(x) != length(y) || length(x) != length(z) ||
      any(!is.finite(c(x, y, z)))) stop("Use tres vectores finitos del mismo tamano")
  validar_numero(consulta_x, "consulta_x"); validar_numero(consulta_y, "consulta_y")
  validar_numero(p, "p", TRUE)
  if (any(duplicated(cbind(x, y)))) stop("No repita posiciones de datos")
  d <- sqrt((x-consulta_x)^2 + (y-consulta_y)^2)
  if (any(d == 0)) return(resultado(z[which(d == 0)[1L]]))
  w <- (min(d) / d)^p
  resultado(sum(w*z) / sum(w), detalles = list(pesos = w / sum(w)))
}
