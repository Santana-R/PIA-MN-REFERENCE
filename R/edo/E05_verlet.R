
# E05 - Velocity Verlet [27]. Aceleracion a(t,y), sin dependencia de velocidad.
verlet <- function(aceleracion,a,b,y0,v0,n=20L) {
  validar_malla(a,b,n);validar_numero(y0,"y0");validar_numero(v0,"v0")
  h <- (b-a)/n;t <- a+(0L:n)*h;y <- numeric(n+1L);v <- y;y[1L] <- y0;v[1L] <- v0
  for (i in seq_len(n)) {
    acc <- aceleracion(t[i],y[i])
    y[i+1L] <- y[i]+h*v[i]+h*h*acc/2
    v[i+1L] <- v[i]+h*(acc+aceleracion(t[i+1L],y[i+1L]))/2
  }
  if (any(!is.finite(c(y,v)))) stop("La EDO dejo de producir valores finitos")
  resultado(y[n+1L],historial=data.frame(t=t,y=y,v=v),detalles=list(pasos=n))
}
