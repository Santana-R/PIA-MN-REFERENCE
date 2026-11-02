
newton <- function(f, df, x0, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol,max_iter); validar_numero(x0,"x0"); x <- x0; H <- tabla_raices()
  if (abs(evaluar(f,x)) <= tol) return(resultado(x,0L,H,unidad="Actualizacion de raiz"))
  for (k in seq_len(max_iter)) {
    fx <- evaluar(f,x); derivada <- evaluar(df,x)
    if (derivada == 0) stop("La derivada es cero; cambie la aproximacion inicial")
    x <- x-fx/derivada; fx <- evaluar(f,x)
    H[nrow(H)+1L, ] <- list(k,x,abs(fx))
    if (abs(fx) <= tol) return(resultado(x,k,H,unidad="Actualizacion de raiz"))
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Actualizacion de raiz")
}
