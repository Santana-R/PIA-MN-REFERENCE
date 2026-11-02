
rk4 <- function(f,a,b,y0,n=20L) {
  validar_malla(a,b,n);validar_numero(y0,"y0")
  h <- (b-a)/n;t <- a+(0L:n)*h;y <- numeric(n+1L);y[1L] <- y0
  for (i in seq_len(n)) y[i+1L] <- rk4_paso(f,t[i],y[i],h)
  resultado(y[n+1L],historial=data.frame(t=t,y=y),detalles=list(pasos=n,arranque=0L))
}
