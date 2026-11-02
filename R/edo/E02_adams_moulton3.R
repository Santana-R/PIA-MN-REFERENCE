
# E02 - Adams-Moulton de DOS pasos, ORDEN tres (AM3) [25].
adams_moulton3 <- function(f,a,b,y0,n=20L,dfdy=NULL,tol_interna=1e-12,max_interna=100L) {
  validar_malla(a,b,n,2L);validar_numero(y0,"y0");control_iterativo(tol_interna,max_interna)
  h <- (b-a)/n;t <- a+(0L:n)*h;y <- numeric(n+1L);y[1L] <- y0;internas <- integer(n)
  y[2L] <- rk4_paso(f,t[1L],y[1L],h)
  for (i in 2L:n) {
    fi <- f(t[i],y[i]);fanterior <- f(t[i-1L],y[i-1L])
    F <- function(z) z-y[i]-h*(5*f(t[i+1L],z)+8*fi-fanterior)/12
    dF <- if (is.null(dfdy)) NULL else function(z) 1-5*h*dfdy(t[i+1L],z)/12
    z <- resolver_implicita(F,y[i]+h*fi,dF,tol_interna,max_interna)
    y[i+1L] <- z$valor;internas[i] <- z$iteraciones
  }
  resultado(y[n+1L],historial=data.frame(t=t,y=y,internas=c(0L,internas)),
            detalles=list(pasos=n,arranque_rk4=1L,iteraciones_internas=sum(internas)))
}
