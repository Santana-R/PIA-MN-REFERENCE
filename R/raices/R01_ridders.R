
# R01 - Ridders [8]. La correccion usa un escalado para evitar productos enormes.
ridders <- function(f, a, b, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol, max_iter); valores <- validar_intervalo(f, a, b, tol)
  fa <- valores[1L]; fb <- valores[2L]; H <- tabla_raices()
  if (abs(fa) <= tol) return(resultado(a, 0L, H, unidad = "Actualizacion de raiz"))
  if (abs(fb) <= tol) return(resultado(b, 0L, H, unidad = "Actualizacion de raiz"))
  for (k in seq_len(max_iter)) {
    m <- a + (b-a)/2; fm <- evaluar(f, m)
    if (abs(fm) <= tol) {
      H[nrow(H)+1L, ] <- list(k, m, abs(fm))
      return(resultado(m, k, H, unidad = "Actualizacion de raiz"))
    }
    escala <- max(abs(c(fa, fb, fm)))
    q <- (fm/escala)^2 - (fa/escala)*(fb/escala)
    x <- m
    if (q > 0) x <- m + (m-a) * (if (fa >= fb) 1 else -1) * (fm/escala)/sqrt(q)
    if (!is.finite(x) || x <= a || x >= b) x <- m
    fx <- evaluar(f, x); H[nrow(H)+1L, ] <- list(k, x, abs(fx))
    if (abs(fx) <= tol) return(resultado(x, k, H, unidad = "Actualizacion de raiz"))
    if (sign(fm) != sign(fx)) {
      limites <- sort(c(m, x)); a <- limites[1L]; b <- limites[2L]
      fa <- evaluar(f, a); fb <- evaluar(f, b)
    } else if (sign(fa) != sign(fx)) { b <- x; fb <- fx }
    else { a <- x; fa <- fx }
  }
  resultado(x, nrow(H), H, FALSE, "No se alcanzo la tolerancia", "Actualizacion de raiz")
}
