
# R03 - Muller [10]. Usa tres puntos; admite aritmetica compleja.
muller <- function(f, x0, x1, x2, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol, max_iter)
  for (z in list(x0,x1,x2)) validar_numero(z, "un punto inicial")
  H <- tabla_raices()
  for (z in list(x2,x1,x0)) if (abs(evaluar(f,z)) <= tol) {
    return(resultado(z, 0L, H, unidad = "Actualizacion de raiz"))
  }
  if (length(unique(c(x0,x1,x2))) != 3L) stop("Muller necesita tres puntos distintos")
  for (k in seq_len(max_iter)) {
    f0 <- evaluar(f,x0); f1 <- evaluar(f,x1); f2 <- evaluar(f,x2)
    h1 <- x1-x0; h2 <- x2-x1
    if (h1 == 0 || h2 == 0 || h1+h2 == 0) stop("Los puntos de Muller producen una division entre cero")
    d1 <- (f1-f0)/h1; d2 <- (f2-f1)/h2
    a <- (d2-d1)/(h1+h2); b <- d2+h2*a
    D <- sqrt(as.complex(b*b-4*a*f2))
    e1 <- b+D; e2 <- b-D; denominador <- if (abs(e1) >= abs(e2)) e1 else e2
    if (denominador == 0) stop("La parabola de Muller no permite continuar")
    x <- x2-2*f2/denominador; fx <- evaluar(f,x)
    H[nrow(H)+1L, ] <- list(k,x,abs(fx))
    if (abs(fx) <= tol) return(resultado(x,k,H,unidad="Actualizacion de raiz"))
    x0 <- x1; x1 <- x2; x2 <- x
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Actualizacion de raiz")
}
