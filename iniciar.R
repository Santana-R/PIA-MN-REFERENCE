# Carga las funciones sin ejecutar ejemplos ni modificar el directorio de trabajo.
archivo_inicio <- tryCatch(sys.frame(1)$ofile,error=function(e)NULL)
if (is.null(archivo_inicio)) {
  argumentos_archivo <- grep("^--file=",commandArgs(FALSE),value=TRUE)
  if (length(argumentos_archivo)) archivo_inicio <- sub("^--file=","",argumentos_archivo[1L])
}
ruta_proyecto <- if (is.null(archivo_inicio)) normalizePath(getwd(),winslash="/") else
  dirname(normalizePath(archivo_inicio,winslash="/"))
for (archivo in sort(list.files(file.path(ruta_proyecto,"R"),pattern="[.]R$",full.names=TRUE,recursive=TRUE))) {
  source(archivo,local=.GlobalEnv,encoding="UTF-8")
}
source(file.path(ruta_proyecto,"ejemplos","casos.R"),local=.GlobalEnv,encoding="UTF-8")
source(file.path(ruta_proyecto,"comparaciones","comparar.R"),local=.GlobalEnv,encoding="UTF-8")

menu_pia <- function() {
  repeat {
    print(listar_casos(),row.names=FALSE)
    cat("\nEscriba un ID, C para comparar, o 0 para salir.\n")
    opcion <- toupper(trimws(readline("Opcion: ")))
    if (opcion=="0" || opcion=="") break
    tryCatch({
      if (opcion=="C") {
        print(comparar_raices(),row.names=FALSE)
        print(comparar_sistemas(),row.names=FALSE)
      } else ejecutar_caso(opcion)
    },error=function(e)cat("Revise los datos:",conditionMessage(e),"\n"))
  }
  invisible(NULL)
}
