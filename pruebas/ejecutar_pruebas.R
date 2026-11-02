# Pruebas contra soluciones analiticas y propiedades matematicas, sin testthat.
archivo <- sub("^--file=","",grep("^--file=",commandArgs(FALSE),value=TRUE)[1L])
raiz <- dirname(dirname(normalizePath(archivo,winslash="/")))
source(file.path(raiz,"iniciar.R"),encoding="UTF-8")
aprobadas <- 0L;fallidas <- character()
probar <- function(nombre,accion) {
  tryCatch({force(accion);aprobadas <<- aprobadas+1L},
    error=function(e)fallidas <<- c(fallidas,paste(nombre,conditionMessage(e),sep=": ")))
}
cerca <- function(valor,esperado,tol=1e-8) {
  stopifnot(length(valor)==length(esperado),all(is.finite(valor)),max(abs(valor-esperado))<=tol)
}
debe_fallar <- function(accion) {
  fallo <- tryCatch({force(accion);FALSE},error=function(e)TRUE)
  stopifnot(fallo)
}

probar("Neville reproduce un polinomio",{cerca(neville(0:3,(0:3)^3-2*(0:3),1.5)$valor,0.375)})
probar("Neville rechaza nodos repetidos",{debe_fallar(neville(c(0,0),c(1,2),0))})
probar("Spline natural conocido",{cerca(spline_natural(0:2,c(0,1,0),0.5)$valor,0.6875)})
probar("Spline con dos datos",{cerca(spline_natural(c(0,2),c(1,5),1)$valor,3)})
probar("Spline extremos naturales",{cerca(spline_natural(0:3,c(0,2,-1,4),0)$detalles$segundas_derivadas[c(1,4)],c(0,0))})
probar("PCHIP mantiene monotonia",{
  x <- c(0,1,2,4);y <- c(0,1,1.2,1.3)
  valores <- vapply(seq(0,4,length.out=201),function(t)pchip(x,y,t)$valor,numeric(1))
  stopifnot(all(diff(valores)>=-1e-12),min(valores)>=-1e-12,max(valores)<=1.3+1e-12)
})
probar("PCHIP dos nodos",{cerca(pchip(c(0,2),c(1,5),0.5)$valor,2)})
probar("PCHIP reproduce los datos",{
  x<-0:3;y<-c(0,1,0,0)
  for(i in 1:4)cerca(pchip(x,y,x[i])$valor,y[i])
})
probar("Bilineal reproduce plano",{cerca(bilineal(0:1,0:1,matrix(c(0,2,3,5),2,byrow=TRUE),0.25,0.5)$valor,2)})
probar("Bilineal rechaza consulta exterior",{debe_fallar(bilineal(0:1,0:1,matrix(1:4,2),2,0.5))})
probar("Shepard coincidencia exacta",{cerca(shepard(c(0,1),c(0,0),c(3,7),1,0)$valor,7)})
probar("Shepard preserva constantes",{cerca(shepard(c(0,1,0),c(0,0,1),rep(4,3),0.2,0.3)$valor,4)})
probar("Trigonometrica recupera armonicos",{
  x<-2*pi*(0:6)/7;y<-2+sin(x)+0.5*cos(2*x)
  cerca(trigonometrica(y,0.7)$valor,2+sin(0.7)+0.5*cos(1.4))
  cerca(trigonometrica(y,0.7+2*pi)$valor,trigonometrica(y,0.7)$valor)
})
probar("Trigonometrica rechaza datos pares",{debe_fallar(trigonometrica(1:4,0.2))})

f <- function(x)x^3-x-2;df <- function(x)3*x^2-1;ddf<-function(x)6*x
algoritmos <- list(Biseccion=function()biseccion(f,1,2),
  Ridders=function()ridders(f,1,2),Brent=function()brent_dekker(f,1,2),
  Muller=function()muller(f,1,1.5,2),Newton=function()newton(f,df,1.5),
  Halley=function()halley(f,df,ddf,1.5),Ostrowski=function()ostrowski(f,df,1.5),
  Laguerre=function()laguerre(c(1,0,-1,-2),1.5))
for(nombre in names(algoritmos)) probar(paste("Raiz y contador",nombre),{
  z<-algoritmos[[nombre]]()
  stopifnot(z$convergio,abs(f(z$valor))<=1e-8,z$iteraciones==nrow(z$historial))
  cerca(z$valor,1.521379706804568,1e-8)
})
probar("Ridders raiz inicial cero iteraciones",{stopifnot(ridders(function(x)x,0,1)$iteraciones==0L)})
probar("Brent raiz inicial cero iteraciones",{stopifnot(brent_dekker(function(x)x,0,1)$iteraciones==0L)})
probar("Extremo que ya cumple tolerancia",{
  for(m in list(biseccion,ridders,brent_dekker))stopifnot(m(function(x)x,1e-10,1)$iteraciones==0L)
})
probar("Biseccion no oculta falta de convergencia",{stopifnot(!biseccion(f,1,2,max_iter=1)$convergio)})
probar("Intervalo sin cambio de signo",{debe_fallar(ridders(function(x)x*x+1,-1,1))})
probar("Newton derivada cero",{debe_fallar(newton(function(x)x*x+1,function(x)2*x,0))})
probar("Muller obtiene raiz compleja",{z<-muller(function(x)x*x+1,0,1,2);stopifnot(z$convergio);cerca(z$valor^2,-1)})
probar("Laguerre obtiene raiz compleja",{z<-laguerre(c(1,0,1),1);stopifnot(z$convergio);cerca(z$valor^2,-1)})
probar("Halley ya esta en raiz",{stopifnot(halley(function(x)x,function(x)1,function(x)0,0)$iteraciones==0L)})
probar("Ostrowski termina en refinamiento intermedio",{z<-ostrowski(function(x)x-1,function(x)1,0);cerca(z$valor,1);stopifnot(z$iteraciones==1L)})

A<-matrix(c(4,1,1,3),2);b<-c(1,2);exacta<-c(1/11,7/11)
probar("LDLt resuelve y reconstruye",{z<-ldlt(A,b);cerca(z$valor,exacta);cerca(as.vector(z$detalles$L%*%diag(z$detalles$D)%*%t(z$detalles$L)),as.vector(A))})
probar("LDLt caso escalar",{cerca(ldlt(matrix(2,1),6)$valor,3)})
probar("LDLt rechaza matriz indefinida",{debe_fallar(ldlt(matrix(c(1,2,2,1),2),c(1,1)))})
probar("SOR resuelve",{z<-sor(A,b,omega=1.1);cerca(z$valor,exacta);stopifnot(z$iteraciones==nrow(z$historial))})
probar("SOR omega uno coincide con Gauss Seidel",{cerca(sor(A,b,omega=1)$valor,gauss_seidel(A,b)$valor)})
probar("SOR inicio exacto",{stopifnot(sor(A,b,x0=exacta)$iteraciones==0L)})
probar("SOR no convergio",{stopifnot(!sor(A,b,max_iter=1)$convergio)})
probar("SOR rechaza diagonal cero",{debe_fallar(sor(matrix(c(0,1,1,2),2),b))})
probar("Richardson resuelve",{cerca(richardson(A,b,omega=0.2)$valor,exacta)})
probar("Kaczmarz resuelve sistema rectangular compatible",{
  Ar<-rbind(A,c(1,1));br<-as.numeric(Ar%*%exacta)
  z<-kaczmarz(Ar,br);cerca(z$valor,exacta,1e-7);stopifnot(is.na(z$iteraciones),z$detalles$proyecciones==3L*z$detalles$barridos)
})
probar("Schur resuelve por bloques",{cerca(schur(A,b,1)$valor,exacta)})
for(n in 1:12) probar(paste("Reduccion ciclica tamano",n),{
  lo<-c(0,rep(-1,n-1));up<-c(rep(-0.5,n-1),0);d<-rep(4,n)
  verdad<-seq_len(n)/n;rhs<-d*verdad
  if(n>1){rhs[2:n]<-rhs[2:n]+lo[2:n]*verdad[1:(n-1)];rhs[1:(n-1)]<-rhs[1:(n-1)]+up[1:(n-1)]*verdad[2:n]}
  cerca(reduccion_ciclica(lo,d,up,rhs)$valor,verdad)
})
probar("Boole grado cinco",{cerca(boole(function(x)x^5,0,1,8)$valor,1/6)})
probar("Boole rechaza n incompatible",{debe_fallar(boole(sin,0,1,7))})
probar("Chebyshev integral ponderada",{cerca(gauss_chebyshev(function(x)x^2,3)$valor,pi/2)})
for(n in 1:8) probar(paste("Hermite momentos",n),{
  k<-n-1L
  momento<-sqrt(pi)
  if(k>0L)for(j in seq_len(k))momento<-momento*(2*j-1)/2
  cerca(gauss_hermite(function(x)x^(2*k),n)$valor,momento,1e-7*max(1,momento))
  cerca(gauss_hermite(function(x)1,n)$valor,sqrt(pi),1e-9)
})
for(n in 2:9) probar(paste("Lobatto exactitud",n),{
  k<-2*n-4L;cerca(gauss_lobatto(function(x)x^k,-1,1,n)$valor,2/(k+1),1e-8)
})
for(n in 3:10) probar(paste("Clenshaw Curtis exactitud",n),{
  k<-2*floor((n-1L)/2);cerca(clenshaw_curtis(function(x)x^k,-1,1,n)$valor,2/(k+1),1e-9)
})
probar("Cuadratura cambia intervalo",{cerca(gauss_lobatto(function(x)x^2,2,4,3)$valor,56/3);cerca(clenshaw_curtis(function(x)x^2,2,4,5)$valor,56/3)})
probar("Monte Carlo constante exacta",{cerca(monte_carlo(function(x)3,2,5,100,42)$valor,9)})
probar("Monte Carlo reproducible y restaura semilla",{
  set.seed(123);antes<-.Random.seed
  z1<-monte_carlo(function(x)x^2,0,1,1000,42);z2<-monte_carlo(function(x)x^2,0,1,1000,42)
  cerca(z1$valor,z2$valor,0);stopifnot(identical(antes,.Random.seed))
})
fedo<-function(t,y)y
probar("AB2 orden esperado",{e1<-abs(adams_bashforth2(fedo,0,1,1,20)$valor-exp(1));e2<-abs(adams_bashforth2(fedo,0,1,1,40)$valor-exp(1));stopifnot(e1/e2>3)})
probar("AM3 orden esperado",{e1<-abs(adams_moulton3(fedo,0,1,1,20)$valor-exp(1));e2<-abs(adams_moulton3(fedo,0,1,1,40)$valor-exp(1));stopifnot(e1/e2>6)})
probar("BDF2 orden esperado",{e1<-abs(bdf2(fedo,0,1,1,20)$valor-exp(1));e2<-abs(bdf2(fedo,0,1,1,40)$valor-exp(1));stopifnot(e1/e2>3)})
probar("Hamming orden esperado",{e1<-abs(hamming(fedo,0,1,1,10)$valor-exp(1));e2<-abs(hamming(fedo,0,1,1,20)$valor-exp(1));stopifnot(e1/e2>8)})
probar("Verlet oscilador",{z<-verlet(function(t,y)-y,0,1,1,0,200);cerca(z$valor,cos(1),1e-5);cerca(tail(z$historial$v,1),-sin(1),1e-5)})
probar("Numerov oscilador",{cerca(numerov(function(t)-1,function(t)0,0,1,0,1,40)$valor,sin(1),1e-7)})
probar("Numerov con fuente",{cerca(numerov(function(t)0,function(t)2,0,1,0,0,20)$valor,1,1e-10)})
probar("Implicitos con derivada analitica",{cerca(adams_moulton3(fedo,0,1,1,20,function(t,y)1)$valor,adams_moulton3(fedo,0,1,1,20)$valor,1e-10)})
probar("Malla invalida",{debe_fallar(hamming(fedo,0,1,1,3));debe_fallar(bdf2(fedo,0,1,1,1))})
probar("No se reportan pasos EDO como iteraciones",{stopifnot(is.na(bdf2(fedo,0,1,1,20)$iteraciones))})
probar("Catalogo contiene 30 metodos",{stopifnot(length(casos)==30L)})
probar("Todos los ejemplos producen salida finita",{
  for(id in names(casos)){z<-ejecutar_caso(id,FALSE);stopifnot(z$convergio,all(is.finite(z$valor)))}
})
probar("Comparaciones sin tiempos",{t1<-comparar_raices();t2<-comparar_sistemas();stopifnot(all(t1$convergio),all(t2$convergio),!any(grepl("tiempo|segundo|complejidad",c(names(t1),names(t2)))))})
for(opcion in list("--ayuda","--listar",c("--caso","R01"),"--todos","--comparar")) {
  probar(paste("Terminal",paste(opcion,collapse=" ")),{
    texto<-system2(file.path(R.home("bin"),"Rscript"),c("--vanilla",shQuote(file.path(raiz,"ejecutar.R")),opcion),stdout=TRUE,stderr=TRUE)
    estado<-attr(texto,"status")
    stopifnot(is.null(estado) || estado==0L,length(texto)>0L)
  })
}
cat("Pruebas aprobadas:",aprobadas,"\n")
if(length(fallidas)){cat(paste(fallidas,collapse="\n"),"\n");quit(status=1L)}
cat("Todas las pruebas finalizaron correctamente.\n")
