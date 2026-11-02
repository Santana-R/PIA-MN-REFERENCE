# Referencias numeradas en docs/REFERENCIAS.md.
# Criterio comun: abs(f(x)) <= tol. Un ciclo externo completado es una iteracion.
# La raiz que ya cumple al inicio necesita cero iteraciones.

biseccion <- function(f, a, b, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol, max_iter); valores <- validar_intervalo(f, a, b, tol)
  fa <- valores[1L]; fb <- valores[2L]; H <- tabla_raices()
  if (abs(fa) <= tol) return(resultado(a, 0L, H, unidad = "Actualizacion de raiz"))
  if (abs(fb) <= tol) return(resultado(b, 0L, H, unidad = "Actualizacion de raiz"))
  for (k in seq_len(max_iter)) {
    x <- a + (b-a)/2; fx <- evaluar(f, x)
    H[nrow(H)+1L, ] <- list(k, x, abs(fx))
    if (abs(fx) <= tol) return(resultado(x, k, H, unidad = "Actualizacion de raiz"))
    if (x == a || x == b) break
    if (sign(fa) != sign(fx)) { b <- x; fb <- fx } else { a <- x; fa <- fx }
  }
  resultado(x, nrow(H), H, FALSE, "No se alcanzo la tolerancia", "Actualizacion de raiz")
}
