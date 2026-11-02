# EDO de paso constante. El conteo comparativo queda pendiente de criterio docente.
# Se guardan pasos de malla y, si aplica, iteraciones internas como trazabilidad.
validar_malla <- function(a,b,n,minimo=1L) {
  validar_numero(a,"a");validar_numero(b,"b");validar_entero(n,minimo)
  if (a>=b) stop("Use a < b")
}
