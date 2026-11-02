
# E01 - Adams-Bashforth de dos pasos [25].
adams_bashforth2 <- function(f,a,b,y0,n=20L) {
  validar_malla(a,b,n,2L);validar_numero(y0,"y0")
  h <- (b-a)/n;t <- a+(0L:n)*h;y <- numeric(n+1L);y[1L] <- y0
  y[2L] <- rk4_paso(f,t[1L],y[1L],h)
  for (i in 2L:n) y[i+1L] <- y[i]+h*(3*evaluar(function(z)f(t[i],z),y[i])-
      evaluar(function(z)f(t[i-1L],z),y[i-1L]))/2
  if (any(!is.finite(y))) stop("La EDO dejo de producir valores finitos")
  resultado(y[n+1L],historial=data.frame(t=t,y=y),detalles=list(pasos=n,arranque_rk4=1L))
}
