
# R02 - Brent-Dekker [9]. Secante / interpolacion inversa con resguardo de biseccion.
brent_dekker <- function(f, a, b, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol, max_iter); valores <- validar_intervalo(f, a, b, tol)
  fa <- valores[1L]; fb <- valores[2L]; H <- tabla_raices()
  if (abs(fa) <= tol) return(resultado(a, 0L, H, unidad = "Actualizacion de raiz"))
  if (abs(fb) <= tol) return(resultado(b, 0L, H, unidad = "Actualizacion de raiz"))
  if (abs(fa) < abs(fb)) { aux <- a; a <- b; b <- aux; aux <- fa; fa <- fb; fb <- aux }
  c0 <- a; fc <- fa; d <- c0; biseccion_previa <- TRUE
  for (k in seq_len(max_iter)) {
    if (fa != fc && fb != fc) {
      s <- a*fb*fc/((fa-fb)*(fa-fc)) +
        b*fa*fc/((fb-fa)*(fb-fc)) + c0*fa*fb/((fc-fa)*(fc-fb))
    } else s <- b - fb*(b-a)/(fb-fa)
    limite <- (3*a+b)/4
    eps_x <- 4*.Machine$double.eps*max(1, abs(b))
    rechazo <- !is.finite(s) || s <= min(limite,b) || s >= max(limite,b)
    rechazo <- rechazo || (biseccion_previa && abs(s-b) >= abs(b-c0)/2) ||
      (!biseccion_previa && abs(s-b) >= abs(c0-d)/2) ||
      (biseccion_previa && abs(b-c0) < eps_x) ||
      (!biseccion_previa && abs(c0-d) < eps_x)
    if (rechazo) { s <- a+(b-a)/2; biseccion_previa <- TRUE }
    else biseccion_previa <- FALSE
    fs <- evaluar(f, s); H[nrow(H)+1L, ] <- list(k, s, abs(fs))
    if (abs(fs) <= tol) return(resultado(s, k, H, unidad = "Actualizacion de raiz"))
    d <- c0; c0 <- b; fc <- fb
    if (sign(fa) != sign(fs)) { b <- s; fb <- fs } else { a <- s; fa <- fs }
    if (abs(fa) < abs(fb)) { aux <- a; a <- b; b <- aux; aux <- fa; fa <- fb; fb <- aux }
  }
  resultado(b, nrow(H), H, FALSE, "No se alcanzo la tolerancia", "Actualizacion de raiz")
}
