
rk4_paso <- function(f,t,y,h) {
  k1 <- f(t,y);k2 <- f(t+h/2,y+h*k1/2);k3 <- f(t+h/2,y+h*k2/2);k4 <- f(t+h,y+h*k3)
  nuevo <- y+h*(k1+2*k2+2*k3+k4)/6
  if (any(!is.finite(nuevo))) stop("La EDO dejo de producir valores finitos")
  nuevo
}
