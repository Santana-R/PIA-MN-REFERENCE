# Solo iteraciones como desempeno. Resultados y tolerancias documentan el problema.
# Las convenciones de conteo son propuestas operativas, aun sujetas a revision docente.
comparar_raices <- function(tol=1e-8) {
  f <- function(x)x^3-x-2;df <- function(x)3*x^2-1;ddf <- function(x)6*x
  funciones <- list(
    Biseccion=function()biseccion(f,1,2,tol),
    Newton=function()newton(f,df,1.5,tol),
    Ridders=function()ridders(f,1,2,tol),
    Brent_Dekker=function()brent_dekker(f,1,2,tol),
    Muller=function()muller(f,1,1.5,2,tol),
    Halley=function()halley(f,df,ddf,1.5,tol),
    Ostrowski=function()ostrowski(f,df,1.5,tol),
    Laguerre=function()laguerre(c(1,0,-1,-2),1.5,tol))
  tabla <- data.frame()
  for (nombre in names(funciones)) {
    z <- funciones[[nombre]]()
    tabla <- rbind(tabla,data.frame(caso="x^3-x-2",metodo=nombre,
      iteraciones=z$iteraciones,convergio=z$convergio,tolerancia=tol,
      resultado=as.character(z$valor),unidad="Ciclo externo"))
  }
  tabla
}

comparar_sistemas <- function(tol=1e-8) {
  A <- matrix(c(4,1,1,3),2,byrow=TRUE);b <- c(1,2);x0 <- c(0,0)
  funciones <- list(
    Gauss_Seidel=function()gauss_seidel(A,b,x0,tol),
    SOR_omega_1_1=function()sor(A,b,x0,1.1,tol),
    Richardson_omega_0_2=function()richardson(A,b,x0,0.2,tol))
  tabla <- data.frame()
  for (nombre in names(funciones)) {
    z <- funciones[[nombre]]()
    tabla <- rbind(tabla,data.frame(caso="A=[[4,1],[1,3]] b=[1,2]",metodo=nombre,
      iteraciones=z$iteraciones,convergio=z$convergio,tolerancia=tol,
      unidad="Actualizacion completa del vector"))
  }
  tabla
}

guardar_comparaciones <- function(directorio=file.path(ruta_proyecto,"resultados")) {
  dir.create(directorio,recursive=TRUE,showWarnings=FALSE)
  raices <- comparar_raices();sistemas <- comparar_sistemas()
  write.csv(raices,file.path(directorio,"iteraciones_raices.csv"),row.names=FALSE)
  write.csv(sistemas,file.path(directorio,"iteraciones_sistemas.csv"),row.names=FALSE)
  invisible(list(raices=raices,sistemas=sistemas))
}
