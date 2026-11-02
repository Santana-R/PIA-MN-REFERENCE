
# E06 - Numerov [28] para y'' = g(t)*y+s(t). El primer paso se obtiene con RK4.
numerov <- function(g,s,a,b,y0,v0,n=20L) {
  validar_malla(a,b,n,2L);validar_numero(y0,"y0");validar_numero(v0,"v0")
  h <- (b-a)/n;t <- a+(0L:n)*h;y <- numeric(n+1L);y[1L] <- y0
  sistema <- function(t,z) c(z[2L],g(t)*z[1L]+s(t))
  y[2L] <- rk4_paso(sistema,t[1L],c(y0,v0),h)[1L]
  for (i in 2L:n) {
    den <- 1-h*h*g(t[i+1L])/12
    if (!is.finite(den) || den==0) stop("Numerov encontro un denominador invalido")
    y[i+1L] <- (2*(1+5*h*h*g(t[i])/12)*y[i] -
      (1-h*h*g(t[i-1L])/12)*y[i-1L] +
      h*h*(s(t[i+1L])+10*s(t[i])+s(t[i-1L]))/12)/den
  }
  if (any(!is.finite(y))) stop("La EDO dejo de producir valores finitos")
  resultado(y[n+1L],historial=data.frame(t=t,y=y),detalles=list(pasos=n,arranque_rk4=1L))
}
