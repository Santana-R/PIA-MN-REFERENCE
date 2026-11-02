
# I06 - Interpolante trigonometrico con N impar [7].
# Los datos corresponden a origen + j*periodo/N, j=0,...,N-1; no se repite el extremo.
trigonometrica <- function(y, consulta, periodo = 2*pi, origen = 0) {
  n <- length(y); validar_entero(n, 3L)
  if (n %% 2L == 0 || any(!is.finite(y))) stop("Use un numero impar de datos finitos")
  validar_numero(periodo, "periodo", TRUE); validar_numero(origen, "origen")
  validar_numero(consulta, "consulta")
  theta <- 2*pi*(consulta-origen)/periodo
  nodos <- 2*pi*(0L:(n-1L))/n
  valor <- mean(y); a <- numeric((n-1L)/2L); b <- a
  for (k in seq_along(a)) {
    a[k] <- 2 * sum(y * cos(k*nodos)) / n
    b[k] <- 2 * sum(y * sin(k*nodos)) / n
    valor <- valor + a[k]*cos(k*theta) + b[k]*sin(k*theta)
  }
  resultado(valor, detalles = list(a = a, b = b, nodos = n))
}
