# Protocolo de comparación por iteraciones

Versión 0.1. Único criterio de desempeño: número de iteraciones.

## Convenciones operativas propuestas

Estas convenciones permiten revisar el prototipo. No se atribuyen a Said, quien todavía no explicó los casos particulares.

| Familia | Conteo en la base | Estado |
|---|---|---|
| Raíces | Un ciclo externo por aproximación aceptada; Ostrowski incluye dos etapas en un ciclo. | Propuesto para revisión |
| SOR y Gauss–Seidel | Un barrido completo de las incógnitas. | Propuesto para revisión |
| Richardson | Una actualización completa del vector. | Propuesto para revisión |
| Kaczmarz | Se conservan barridos y proyecciones por separado. | Pendiente de elegir unidad |
| Directos e interpolación | iteraciones=NA. | Pendiente |
| Integración | iteraciones=NA; nodos, paneles y muestras son datos del método. | Pendiente |
| EDO | iteraciones=NA; malla, arranque y Newton interno separados. | Pendiente |

No sustituir NA por cero ni por el número de vueltas de cualquier ciclo.

## Condiciones de terminación

- Raíces: abs(f(x)) <= tol.
- Sistemas: max(abs(A %*% x-b))/max(1,max(abs(b))) <= tol.
- La entrada inicial se comprueba: si ya cumple, cero actualizaciones.
- max_iter limita ejecución; convergio=FALSE si no se cumple.
- AM3 y BDF2 tienen controles internos para resolver su ecuación implícita. No se suman automáticamente al conteo externo.

La tolerancia define cuándo termina el cálculo; no se usa como otro criterio de clasificación de desempeño.

## Experimentos iniciales

Raíces: x^3-x-2; intervalo [1,2], semilla 1.5 o terna (1,1.5,2), según el método; tol=1e-8.

Sistemas: A=[[4,1],[1,3]], b=(1,2), x0=(0,0), tol=1e-8. SOR usa omega=1.1; Richardson usa omega=0.2. Son parámetros fijos de ejemplo, sin optimización oculta.

Se reportan solo procesos convergidos como resultados válidos. Las conclusiones corresponden al caso documentado; no se presenta un ganador universal.

## Pregunta para Said

En los métodos directos, interpolación e integración, ¿qué debemos contar como iteración? En Kaczmarz, ¿una proyección o un barrido? En EDO, ¿los pasos de malla, las iteraciones internas o ambos? ¿Se incluye el arranque?

También confirmar cuáles métodos del programa actual pide comparar; el catálogo histórico de Drive no constituye por sí solo esa lista.
