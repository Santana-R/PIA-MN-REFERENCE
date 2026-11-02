# PIA MN - Equipo 1 - R sin paquetes externos.
# Las rutinas se desarrollan con funciones, vectores, matrices y ciclos.
# Ninguna funcion carga ejemplos al utilizar source().

validar_numero <- function(x, nombre, positivo = FALSE) {
  if (!(is.numeric(x) || is.complex(x)) || length(x) != 1L || !is.finite(x) ||
      (positivo && (is.complex(x) || x <= 0))) stop(paste("Revise", nombre))
}

validar_entero <- function(n, minimo = 1L, nombre = "n") {
  validar_numero(n, nombre)
  if (n != floor(n) || n < minimo) stop(paste(nombre, "debe ser entero y al menos", minimo))
}

evaluar <- function(f, x) {
  y <- f(x)
  if (!(is.numeric(y) || is.complex(y)) || length(y) != 1L || !is.finite(y)) {
    stop("La funcion debe devolver un numero finito para cada entrada")
  }
  y
}

control_iterativo <- function(tol, max_iter) {
  validar_numero(tol, "la tolerancia", TRUE)
  validar_entero(max_iter, 1L, "max_iter")
}

resultado <- function(valor, iteraciones = NA_integer_, historial = NULL,
                      convergio = TRUE, mensaje = "Calculo terminado",
                      unidad = "Pendiente de confirmar con Said", detalles = list()) {
  list(valor = valor, iteraciones = iteraciones, convergio = convergio,
       mensaje = mensaje, unidad = unidad, historial = historial, detalles = detalles)
}

validar_nodos <- function(x, y, minimo = 2L) {
  if (!is.numeric(x) || !is.numeric(y) || length(x) != length(y) ||
      length(x) < minimo || any(!is.finite(x)) || any(!is.finite(y)) ||
      any(diff(x) <= 0)) stop("Use nodos reales crecientes y distintos, con un valor y por nodo")
}

validar_sistema <- function(A, b) {
  if (!is.matrix(A) || !is.numeric(A) || nrow(A) != ncol(A) ||
      nrow(A) < 1L || length(b) != nrow(A) || !is.numeric(b) ||
      any(!is.finite(A)) || any(!is.finite(b))) {
    stop("Use una matriz cuadrada finita y un vector b del mismo numero de filas")
  }
}

# Eliminacion con pivoteo parcial y sustitucion. Auxiliar propio; no usa solve().
gauss_propio <- function(A, b) {
  validar_sistema(A, b)
  n <- nrow(A)
  A <- A + 0
  b <- as.numeric(b)
  escala <- max(abs(A))
  if (escala == 0) stop("El sistema no tiene pivotes utilizables")
  if (n > 1L) for (k in seq_len(n - 1L)) {
    p <- k - 1L + which.max(abs(A[k:n, k]))
    if (abs(A[p, k]) <= .Machine$double.eps * escala * n) {
      stop("La matriz es singular o sus pivotes son demasiado pequenos")
    }
    if (p != k) {
      fila <- A[k, ]; A[k, ] <- A[p, ]; A[p, ] <- fila
      aux <- b[k]; b[k] <- b[p]; b[p] <- aux
    }
    for (i in (k + 1L):n) {
      m <- A[i, k] / A[k, k]
      A[i, k:n] <- A[i, k:n] - m * A[k, k:n]
      b[i] <- b[i] - m * b[k]
    }
  }
  if (abs(A[n, n]) <= .Machine$double.eps * escala * n) {
    stop("La matriz es singular o sus pivotes son demasiado pequenos")
  }
  x <- numeric(n)
  for (i in n:1L) {
    suma <- 0
    if (i < n) for (j in (i + 1L):n) suma <- suma + A[i, j] * x[j]
    x[i] <- (b[i] - suma) / A[i, i]
  }
  x
}

norma_residuo <- function(A, b, x) {
  max(abs(as.numeric(A %*% x) - b)) / max(1, max(abs(b)))
}

tabla_raices <- function() data.frame(k = integer(), x = complex(), residuo = numeric())

validar_intervalo <- function(f, a, b, tol = 0) {
  validar_numero(a, "a"); validar_numero(b, "b")
  if (a >= b) stop("El extremo a debe ser menor que b")
  fa <- evaluar(f, a); fb <- evaluar(f, b)
  if (is.complex(fa) || is.complex(fb)) stop("El intervalo requiere una funcion real")
  if (abs(fa) > tol && abs(fb) > tol && sign(fa) == sign(fb)) {
    stop("El intervalo no presenta cambio de signo")
  }
  c(fa, fb)
}

# Auxiliar de nodos de cuadratura; sus iteraciones NO se reportan como desempeno.
biseccion_aux <- function(f, a, b, tol = 1e-13, max_iter = 200L) {
  fa <- f(a); fb <- f(b)
  if (fa == 0) return(a)
  if (fb == 0) return(b)
  if (sign(fa) == sign(fb)) stop("No se pudo encerrar un nodo de cuadratura")
  for (k in seq_len(max_iter)) {
    m <- a + (b - a) / 2
    fm <- f(m)
    if (fm == 0 || abs(b - a) <= tol * max(1, abs(m))) return(m)
    if (sign(fa) != sign(fm)) { b <- m; fb <- fm } else { a <- m; fa <- fm }
  }
  stop("No se pudo calcular un nodo con la tolerancia interna")
}
