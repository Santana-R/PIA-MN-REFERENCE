# Datos editables: cada ejemplo declara sus entradas de manera explicita.
casos <- list(
  I01=list(nombre="Neville",ejecutar=function() neville(c(0,1,2),c(0,1,4),1.5)),
  I02=list(nombre="Spline cubico natural",ejecutar=function() spline_natural(c(0,1,2),c(0,1,0),0.5)),
  I03=list(nombre="PCHIP",ejecutar=function() pchip(c(0,1,2),c(0,1,1.5),0.5)),
  I04=list(nombre="Bilineal",ejecutar=function() bilineal(c(0,1),c(0,1),matrix(c(0,2,3,5),2,byrow=TRUE),0.5,0.5)),
  I05=list(nombre="Shepard",ejecutar=function() shepard(c(0,1,0,1),c(0,0,1,1),c(0,2,3,5),0.5,0.5)),
  I06=list(nombre="Trigonometrica",ejecutar=function() {
    x <- 2*pi*(0:4)/5
    trigonometrica(2+sin(x)+0.5*cos(2*x),0.7)
  }),
  R01=list(nombre="Ridders",ejecutar=function() ridders(function(x)x^3-x-2,1,2)),
  R02=list(nombre="Brent-Dekker",ejecutar=function() brent_dekker(function(x)x^3-x-2,1,2)),
  R03=list(nombre="Muller",ejecutar=function() muller(function(x)x^2+1,0,1,2)),
  R04=list(nombre="Halley",ejecutar=function() halley(function(x)x^3-x-2,function(x)3*x^2-1,function(x)6*x,1.5)),
  R05=list(nombre="Ostrowski",ejecutar=function() ostrowski(function(x)x^3-x-2,function(x)3*x^2-1,1.5)),
  R06=list(nombre="Laguerre",ejecutar=function() laguerre(c(1,0,-1,-2),1.5)),
  L01=list(nombre="LDLt",ejecutar=function() ldlt(matrix(c(4,1,1,3),2),c(1,2))),
  L02=list(nombre="SOR",ejecutar=function() sor(matrix(c(4,1,1,3),2),c(1,2),omega=1.1)),
  L03=list(nombre="Richardson",ejecutar=function() richardson(matrix(c(4,1,1,3),2),c(1,2),omega=0.2)),
  L04=list(nombre="Kaczmarz ciclico",ejecutar=function() kaczmarz(matrix(c(4,1,1,3),2),c(1,2))),
  L05=list(nombre="Complemento de Schur",ejecutar=function() schur(matrix(c(4,1,1,3),2),c(1,2),1)),
  L06=list(nombre="Reduccion ciclica",ejecutar=function() reduccion_ciclica(c(0,-1,-1),c(2,2,2),c(-1,-1,0),c(1,0,1))),
  Q01=list(nombre="Boole",ejecutar=function() boole(function(x)x^4,0,1,4)),
  Q02=list(nombre="Gauss-Chebyshev primera especie",ejecutar=function() gauss_chebyshev(function(x)x^2,3)),
  Q03=list(nombre="Gauss-Hermite",ejecutar=function() gauss_hermite(function(x)x^2,3)),
  Q04=list(nombre="Gauss-Lobatto",ejecutar=function() gauss_lobatto(function(x)x^4,-1,1,4)),
  Q05=list(nombre="Clenshaw-Curtis",ejecutar=function() clenshaw_curtis(function(x)x^4,-1,1,5)),
  Q06=list(nombre="Monte Carlo simple",ejecutar=function() monte_carlo(function(x)x^2,0,1,10000,2026)),
  E01=list(nombre="Adams-Bashforth dos pasos",ejecutar=function() adams_bashforth2(function(t,y)y,0,1,1,20)),
  E02=list(nombre="Adams-Moulton dos pasos orden tres",ejecutar=function() adams_moulton3(function(t,y)y,0,1,1,20,dfdy=function(t,y)1)),
  E03=list(nombre="BDF2",ejecutar=function() bdf2(function(t,y)y,0,1,1,20,dfdy=function(t,y)1)),
  E04=list(nombre="Hamming modificado",ejecutar=function() hamming(function(t,y)y,0,1,1,20)),
  E05=list(nombre="Velocity Verlet",ejecutar=function() verlet(function(t,y)-y,0,1,1,0,20)),
  E06=list(nombre="Numerov",ejecutar=function() numerov(function(t)-1,function(t)0,0,1,0,1,20))
)

ejecutar_caso <- function(id,mostrar=TRUE) {
  if (!id %in% names(casos)) stop("Identificador desconocido; utilice listar_casos()")
  salida <- casos[[id]]$ejecutar()
  if (mostrar) {
    cat("\n",id," - ",casos[[id]]$nombre,"\n",sep="")
    cat("Resultado: ");print(salida$valor)
    if (is.na(salida$iteraciones)) cat("Iteraciones: criterio pendiente de confirmar con Said\n")
    else cat("Iteraciones:",salida$iteraciones,"| Unidad:",salida$unidad,"\n")
    cat("Estado:",salida$mensaje,"\n")
  }
  invisible(salida)
}

listar_casos <- function() {
  data.frame(id=names(casos),metodo=vapply(casos,function(x)x$nombre,character(1L)),row.names=NULL)
}
