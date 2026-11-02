# PIA Métodos Numéricos 2026

Equipo 1 · UANL FIME · Luis, Tadeo y Roberto

Treinta métodos de la propuesta, desarrollados en R estándar sin instalar ni cargar paquetes externos. El único criterio de desempeño es el número de iteraciones.

Esta base 0.1 está preparada con apoyo de IA para que el equipo estudie, compruebe y adapte cada método. La aprobación docente y la revisión individual siguen pendientes. El reparto no atribuye la autoría del código inicial a los estudiantes.

## Empezar

Abre PIA_MN.Rproj en RStudio, o la carpeta en tu entorno R. En la consola:

~~~r
source("iniciar.R")
listar_casos()
menu_pia()
~~~

Escribe un ID como R01, C para comparar o 0 para salir.

Desde terminal, situado en esta carpeta:

~~~sh
Rscript ejecutar.R --caso R01
Rscript ejecutar.R --todos
Rscript ejecutar.R --comparar
Rscript pruebas/ejecutar_pruebas.R
~~~

Rscript es un comando de terminal. source() y menu_pia() se utilizan en la consola R.

## Qué está disponible

| Grupo | Métodos |
|---|---|
| Interpolación | Neville, spline natural, PCHIP, bilineal, Shepard, trigonométrica |
| Raíces | Ridders, Brent–Dekker, Müller, Halley, Ostrowski, Laguerre |
| Sistemas | LDLᵀ, SOR, Richardson, Kaczmarz, Schur, reducción cíclica |
| Integración | Boole, Gauss–Chebyshev, Gauss–Hermite, Gauss–Lobatto, Clenshaw–Curtis, Monte Carlo |
| EDO | AB2, AM3, BDF2, Hamming, velocity Verlet, Numerov |

Bisección, Newton, Gauss–Seidel y RK4 sirven como referencias o auxiliares iniciales. Confirmar con la maestra cuáles métodos del curso deben compararse finalmente.

## Documentación

- [Guía de estudio](docs/GUIA_ESTUDIO.md): fórmulas, procedimiento, ejemplos y relación con R.
- [Organización y reparto](docs/ORGANIZACION.md): diez métodos propuestos por integrante y revisiones del 16, 18 y 20 de noviembre.
- [Tareas de revisión](docs/TAREAS.md): seguimiento por método y pendientes comunes.
- [Protocolo de iteraciones](docs/PROTOCOLO_ITERACIONES.md).
- [Referencias](docs/REFERENCIAS.md).
- [Contexto para asistentes de IA](CONTEXTOIA.md).

La guía y el plan de organización se entregan también en PDF. Sus fuentes editables están aquí en Markdown.

El Manual de Usuario y el Manual Técnico son entregables posteriores. No se elaboran en esta etapa: primero se deben terminar y validar los códigos, y Roberto debe indicar que se preparen.

## Qué queda por confirmar

Said no definió el conteo para directos, interpolación, cuadratura, Kaczmarz y las etapas de EDO. Estos casos muestran iteraciones=NA; no significa cero. Se conserva el desarrollo técnico sin inventar equivalencias.

Los conteos actuales de ciclos externos y actualizaciones completas son convenciones propuestas para revisar con el docente.

## Validación

103 grupos de comprobación con soluciones analíticas, propiedades y recorridos de terminal; sin testthat. Probado con R 4.5.2 en macOS. Windows y el equipo de presentación deben probarse y documentarse antes de afirmar esa compatibilidad.

Las pruebas no demuestran que todo dato posible vaya a funcionar; las restricciones están en la guía y los manuales.

## Trabajar entre los tres

Consultar los issues de validación. El reparto es propuesto y modificable. Cada responsable estudia y prueba sus métodos; otro integrante revisa. Cambios en una rama corta, pruebas y pull request antes de integrar.

Los archivos originales de Said y de generaciones anteriores son referencias de consulta y no se modifican ni se copian completos al repositorio.
