# Contexto para asistentes de IA

Proyecto académico de Métodos Numéricos, UANL FIME. Equipo: Luis Enrique Almaguer Castillo, Omar Tadeo Gasca Deciga y Roberto Santana Trujillo. Docente Oralia Zamora Pequeño; asesor Said Zamora.

## Requisitos confirmados

- Treinta métodos listados en docs/catalogo_metodos.json.
- Algoritmos en R sin instalar ni cargar paquetes externos.
- Estilo de funciones con <-, argumentos claros, vectores, matrices y ciclos explícitos, inspirado en los ejemplos históricos.
- Desempeño únicamente por iteraciones.
- Entrega final: código, Manual de Usuario y Manual Técnico.
- Revisiones oficiales el 16, 18 y 20 de noviembre de 2026.
- Guía de estudio separada para comprender y programar los métodos.

## Criterios que NO están resueltos

Leer docs/PROTOCOLO_ITERACIONES.md. No inventar un conteo para directos, interpolación, cuadratura, proyecciones de Kaczmarz o etapas EDO. NA significa pendiente.

Los conteos de ciclos externos y barridos son convenciones propuestas en esta base, sujetas a revisión docente.

La tolerancia es una condición de terminación, no otro criterio de clasificación. No introducir tiempos o complejidad en las comparaciones.

## Estado

La base 0.1 fue preparada con apoyo de IA y tiene treinta implementaciones y 103 grupos de pruebas. Esto no implica aprobación docente ni revisión individual concluida. No atribuir a estudiantes commits, pruebas o experiencias que no realizaron.

El reparto de diez métodos por integrante está en docs/ORGANIZACION.md y es propuesto. No imponer una coordinación obligatoria.

## Reglas de cambios

No elaborar el Manual de Usuario ni el Manual Técnico en la etapa actual. Primero deben terminarse y validarse los códigos; después se requiere indicación explícita de Roberto para preparar los manuales. La guía de estudio y la organización sí pertenecen al trabajo autorizado.

1. Leer la guía y fuente del método antes de cambiar una fórmula.
2. No delegar el algoritmo a solve(), eigen(), polyroot(), uniroot(), spline() o integradores preconstruidos.
3. Conservar datos, condiciones, firma y variante; si cambian, explicar y actualizar la guía. Los manuales se prepararán en su etapa autorizada.
4. Probar contra una solución conocida o propiedad matemática, no solo contra otro código del mismo método.
5. Ejecutar Rscript pruebas/ejecutar_pruebas.R y las rutas de terminal afectadas.
6. Mantener los archivos de Said y de generaciones anteriores como referencias de solo lectura.
7. No dar por final ni aprobado lo que siga pendiente de la maestra.

Roberto utiliza Release para autorizar nuevos bloques de trabajo; respetar lo acordado en cada conversación.
