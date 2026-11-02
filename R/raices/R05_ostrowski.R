
# R05 - Ostrowski [12]. Sus dos refinamientos pertenecen a UN ciclo externo.
ostrowski <- function(f, df, x0, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol,max_iter); validar_numero(x0,"x0"); x <- x0; H <- tabla_raices()
  if (abs(evaluar(f,x)) <= tol) return(resultado(x,0L,H,unidad="Actualizacion de raiz"))
  for (k in seq_len(max_iter)) {
    fx <- evaluar(f,x); d <- evaluar(df,x)
    if (d == 0) stop("La derivada es cero")
    y <- x-fx/d; fy <- evaluar(f,y)
    if (abs(fy) <= tol) x <- y else {
      den <- fx-2*fy
      if (den == 0) stop("La correccion de Ostrowski tiene denominador cero")
      x <- y-(fy/d)*(fx/den)
    }
    fx <- evaluar(f,x); H[nrow(H)+1L, ] <- list(k,x,abs(fx))
    if (abs(fx) <= tol) return(resultado(x,k,H,unidad="Actualizacion de raiz"))
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Actualizacion de raiz")
}
