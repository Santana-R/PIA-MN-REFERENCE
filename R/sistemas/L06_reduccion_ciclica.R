
# L06 - Reduccion ciclica serial [18]. Elimina filas pares y recupera sus incognitas.
reduccion_ciclica <- function(inferior,diagonal,superior,b) {
  n <- length(diagonal);validar_entero(n)
  if (length(inferior)!=n || length(superior)!=n || length(b)!=n ||
      any(!is.finite(c(inferior,diagonal,superior,b)))) stop("Use cuatro vectores finitos del mismo tamano")
  if (inferior[1L]!=0 || superior[n]!=0) stop("Use inferior[1]=0 y superior[n]=0")
  niveles <- 0L
  reducir <- function(a,d,c,r,nivel) {
    niveles <<- max(niveles,nivel)
    m <- length(d)
    if (any(d==0)) stop("La reduccion ciclica encontro un pivote cero")
    if (m==1L) return(r/d)
    conservar <- seq.int(1L,m,by=2L);q <- length(conservar)
    aa <- numeric(q);dd <- numeric(q);cc <- numeric(q);rr <- numeric(q)
    for (j in seq_len(q)) {
      i <- conservar[j];dd[j] <- d[i];rr[j] <- r[i]
      if (i>1L) {
        alfa <- -a[i]/d[i-1L]
        aa[j] <- alfa*a[i-1L];dd[j] <- dd[j]+alfa*c[i-1L];rr[j] <- rr[j]+alfa*r[i-1L]
      }
      if (i<m) {
        beta <- -c[i]/d[i+1L]
        cc[j] <- beta*c[i+1L];dd[j] <- dd[j]+beta*a[i+1L];rr[j] <- rr[j]+beta*r[i+1L]
      }
    }
    x <- numeric(m);x[conservar] <- reducir(aa,dd,cc,rr,nivel+1L)
    for (i in seq.int(2L,m,by=2L)) {
      suma <- a[i]*x[i-1L]
      if (i<m) suma <- suma+c[i]*x[i+1L]
      x[i] <- (r[i]-suma)/d[i]
    }
    x
  }
  x <- reducir(inferior,diagonal,superior,b,0L)
  resultado(x,detalles=list(niveles_reduccion=niveles))
}
