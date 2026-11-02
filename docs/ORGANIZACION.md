# Organización del proyecto

## Alcance y estado

La entrega final requiere treinta métodos en R sin paquetes externos, el Manual de Usuario y el Manual Técnico. En esta etapa se trabaja en el código, la guía de estudio y la organización. Los manuales se prepararán después de terminar y validar los códigos, con indicación explícita de Roberto. El desempeño se compara únicamente mediante iteraciones.

La base 0.1 contiene las treinta implementaciones, ejemplos y pruebas iniciales. Que el código esté disponible no significa que el equipo haya terminado de revisarlo ni que la maestra lo haya aprobado.

Repositorio privado: [PIA MN 2026](https://github.com/Santana-R/PIA-MN-2026).

Se revisaron la propuesta corregida, R.zip, los manuales históricos de Mauricio y Diego, y de Andrés y Tadeo, además de ejemplos de código en Drive. Se conserva el estilo de funciones, <-, vectores, matrices y ciclos explícitos. Los originales no se modificaron.

## Reparto propuesto

Cada integrante recibe diez métodos: dos de interpolación, dos de raíces, dos de sistemas, dos de integración y dos de EDO. El reparto combina dificultades y dependencias. Es modificable después de que cada quien pruebe sus primeros casos.

### Roberto

Revisor propuesto: Luis.

| ID | Método | Archivo |
|---|---|---|
| I01 | Algoritmo de Neville | R/interpolacion/I01_neville.R |
| I04 | Interpolación bilineal | R/interpolacion/I04_bilineal.R |
| R02 | Método de Brent y Dekker | R/raices/R02_brent_dekker.R |
| R05 | Método de Ostrowski | R/raices/R05_ostrowski.R |
| L02 | Sobrerrelajación sucesiva SOR | R/sistemas/L02_sor.R |
| L05 | Eliminación por bloques con complemento de Schur | R/sistemas/L05_schur.R |
| Q01 | Regla de Boole | R/integracion/Q01_boole.R |
| Q04 | Gauss Lobatto Legendre | R/integracion/Q04_gauss_lobatto.R |
| E03 | Diferenciación hacia atrás BDF2 | R/edo/E03_bdf2.R |
| E06 | Método de Numerov | R/edo/E06_numerov.R |

### Luis

Revisor propuesto: Tadeo.

| ID | Método | Archivo |
|---|---|---|
| I02 | Spline cúbico natural | R/interpolacion/I02_spline_natural.R |
| I05 | Interpolación de Shepard | R/interpolacion/I05_shepard.R |
| R01 | Método de Ridders | R/raices/R01_ridders.R |
| R06 | Método de Laguerre | R/raices/R06_laguerre.R |
| L01 | Factorización LDLᵀ | R/sistemas/L01_ldlt.R |
| L06 | Reducción cíclica | R/sistemas/L06_reduccion_ciclica.R |
| Q02 | Gauss Chebyshev de primera especie | R/integracion/Q02_gauss_chebyshev.R |
| Q05 | Clenshaw Curtis | R/integracion/Q05_clenshaw_curtis.R |
| E01 | Adams Bashforth de dos pasos | R/edo/E01_adams_bashforth2.R |
| E04 | Predictor corrector de Hamming modificado | R/edo/E04_hamming.R |

### Tadeo

Revisor propuesto: Roberto.

| ID | Método | Archivo |
|---|---|---|
| I03 | Interpolación PCHIP | R/interpolacion/I03_pchip.R |
| I06 | Interpolación trigonométrica | R/interpolacion/I06_trigonometrica.R |
| R03 | Método de Müller | R/raices/R03_muller.R |
| R04 | Método de Halley | R/raices/R04_halley.R |
| L03 | Iteración de Richardson | R/sistemas/L03_richardson.R |
| L04 | Proyección por filas de Kaczmarz | R/sistemas/L04_kaczmarz.R |
| Q03 | Gauss Hermite | R/integracion/Q03_gauss_hermite.R |
| Q06 | Integración Monte Carlo simple | R/integracion/Q06_monte_carlo.R |
| E02 | Adams Moulton de dos pasos y orden tres | R/edo/E02_adams_moulton3.R |
| E05 | Störmer Verlet con velocidades | R/edo/E05_verlet.R |

## Trabajo de cada responsable

Las tareas son estudiar, comprobar y adaptar la implementación inicial. Un método no queda revisado solo porque devuelve un número.

1. Leer la sección de la guía y abrir la ubicación de su fuente.
2. Explicar entradas, algoritmo, condiciones y salida con sus propias palabras.
3. Desarrollar a mano el primer avance o una parte representativa.
4. Ejecutar el caso inicial y otro caso válido con solución conocida.
5. Probar una entrada incompatible y revisar el mensaje o límite de ejecución.
6. Justificar el contador o conservar el pendiente docente.
7. Actualizar comentarios y la guía si cambia el comportamiento.
8. Pedir revisión cruzada y registrar lo comprobado en el issue.

### Revisión cruzada

Luis revisa los métodos de Roberto; Tadeo los de Luis; Roberto los de Tadeo. El revisor ejecuta el caso y contrasta una propiedad matemática. Los tres pueden apoyarse y cambiar el reparto; no se crea un coordinador obligatorio.

## Trabajo con GitHub

main conserva la versión que pasa las pruebas. Cada cambio se hace en una rama corta y se integra mediante un pull request que revisa otro integrante. Este flujo se basa en GitHub flow [30].

~~~sh
git pull
git switch -c revisar/R01-ridders
Rscript pruebas/ejecutar_pruebas.R
git add R/raices/R01_ridders.R docs/GUIA_ESTUDIO.md
git commit -m "Revisa Ridders y documenta un caso adicional"
git push -u origin revisar/R01-ridders
~~~

git pull trae cambios. git switch -c crea una rama. git add selecciona archivos; commit guarda una versión con explicación y push la sube a GitHub. Después se abre el pull request desde el repositorio.

Cada integrante registra las revisiones que realmente realizó. La base inicial fue preparada con apoyo de IA y no se atribuyen esos commits a los estudiantes.

<!-- PAGE -->

## Calendario de trabajo

| Fechas | Avance previsto | Evidencia o revisión |
|---|---|---|
| 2 al 4 de noviembre | Ejecutar casos, estudiar el arranque y consultar el conteo. | Un caso explicado por integrante y dudas concretas. |
| 5 y 6 de noviembre | Primera muestra breve propuesta, según disponibilidad de la maestra. | Dos problemas, tabla de iteraciones, traza y guía. |
| 7 y 8 de noviembre | Atender la primera retroalimentación. | Cambios y criterios anotados. |
| 9 al 11 de noviembre | Revisión cruzada y casos adicionales. | Entradas válidas e incompatibles y textos coherentes. |
| 12 y 13 de noviembre | Segunda muestra previa propuesta. | Código integrado y ejecución en otro equipo; iniciar manuales solo si el código está cerrado y Roberto lo indica. |
| 16 de noviembre | Primera revisión oficial. | Commit presentado y observaciones. |
| 17 de noviembre | Correcciones. | Evidencia de lo atendido. |
| 18 de noviembre | Segunda revisión oficial. | Código y manuales de la misma versión. |
| 19 de noviembre | Consolidar la última versión. | Pruebas, ejemplos y documentos actualizados. |
| 20 de noviembre | Última revisión y entrega como indique la maestra. | Versión presentada y resultado real de la revisión. |

Las fechas 16, 18 y 20 fueron proporcionadas por Roberto. Las muestras previas son una propuesta; no son citas ya acordadas con la maestra.

## Aclaraciones por confirmar

| Asunto | Pregunta | Efecto |
|---|---|---|
| Directos e interpolación | ¿Qué cuenta como iteración? | Completar campos pendientes sin inventar equivalencias. |
| Kaczmarz | ¿Proyección o barrido? | Usar una unidad definida. |
| Cuadratura | ¿Nodos, paneles o refinamientos sucesivos? | Diseñar el experimento indicado. |
| EDO | ¿Malla, arranque e iteraciones internas? | No ocultar etapas. |
| Referencias del curso | ¿Cuáles métodos pide comparar en cada problema? | Ampliar las referencias iniciales si corresponde. |
| Documentación final | ¿Exige apartados o evidencias adicionales? | Ajustar los manuales antes de entregar. |

## Primera muestra a la maestra

Presenten x³−x−2 con bisección y Ridders, y el sistema de dos ecuaciones con Gauss–Seidel y SOR. Muestren una traza para justificar dónde se incrementa el contador.

~~~r
source("iniciar.R")
ejecutar_caso("R01")
comparar_raices()
comparar_sistemas()
z <- ejecutar_caso("L02", mostrar=FALSE)
z$historial
~~~

No es necesario recorrer treinta ejemplos en la primera muestra. La finalidad es confirmar estilo, alcance y conteo antes de cerrar las comparaciones.

## Criterio de revisión

Un método queda revisado por el equipo cuando la explicación coincide con la fuente y el código, las entradas están claras, hay una comprobación conocida, el contador se puede justificar o sigue pendiente de forma explícita, el revisor ejecutó el caso y los manuales reflejan la versión actual. La aprobación docente se registra aparte.

La guía desarrolla fórmulas y ejemplos. Una corrección que cambie el comportamiento debe actualizar el código y la explicación afectada. Después de cerrar y validar los códigos, y cuando Roberto lo indique, se elaborarán el Manual de Usuario y el Manual Técnico.
