archivo <- sub("^--file=","",grep("^--file=",commandArgs(FALSE),value=TRUE)[1L])
source(file.path(dirname(normalizePath(archivo,winslash="/")),"iniciar.R"),encoding="UTF-8")
argumentos <- commandArgs(TRUE)
if (length(argumentos)==0L || "--ayuda" %in% argumentos) {
  cat("Uso desde la carpeta del proyecto:\n",
      "Rscript ejecutar.R --listar\n",
      "Rscript ejecutar.R --caso R01\n",
      "Rscript ejecutar.R --todos\n",
      "Rscript ejecutar.R --comparar\n",
      "Rscript pruebas/ejecutar_pruebas.R\n",sep="")
} else if ("--listar" %in% argumentos) {
  print(listar_casos(),row.names=FALSE)
} else if ("--caso" %in% argumentos) {
  posicion <- match("--caso",argumentos)
  if (posicion==length(argumentos)) stop("Escriba el ID despues de --caso")
  ejecutar_caso(toupper(argumentos[posicion+1L]))
} else if ("--todos" %in% argumentos) {
  for (id in names(casos)) ejecutar_caso(id)
} else if ("--comparar" %in% argumentos) {
  tablas <- guardar_comparaciones()
  print(tablas$raices,row.names=FALSE);print(tablas$sistemas,row.names=FALSE)
  cat("Tablas guardadas en resultados/. Conteo sujeto a revision docente.\n")
} else stop("Opcion desconocida; utilice --ayuda")
