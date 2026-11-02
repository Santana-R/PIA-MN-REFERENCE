
# E04 - Hamming modificado [26]. Se inicia el historial de diferencias en cero.
hamming <- function(f,a,b,y0,n=20L) {
  validar_malla(a,b,n,4L);validar_numero(y0,"y0")
  h <- (b-a)/n;t <- a+(0L:n)*h;y <- numeric(n+1L);y[1L] <- y0
  for (i in 1L:3L) y[i+1L] <- rk4_paso(f,t[i],y[i],h)
  p_anterior <- 0;c_anterior <- 0;pred <- rep(NA_real_,n+1L);corr <- pred
  for (i in 4L:n) {
    fi <- f(t[i],y[i]);f1 <- f(t[i-1L],y[i-1L]);f2 <- f(t[i-2L],y[i-2L])
    p <- y[i-3L]+4*h*(2*fi-f1+2*f2)/3
    modificado <- p+112*(c_anterior-p_anterior)/121
    c0 <- (9*y[i]-y[i-2L]+3*h*(2*fi-f1+f(t[i+1L],modificado)))/8
    y[i+1L] <- c0+9*(p-c0)/121
    p_anterior <- p;c_anterior <- c0;pred[i+1L] <- p;corr[i+1L] <- c0
  }
  if (any(!is.finite(y))) stop("La EDO dejo de producir valores finitos")
  resultado(y[n+1L],historial=data.frame(t=t,y=y,predictor=pred,corrector=corr),
            detalles=list(pasos=n,arranque_rk4=3L))
}
