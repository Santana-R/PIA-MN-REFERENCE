
# R04 - Halley [11]. Derivadas proporcionadas por el usuario.
halley <- function(f, df, ddf, x0, tol = 1e-8, max_iter = 1000L) {
  control_iterativo(tol,max_iter); validar_numero(x0,"x0"); x <- x0; H <- tabla_raices()
  if (abs(evaluar(f,x)) <= tol) return(resultado(x,0L,H,unidad="Actualizacion de raiz"))
  for (k in seq_len(max_iter)) {
    fx <- evaluar(f,x); d <- evaluar(df,x); dd <- evaluar(ddf,x)
    den <- 2*d*d-fx*dd
    if (den == 0) stop("El denominador de Halley es cero")
    x <- x-2*fx*d/den; fx <- evaluar(f,x)
    H[nrow(H)+1L, ] <- list(k,x,abs(fx))
    if (abs(fx) <= tol) return(resultado(x,k,H,unidad="Actualizacion de raiz"))
  }
  resultado(x,nrow(H),H,FALSE,"No se alcanzo la tolerancia","Actualizacion de raiz")
}
