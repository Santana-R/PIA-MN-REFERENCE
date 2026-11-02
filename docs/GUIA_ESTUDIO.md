# Guía de estudio y programación en R

## Cómo usar esta guía

Esta guía está dirigida a Luis, Tadeo y Roberto. Explica los treinta métodos de la propuesta y cómo traducirlos a funciones de R. Es material de estudio del equipo. Los manuales son entregables posteriores: se prepararán cuando los códigos estén terminados y validados, y Roberto lo indique.

El criterio de desempeño solicitado por Said es exclusivamente el número de iteraciones. La tolerancia define cuándo termina un método iterativo. Hay procedimientos directos y métodos con pasos, muestras o iteraciones internas: su conteo comparativo queda pendiente de confirmar.

Para estudiar una sección, identifica el problema y sus datos, realiza el ejemplo a mano, ubica los pasos en el archivo R y ejecuta un caso distinto. No hace falta memorizar treinta fórmulas para poder revisar y explicar un programa.

| Código | Problema | Métodos |
|---|---|---|
| I | Interpolación de datos | 6 |
| R | Búsqueda de raíces | 6 |
| L | Sistemas lineales | 6 |
| Q | Integración numérica | 6 |
| E | Ecuaciones diferenciales ordinarias | 6 |

I y R son dos grupos de estudio dentro de la primera fase de la propuesta. Los grupos L, Q y E corresponden a sus otras tres fases.

### Qué cambia entre los problemas

![Conceptos](CONCEPTOS)

Los dibujos muestran el objetivo de cada problema; no comparan desempeño.

### Notación que conviene comprender

| Símbolo | Significado |
|---|---|
| f(x) | Función evaluada; en raíces se busca f(x)=0. |
| xₖ y x₀ | Aproximación del ciclo k y aproximación inicial. |
| tol | Tolerancia que define una condición de terminación. |
| A, b, x | Matriz, términos independientes e incógnitas de Ax=b. |
| h | Separación entre nodos consecutivos de una malla uniforme. |
| n o N | Según el método, cuenta nodos, subintervalos o muestras. |
| f′ y f″ | Primera y segunda derivada. |
| Implícito | El nuevo valor aparece dentro de una ecuación que se debe resolver. |

<!-- PAGE -->

## R que necesitamos para el proyecto

Se utilizaron las presentaciones entregadas en R.zip como guía de sintaxis. Las secciones de importación con dplyr, gráficos con ggplot2 y reportes con knitr no se incorporan a los algoritmos porque usan paquetes externos.

| Recurso de Said | Páginas | Aplicación |
|---|---|---|
| Diplomado Sesión I Fundamentos y estructuras | 13; 19 a 23; 27 a 30 | Asignación, vectores, listas y matrices. |
| R para estadística Sesión I Introducción a R | 12; 18 a 22; 26 a 29 | Los mismos fundamentos en otra presentación. |
| R para estadística Sesión II Estructuras | 26 y 27 | Seleccionar celdas, filas y columnas; conservar dimensiones. |
| Otras cuatro presentaciones y SIV Markdown.Rmd | Consulta selectiva | Contexto adicional sin trasladar llamadas a paquetes externos. |

### Asignaciones vectores y matrices

~~~r
tol <- 1e-8
x <- c(0, 1, 2)
A <- matrix(c(4, 1, 1, 3), nrow=2, byrow=TRUE)
A[1, 2]                # Fila 1 y columna 2
A[1, , drop=FALSE]     # Conserva una matriz de una fila
~~~

R empieza a contar posiciones en 1. matrix() llena por columnas si no se indica byrow=TRUE. Declarar el orden evita cambiar una matriz que se ha escrito por filas.

### Una función recibe datos y devuelve resultados

~~~r
cuadrado <- function(x) {
  valor <- x*x
  return(valor)
}
cuadrado(3)
~~~

Definir una función no la ejecuta. source() lee un archivo para dejar disponibles sus funciones. Se pasan datos como argumentos para evitar depender de variables antiguas de la consola.

### Un ciclo y su contador

~~~r
iter <- 0L
for (k in seq_len(max_iter)) {
  # Calcular una actualizacion completa del metodo
  iter <- iter + 1L
  # Guardar la aproximacion y revisar la condicion de parada
}
~~~

La ubicación del contador depende del método. En SOR se incrementa después de actualizar todas las incógnitas, no dentro del ciclo de filas. Una entrada que ya cumple la condición requiere cero actualizaciones.

### Errores habituales al traducir la matemática

El operador * multiplica elemento a elemento; %*% realiza un producto matricial. Para asignar, el proyecto conserva <- por coherencia con los ejemplos anteriores. Para probar igualdad se utiliza ==.

1:0 produce c(1,0), no una secuencia vacía. El código usa seq_len() y revisa tamaños antes de recorrer índices. drop=FALSE evita convertir inesperadamente una submatriz en vector.

Para complejos se escribe 1+1i y se usa abs() como módulo. R distingue is.numeric() de is.complex(); las validaciones de raíces admiten ambos. Müller y Laguerre utilizan raíz cuadrada compleja cuando corresponde.

El programa utiliza funciones de una instalación estándar de R. No instala ni carga paquetes externos. Los algoritmos no se delegan a solve(), uniroot(), spline(), polyroot() ni a integradores ya resueltos. El manual oficial de R sirve como referencia adicional de sintaxis [29].

## Cómo interpretar las iteraciones

Para raíces se propone contar un ciclo externo que produzca una nueva aproximación aceptada. Los puntos iniciales no cuentan. Las dos etapas de Ostrowski se documentan dentro de un mismo ciclo.

Para SOR y Gauss–Seidel se cuenta un barrido completo. Richardson cuenta una actualización completa del vector. Son convenciones operativas propuestas para revisar con el docente; no se atribuyen a una indicación que Said no ha dado.

| Grupo | Registro técnico | Decisión pendiente |
|---|---|---|
| Raíces | Ciclos externos. | Confirmar subetapas. |
| SOR y Richardson | Actualizaciones completas. | Confirmar equivalencia del barrido. |
| Kaczmarz | Barridos y proyecciones separados. | Elegir unidad de iteración. |
| Directos e interpolación | Desarrollo y datos. | Definir si llevan otro conteo o quedan sin comparación iterativa. |
| Integración | Nodos, paneles o muestras. | Definir qué proceso se va a iterar. |
| EDO | Malla, arranque y Newton interno. | Definir qué etapas contabilizar. |

### Condiciones de terminación iniciales

En raíces:

$$
|f(x_k)|\leq \mathrm{tol}
$$

En sistemas:

$$
\frac{\|Ax_k-b\|_\infty}{\max(1,\|b\|_\infty)}\leq \mathrm{tol}
$$

La tolerancia define cuándo termina el cálculo; no se utiliza como un criterio adicional de clasificación. Si se alcanza max_iter sin cumplirla, convergio es FALSE. Su contador no convierte ese caso en una solución válida.

Los métodos sin criterio definido devuelven iteraciones=NA. NA significa pendiente, no cero. No se construye una clasificación global con ellos.

### Aclaración para el ingeniero

En directos, interpolación e integración, ¿qué debemos llamar iteración? En Kaczmarz, ¿una proyección o un barrido? En EDO, ¿los avances de malla, las iteraciones internas o ambos? ¿Se cuenta el arranque?

Si todos los integradores de una EDO usan la misma malla, completarán el mismo número de pasos externos. Debemos confirmar qué proceso quiere contabilizar el ingeniero para diseñar la comparación que solicita.

### Comparar el mismo problema

Una interpolación bilineal de dos variables no se compara directamente con Neville de una variable usando otros datos. Una integral con peso gaussiano no es la integral ordinaria de la misma expresión en un intervalo finito. Las transformaciones necesarias deben quedar escritas.

## I01 Algoritmo de Neville [1]

Imagina que quieres conocer un valor entre datos de una tabla. Neville empieza con valores individuales, forma rectas entre pares y combina esas aproximaciones hasta utilizar todos los nodos. Calcula el valor solicitado sin expandir el polinomio completo.

### Datos de entrada

x contiene nodos crecientes distintos; y contiene sus valores. consulta es el punto donde se evalúa el interpolante.

$$
Q_{i,0}=y_i
$$

$$
Q_{i,j}=\frac{(z-x_{i-j})Q_{i,j-1}-(z-x_i)Q_{i-1,j-1}}{x_i-x_{i-j}}
$$

z representa consulta; j indica cuántas combinaciones se han realizado e i identifica el último nodo del grupo. Q es una tabla triangular.

### Procedimiento

1. Coloca los valores y en la primera columna de Q.

2. Combina dos celdas de la columna anterior usando los nodos de sus extremos.

3. Repite con grupos de tres, cuatro y más nodos.

4. Devuelve la última celda: utiliza todos los datos.

### Ejemplo explicado

Para (0,0), (1,1), (2,4) y z=1.5, las rectas dan 1.5 y 2.5. La siguiente combinación es (1.5·2.5−(−0.5)·1.5)/2=2.25. Coincide con z².

### Relación con R

~~~r
neville(x, y, consulta)
~~~

Q es una matriz; dos ciclos recorren sus columnas y filas. En R los índices empiezan en 1: la primera columna representa j=0 de la fórmula.

### Condiciones y límites

Un nodo repetido hace cero un denominador. Que haya más datos no garantiza una mejor aproximación fuera de ellos; aquí se evalúa un polinomio, no se busca una raíz.

### Conteo y comprobación

Es un procedimiento directo. Los niveles de la tabla no se presentan como iteraciones de convergencia. iteraciones permanece pendiente.

Reproducir exactamente, salvo redondeo, un polinomio de grado menor que el número de nodos.

Archivo: R/interpolacion/I01_neville.R. Caso ejecutable: I01.

## I02 Spline cúbico natural [2]

En lugar de forzar un único polinomio por todos los datos, construye una curva cúbica en cada intervalo. Las piezas se unen con la misma pendiente y curvatura. La condición natural fija curvatura cero en los extremos.

### Datos de entrada

Nodos x crecientes, valores y y una consulta dentro del intervalo de datos.

$$
h_i=x_{i+1}-x_i,\quad M_0=M_{N-1}=0
$$

$$
h_{i-1}M_{i-1}+2(h_{i-1}+h_i)M_i+h_iM_{i+1}=6(d_i-d_{i-1})
$$

$$
S(z)=Ay_i+By_{i+1}+\frac{h_i^2}{6}[(A^3-A)M_i+(B^3-B)M_{i+1}]
$$

d_i=(y_(i+1)−y_i)/h_i; M_i es la segunda derivada en el nodo. A=(x_(i+1)−z)/h_i y B=(z−x_i)/h_i.

### Procedimiento

1. Calcula los tamaños h y las pendientes d de cada intervalo.

2. Arma el sistema para las segundas derivadas interiores.

3. Resuélvelo con eliminación propia y agrega los dos ceros naturales.

4. Localiza el intervalo de consulta y evalúa su expresión cúbica.

### Ejemplo explicado

Con x=(0,1,2), y=(0,1,0), la ecuación interior es 4M₁=−12, así que M=(0,−3,0). En z=0.5, A=B=0.5 y S(0.5)=0.6875.

### Relación con R

~~~r
spline_natural(x, y, consulta)
~~~

Los coeficientes interiores se calculan con gauss_propio(). No se llama a spline() ni a solve(). Con dos nodos la expresión se reduce a una recta.

### Condiciones y límites

Natural no significa pendiente cero. Tampoco es la condición not a knot usada en otros programas. La rutina rechaza consultas fuera de los datos.

### Conteo y comprobación

La factorización y la evaluación son directas; el criterio comparativo de iteraciones está pendiente.

Comprobar los valores en los nodos y las segundas derivadas nulas en los extremos.

Archivo: R/interpolacion/I02_spline_natural.R. Caso ejecutable: I02.

## I03 Interpolación PCHIP [3], [4]

PCHIP une polinomios cúbicos de Hermite. Su decisión principal es cómo escoger las pendientes en los nodos para evitar oscilaciones que contradigan la monotonía de los datos.

### Datos de entrada

Nodos x estrictamente crecientes, valores y y una consulta interior.

$$
d_i=\frac{y_{i+1}-y_i}{h_i},\quad h_i=x_{i+1}-x_i
$$

$$
m_i=\frac{w_1+w_2}{w_1/d_{i-1}+w_2/d_i},\quad w_1=2h_i+h_{i-1},\quad w_2=h_i+2h_{i-1}
$$

$$
P(t)=(2t^3-3t^2+1)y_i+(t^3-2t^2+t)h_im_i
$$

$$
\qquad+(-2t^3+3t^2)y_{i+1}+(t^3-t^2)h_im_{i+1}
$$

t=(z−x_i)/h_i. Si las pendientes vecinas cambian de signo o alguna es cero, se fija m_i=0. En los extremos se usa una fórmula unilateral y se limita su signo y magnitud.

### Procedimiento

1. Calcula las pendientes secantes de los intervalos.

2. Obtén cada pendiente interior con la regla de signo y la media armónica.

3. Calcula la pendiente unilateral del extremo; si cambia el signo, usa cero; si procede, limítala a tres veces la secante.

4. Evalúa la base cúbica de Hermite del intervalo.

### Ejemplo explicado

Para x=(0,1,2), y=(0,1,1.5), las secantes son 1 y 0.5. La pendiente interior resulta 2/3; la inicial es 1.25. En z=0.5 se obtiene aproximadamente 0.5729167.

### Relación con R

~~~r
pchip(x, y, consulta)
~~~

La función extremo() contiene las limitaciones de borde. Con dos datos se utilizan las dos pendientes iguales a la secante.

### Condiciones y límites

PCHIP es continuo junto con su primera derivada; la segunda puede saltar. No equivale al spline natural.

### Conteo y comprobación

No hay convergencia iterativa en esta formulación. El conteo para desempeño sigue pendiente.

Recuperar los nodos y verificar que datos crecientes no produzcan descensos ni sobrepasen los extremos de cada tramo.

Archivo: R/interpolacion/I03_pchip.R. Caso ejecutable: I03.

## I04 Interpolación bilineal [5]

Sirve para estimar un valor dentro de un rectángulo, conociendo sus cuatro esquinas. Primero puede imaginarse una interpolación horizontal en cada borde y después una vertical entre ambos resultados.

### Datos de entrada

x=(x₁,x₂), y=(y₁,y₂), una matriz Z de 2 por 2 y el punto interior. Las filas de Z corresponden a y y las columnas a x.

$$
u=\frac{x-x_1}{x_2-x_1},\quad v=\frac{y-y_1}{y_2-y_1}
$$

$$
z=(1-u)(1-v)z_{11}+u(1-v)z_{12}+(1-u)vz_{21}+uvz_{22}
$$

u y v son posiciones relativas entre 0 y 1. Cada producto es el peso de una esquina; los cuatro pesos suman uno.

### Procedimiento

1. Comprueba que el rectángulo tenga ancho y alto positivos.

2. Convierte la consulta a las coordenadas u y v.

3. Calcula los cuatro pesos.

4. Multiplica cada esquina por su peso y suma.

### Ejemplo explicado

Con Z=[[0,2],[3,5]] en el cuadrado unidad, el centro tiene u=v=0.5. Los cuatro pesos son 0.25 y el resultado es (0+2+3+5)/4=2.5.

### Relación con R

~~~r
bilineal(x, y, Z, consulta_x, consulta_y)
~~~

matrix(c(0,2,3,5), 2, byrow=TRUE) conserva el orden por filas del dibujo. Intercambiar filas y columnas cambia la interpretación.

### Condiciones y límites

No debe compararse directamente con interpoladores de una sola variable usando datos distintos. La rutina no extrapola fuera del rectángulo.

### Conteo y comprobación

La fórmula es directa. No se reportan cuatro esquinas como cuatro iteraciones.

Recuperar las cuatro esquinas y reproducir una función de la forma a+b·x+c·y+d·x·y.

Archivo: R/interpolacion/I04_bilineal.R. Caso ejecutable: I04.

## I05 Interpolación de Shepard [6]

Combina datos dispersos dando mayor peso a los puntos cercanos. No necesita una malla rectangular. El exponente p controla cuánto predominan los vecinos más próximos.

### Datos de entrada

Posiciones (x_i,y_i), valores z_i, una consulta y p positivo.

$$
r_i=\sqrt{(x-x_i)^2+(y-y_i)^2},\quad w_i=r_i^{-p}
$$

$$
S(x,y)=\frac{\sum_i w_i z_i}{\sum_i w_i}
$$

r_i es una distancia. El valor final es un promedio ponderado. Si la consulta coincide con un dato, se devuelve directamente su valor.

### Procedimiento

1. Verifica que no haya posiciones repetidas.

2. Calcula las distancias a todos los datos.

3. Resuelve primero el caso de distancia cero.

4. Normaliza los pesos y calcula el promedio.

### Ejemplo explicado

En las cuatro esquinas del cuadrado unidad, todos los puntos están a la misma distancia del centro. Por eso, para valores 0,2,3,5, el centro vale 2.5. En la esquina cuyo dato es 5 se devuelve 5 sin dividir entre cero.

### Relación con R

~~~r
shepard(x, y, z, consulta_x, consulta_y, p=2)
~~~

El código utiliza (distancia_mínima/distancia)^p. Este escalado conserva los pesos relativos y reduce problemas por números demasiado grandes.

### Condiciones y límites

p=2 es una elección del ejemplo, no una constante obligatoria del método. Shepard global puede aplanar la curva cerca de los datos y no reproduce todo plano.

### Conteo y comprobación

El recorrido de datos no se identifica automáticamente con iteraciones comparativas.

Reproducir valores en los nodos y cualquier conjunto de valores constantes.

Archivo: R/interpolacion/I05_shepard.R. Caso ejecutable: I05.

## I06 Interpolación trigonométrica [7]

Cuando los datos describen un fenómeno periódico, una combinación de senos y cosenos respeta esa periodicidad. Aquí se usa un número impar de muestras equiespaciadas.

### Datos de entrada

N=2m+1 valores de un periodo T. Sus nodos son origen+j·T/N, j=0,...,N−1. No se repite el extremo del periodo.

$$
p(\theta)=\frac{a_0}{2}+\sum_{k=1}^{m}[a_k\cos(k\theta)+b_k\sin(k\theta)]
$$

$$
a_k=\frac{2}{N}\sum_{j=0}^{N-1}y_j\cos(k\theta_j),\quad b_k=\frac{2}{N}\sum_{j=0}^{N-1}y_j\sin(k\theta_j)
$$

$$
\theta_j=\frac{2\pi j}{N},\quad \theta=\frac{2\pi(z-\mathrm{origen})}{T}
$$

a₀/2 es el promedio de los datos. k identifica una frecuencia y θ transforma cualquier periodo a un ángulo.

### Procedimiento

1. Comprueba que N sea impar y el periodo positivo.

2. Calcula los ángulos de las muestras.

3. Acumula los coeficientes de cada seno y coseno.

4. Evalúa el mismo conjunto de frecuencias en la consulta.

### Ejemplo explicado

Toma cinco muestras de 2+sin(x)+0.5cos(2x) sobre [0,2π), sin incluir 2π. Como las frecuencias son 1 y 2, el interpolante recupera esa expresión y su valor en 0.7.

### Relación con R

~~~r
trigonometrica(y, consulta, periodo=2*pi, origen=0)
~~~

Se implementan las sumas con ciclos y funciones trigonométricas estándar. No se usa FFT ni un paquete de Fourier.

### Condiciones y límites

Las fórmulas cambian con un número par de muestras. Repetir el primer dato al final altera N y rompe esta formulación.

### Conteo y comprobación

Las frecuencias y las muestras no se declaran como iteraciones sin una indicación docente.

Recuperar las muestras y obtener el mismo valor al sumar un periodo a la consulta.

Archivo: R/interpolacion/I06_trigonometrica.R. Caso ejecutable: I06.

## R01 Método de Ridders [8]

Conserva un intervalo que encierra una raíz y utiliza el punto medio para proponer una corrección. Si conocemos signos opuestos en los extremos y la función es continua, seguimos conservando una raíz dentro del intervalo.

### Datos de entrada

Función real continua, extremos a<b con cambio de signo, tolerancia y límite de ciclos.

$$
m=\frac{a+b}{2},\quad s=\sqrt{f(m)^2-f(a)f(b)}
$$

$$
x=m+(m-a)\frac{\operatorname{sign}(f(a)-f(b))f(m)}{s}
$$

m es el punto medio. La raíz cuadrada es real al haber signos opuestos en los extremos. El signo de la corrección depende de los valores de ambos bordes.

### Procedimiento

1. Revisa primero si un extremo ya cumple la tolerancia.

2. Evalúa el punto medio y, si procede, calcula la corrección.

3. Acepta el nuevo punto y comprueba su residuo.

4. Conserva el par de puntos que tenga signos opuestos y repite.

### Ejemplo explicado

En f(x)=x³−x−2, [1,2], tenemos f(1)=−2, f(2)=4 y f(1.5)=−0.125. La primera corrección queda cerca de 1.52208. El programa conserva el intervalo y refina el resultado.

### Relación con R

~~~r
ridders(f, a, b, tol=1e-8, max_iter=1000)
~~~

El radicando se calcula con los valores de f escalados para evitar desbordamientos. Si la corrección resulta inválida, el programa usa el punto medio.

### Condiciones y límites

Un cambio de signo no garantiza una raíz si hay una discontinuidad. No se usa para funciones complejas ni para raíces pares sin cambio de signo.

### Conteo y comprobación

Un ciclo externo que produce la aproximación aceptada cuenta una vez. Evaluar el punto medio y la corrección no cuenta como dos iteraciones.

Verificar el cambio de signo conservado, la raíz en un extremo y que el contador coincida con las filas del historial.

Archivo: R/raices/R01_ridders.R. Caso ejecutable: R01.

## R02 Método de Brent y Dekker [9]

Combina pasos de interpolación con la protección de la bisección. Intenta aprovechar la forma local de la función, pero rechaza un salto que no reduzca suficientemente el intervalo o salga de la zona permitida.

### Datos de entrada

Función real continua y un intervalo con cambio de signo. Usa la misma tolerancia del resto de métodos de raíces.

$$
s=\frac{a f(b)f(c)}{[f(a)-f(b)][f(a)-f(c)]}+\frac{b f(a)f(c)}{[f(b)-f(a)][f(b)-f(c)]}
$$

$$
\qquad+\frac{c f(a)f(b)}{[f(c)-f(a)][f(c)-f(b)]}
$$

$$
s=b-f(b)\frac{b-a}{f(b)-f(a)}\quad\mathrm{si\ no\ hay\ tres\ valores\ distintos}
$$

a y b mantienen el encierro; b se organiza como el punto con menor residuo. c y d guardan puntos anteriores para decidir si el paso de interpolación es aceptable.

### Procedimiento

1. Propón interpolación cuadrática inversa o secante.

2. Rechaza si s no está entre (3a+b)/4 y b.

3. También rechaza si el salto no reduce la mitad del paso de referencia o este ya es casi nulo.

4. Ante rechazo usa el punto medio; luego actualiza el intervalo por signos.

### Ejemplo explicado

Para x³−x−2 en [1,2], el primer intento secante es 4/3. Los siguientes pasos combinan información nueva y resguardos. La traza del caso R02 permite seguir las aproximaciones sin ejecutar una función externa.

### Relación con R

~~~r
brent_dekker(f, a, b, tol=1e-8, max_iter=1000)
~~~

biseccion_previa distingue qué reducción se exige; c0 y d guardan el historial. No se llama a uniroot(), que ocultaría el algoritmo.

### Condiciones y límites

Hay varias implementaciones de Brent con decisiones de resguardo distintas. Por eso el conteo corresponde a esta variante documentada.

### Conteo y comprobación

Una propuesta aceptada por ciclo externo cuenta una iteración, incluso si proviene de bisección.

Probar funciones crecientes y decrecientes, extremos que ya son raíz y casos con límite de iteraciones pequeño.

Archivo: R/raices/R02_brent_dekker.R. Caso ejecutable: R02.

## R03 Método de Müller [10]

Ajusta una parábola a tres puntos recientes y utiliza una de sus raíces como la siguiente aproximación. A diferencia de la secante, puede dar un paso complejo aunque los puntos de inicio sean reales.

### Datos de entrada

Una función y tres puntos distintos. La función debe aceptar números complejos si el proceso los genera.

$$
h_1=x_1-x_0,\quad h_2=x_2-x_1,\quad \delta_i=\frac{f(x_i)-f(x_{i-1})}{h_i}
$$

$$
A=\frac{\delta_2-\delta_1}{h_1+h_2},\quad B=\delta_2+h_2A,\quad C=f(x_2)
$$

$$
x_3=x_2-\frac{2C}{B\pm\sqrt{B^2-4AC}}
$$

La parábola se expresa alrededor de x₂. Entre los dos denominadores se elige el de mayor módulo para reducir la cancelación.

### Procedimiento

1. Calcula separaciones y pendientes de los dos tramos.

2. Obtén A, B y C del ajuste cuadrático.

3. Calcula ambas opciones del denominador y elige la de mayor módulo.

4. Genera x₃ y desplaza la terna de puntos.

### Ejemplo explicado

Para f(x)=x²+1 con puntos 0,1,2, el ajuste reproduce exactamente la función. El discriminante es negativo; el programa trabaja en complejos y obtiene una raíz ±i. El ejemplo entregado obtiene i.

### Relación con R

~~~r
muller(f, x0, x1, x2, tol=1e-8, max_iter=1000)
~~~

sqrt(as.complex(...)) permite el discriminante negativo. Para comprobar la raíz se utiliza abs(f(x)), que en complejos es el módulo.

### Condiciones y límites

Dos puntos coincidentes, o x₂=x₀, invalidan las diferencias divididas. Una raíz compleja válida no debe rechazarse por no ser real.

### Conteo y comprobación

Cada nueva aproximación posterior a la terna inicial cuenta una iteración.

Resolver un polinomio con raíz real y otro con raíces complejas; verificar el residuo de ambos.

Archivo: R/raices/R03_muller.R. Caso ejecutable: R03.

## R04 Método de Halley [11]

Corrige el paso de Newton usando también la curvatura de la función. Cerca de una raíz simple y bajo condiciones de suavidad, su convergencia local puede ser cúbica.

### Datos de entrada

f, su primera derivada df, su segunda derivada ddf y una aproximación inicial.

$$
x_{k+1}=x_k-\frac{2f(x_k)f'(x_k)}{2[f'(x_k)]^2-f(x_k)f''(x_k)}
$$

La primera derivada representa pendiente y la segunda curvatura. Ambas deben corresponder a la misma función; no se calculan mediante paquetes.

### Procedimiento

1. Comprueba si x₀ ya satisface la tolerancia.

2. Evalúa f, f′ y f″ en el iterado actual.

3. Revisa el denominador y aplica la corrección.

4. Guarda la nueva aproximación y comprueba el residuo.

### Ejemplo explicado

Para f=x³−x−2 y x₀=1.5, f=−0.125, f′=5.75 y f″=9. El denominador es 67.25 y el nuevo x es aproximadamente 1.52137546.

### Relación con R

~~~r
halley(f, df, ddf, x0, tol=1e-8, max_iter=1000)
~~~

Las tres funciones se declaran explícitamente con function(x). Esto facilita revisar derivadas y evita depender de derivación simbólica externa.

### Condiciones y límites

Convergencia cúbica es una propiedad local, no una garantía para cualquier semilla. Una derivada mal escrita puede producir un resultado aparentemente razonable pero incorrecto.

### Conteo y comprobación

Un paso completo de Halley cuenta una iteración. Las evaluaciones de derivadas no se reportan como otro criterio de desempeño.

Contrastar con una raíz conocida y verificar el caso donde el denominador se anula.

Archivo: R/raices/R04_halley.R. Caso ejecutable: R04.

## R05 Método de Ostrowski [12]

Realiza un paso de Newton y utiliza la evaluación en ese punto intermedio para corregirlo otra vez. Las dos etapas forman una actualización del algoritmo.

### Datos de entrada

f, primera derivada df y una semilla suficientemente cercana a una raíz simple.

$$
y_k=x_k-\frac{f(x_k)}{f'(x_k)}
$$

$$
x_{k+1}=y_k-\frac{f(y_k)}{f'(x_k)}\frac{f(x_k)}{f(x_k)-2f(y_k)}
$$

y_k es un punto intermedio. Se reutiliza f′(x_k); no se necesita evaluar la derivada en y_k.

### Procedimiento

1. Comprueba la raíz inicial y la derivada.

2. Calcula y mediante Newton.

3. Si y ya cumple, termina en ese mismo ciclo.

4. En otro caso revisa el nuevo denominador, corrige y registra x.

### Ejemplo explicado

Con f=x²−2 y x₀=1.5, Newton produce y≈1.41666667. La segunda corrección lleva a x≈1.4142156863, usando la derivada en 1.5. La raíz de referencia es √2≈1.4142135624.

### Relación con R

~~~r
ostrowski(f, df, x0, tol=1e-8, max_iter=1000)
~~~

El código contempla que el punto intermedio sea ya una raíz, antes de efectuar una división adicional.

### Condiciones y límites

La forma descrita tiene orden local cuatro para raíces simples y suficiente suavidad. No conserva un intervalo y puede fallar con denominadores nulos.

### Conteo y comprobación

El par de refinamientos es un ciclo externo. Si la maestra pide contar subetapas, esa sería otra convención que debe registrarse y aplicarse de forma consistente.

Usar una función lineal: el paso intermedio llega a la raíz y debe terminar con una iteración.

Archivo: R/raices/R05_ostrowski.R. Caso ejecutable: R05.

## R06 Método de Laguerre [10]

Busca raíces de un polinomio usando su valor, sus dos primeras derivadas y su grado. La aritmética compleja permite encontrar raíces que no están en la recta real.

### Datos de entrada

Coeficientes ordenados del mayor grado al término independiente, con coeficiente inicial no nulo. Esta rutina encuentra una raíz por llamada.

$$
G=\frac{P'(x)}{P(x)},\quad H=G^2-\frac{P''(x)}{P(x)}
$$

$$
x_{\mathrm{nuevo}}=x-\frac{n}{G\pm\sqrt{(n-1)(nH-G^2)}}
$$

n es el grado del polinomio. Se elige el signo que produzca el denominador de mayor módulo.

### Procedimiento

1. Evalúa P antes de dividir: si ya vale cero, termina.

2. Calcula P, P′ y P″ con Horner simultáneo.

3. Forma G, H y las dos opciones del denominador.

4. Actualiza la raíz y revisa el módulo del residuo.

### Ejemplo explicado

Para P=x²+1 se proporciona coef=c(1,0,1). Con x₀=1, G=1 y H=0; la raíz cuadrada es compleja y la actualización llega a una raíz ±i.

### Relación con R

~~~r
laguerre(coef, x0=0+0i, tol=1e-8, max_iter=1000)
~~~

polinomio_derivadas() evita formar funciones derivadas nuevas. No se usa polyroot(). No se realiza deflación para obtener todas las raíces.

### Condiciones y límites

No se aplica a funciones no polinomiales como sin(x)−x. Un resultado complejo puede ser correcto aunque los coeficientes sean reales.

### Conteo y comprobación

Una actualización de una raíz cuenta una iteración. Obtener todas las raíces por deflación requeriría un alcance y un conteo adicionales.

Verificar polinomios lineales, una raíz real y una compleja sin dividir entre P cuando ya es cero.

Archivo: R/raices/R06_laguerre.R. Caso ejecutable: R06.

## L01 Factorización LDLᵀ [13]

Separa una matriz simétrica en dos factores triangulares y uno diagonal. Después resuelve sistemas sencillos en lugar de calcular una inversa.

### Datos de entrada

Matriz A real, simétrica y definida positiva para esta variante sin pivoteo; vector b compatible.

$$
A=LDL^T,\quad L_{ii}=1
$$

$$
D_j=A_{jj}-\sum_{k<j}L_{jk}^2D_k
$$

$$
L_{ij}=\frac{A_{ij}-\sum_{k<j}L_{ik}L_{jk}D_k}{D_j}\quad(i>j)
$$

$$
Lz=b,\quad Dw=z,\quad L^Tx=w
$$

L es triangular inferior con unos en la diagonal. D almacena los pivotes. z y w son resultados intermedios.

### Procedimiento

1. Comprueba simetría y calcula los pivotes uno por uno.

2. Completa la columna de L utilizando pivotes anteriores.

3. Resuelve por sustitución hacia delante y divide por D.

4. Resuelve con Lᵀ hacia atrás para recuperar x.

### Ejemplo explicado

Para A=[[4,1],[1,3]], D=(4,11/4) y L=[[1,0],[1/4,1]]. Con b=(1,2), se obtiene z=(1,7/4), w=(1/4,7/11) y x=(1/11,7/11).

### Relación con R

~~~r
ldlt(A, b)
~~~

Los tres sistemas se resuelven con ciclos propios. La rutina devuelve L y D para reconstruir A y revisar el desarrollo.

### Condiciones y límites

La versión general para matrices indefinidas puede necesitar pivoteo y bloques 2×2. Esta implementación rechaza un pivote no positivo.

### Conteo y comprobación

Es una factorización directa. No se declara que tenga cero iteraciones ni que una columna sea una iteración comparativa.

Reconstruir L·D·Lᵀ y comprobar un sistema escalar y uno de varias incógnitas.

Archivo: R/sistemas/L01_ldlt.R. Caso ejecutable: L01.

## L02 Sobrerrelajación sucesiva SOR [14]

Actualiza las incógnitas en orden, como Gauss–Seidel, y mezcla la actualización con el valor anterior mediante omega. Elegir omega modifica el recorrido y el número de barridos.

### Datos de entrada

A, b, un vector inicial, omega y controles de terminación. La diagonal de A debe ser no nula.

$$
\widehat{x}_i=\frac{b_i-\sum_{j<i}a_{ij}x_j^{(k+1)}-\sum_{j>i}a_{ij}x_j^{(k)}}{a_{ii}}
$$

$$
x_i^{(k+1)}=(1-\omega)x_i^{(k)}+\omega\widehat{x}_i
$$

Dentro de un barrido se usan las incógnitas recién calculadas a la izquierda y las del barrido anterior a la derecha.

### Procedimiento

1. Guarda una copia del vector anterior.

2. Recorre todas las filas y calcula cada incógnita.

3. Aplica la mezcla con omega.

4. Después del barrido completo comprueba el residuo del sistema.

### Ejemplo explicado

Con A=[[4,1],[1,3]], b=(1,2), x⁰=(0,0), omega=1.1, el primer valor es x₁=0.275. El segundo es x₂=1.1(2−0.275)/3=0.6325.

### Relación con R

~~~r
sor(A, b, x0, omega, tol=1e-8, max_iter=10000)
~~~

anterior guarda el vector del comienzo del barrido. sor(..., omega=1) reproduce Gauss–Seidel.

### Condiciones y límites

Para matrices simétricas definidas positivas, 0<omega<2 garantiza convergencia. Ese intervalo por sí solo no garantiza convergencia para cualquier A. omega>1 no siempre reduce iteraciones.

### Conteo y comprobación

Se cuenta un barrido completo del vector, no una iteración por incógnita. Se comprueba también el vector inicial antes del primer barrido.

Comparar omega=1 con Gauss–Seidel y comprobar convergencia, inicio exacto y límite de barridos.

Archivo: R/sistemas/L02_sor.R. Caso ejecutable: L02.

## L03 Iteración de Richardson [15]

El residuo indica cuánto falta para satisfacer Ax=b. Richardson avanza en esa dirección multiplicada por un parámetro. Un paso demasiado grande puede hacer que el proceso diverja.

### Datos de entrada

Matriz A, vector b, aproximación inicial y un omega elegido para el problema.

$$
r_k=b-Ax_k,\quad x_{k+1}=x_k+\omega r_k
$$

$$
e_{k+1}=(I-\omega A)e_k
$$

r_k es el residuo; e_k representa el error respecto a la solución exacta. No hace falta conocer e para ejecutar el método.

### Procedimiento

1. Calcula el residuo del vector inicial.

2. Multiplica ese residuo por omega.

3. Suma la corrección al vector completo.

4. Comprueba el nuevo residuo y repite.

### Ejemplo explicado

En el sistema A=[[4,1],[1,3]], b=(1,2), x⁰=(0,0), omega=0.2, la primera actualización es (0.2,0.4). Su residuo es (−0.2,0.6), de modo que la segunda es (0.16,0.52).

### Relación con R

~~~r
richardson(A, b, x0, omega, tol=1e-8, max_iter=10000)
~~~

El producto A %*% x es una operación matricial básica; no resuelve el sistema. omega es obligatorio para evitar una elección silenciosa.

### Condiciones y límites

Para A simétrica definida positiva basta 0<omega<2/λ_max. El código limita barridos pero no certifica esa condición para toda matriz.

### Conteo y comprobación

Una actualización del vector completo es una iteración externa. Su interpretación comparativa queda escrita junto al caso.

Comprobar una solución conocida con un omega estable y que un límite pequeño se reporte como falta de convergencia.

Archivo: R/sistemas/L03_richardson.R. Caso ejecutable: L03.

## L04 Proyección por filas de Kaczmarz [16]

Interpreta cada ecuación como una recta o hiperplano. Proyecta la aproximación sobre una ecuación y luego sobre la siguiente. Cumplir una fila puede alterar el cumplimiento de las anteriores.

### Datos de entrada

Matriz con filas no nulas, vector b y x inicial. La variante cíclica se usa aquí para sistemas compatibles.

$$
x_{\mathrm{nuevo}}=x+\frac{b_i-a_i x}{\|a_i\|_2^2}a_i^T
$$

a_i es una fila de A. El denominador es la suma de cuadrados de esa fila. En un barrido se visitan todas las filas en el mismo orden.

### Procedimiento

1. Calcula la norma cuadrada de cada fila.

2. Proyecta sobre la primera ecuación.

3. Continúa con las restantes usando el vector actualizado.

4. Al terminar el barrido comprueba el residuo de todo el sistema.

### Ejemplo explicado

Para la fila 4x₁+x₂=1, empezando en (0,0), la corrección es (1/17)(4,1). El nuevo punto (4/17,1/17) cumple esa ecuación exactamente.

### Relación con R

~~~r
kaczmarz(A, b, x0, tol=1e-8, max_iter=10000)
~~~

Se guardan barridos y proyecciones por separado en el historial. La rutina también permite matrices rectangulares compatibles.

### Condiciones y límites

No se debe confundir la variante cíclica con la aleatoria del título de la referencia: se utiliza la proyección clásica descrita en su introducción. Para sistemas incompatibles se necesita otro tratamiento.

### Conteo y comprobación

Said debe confirmar si quiere contar una proyección o un barrido. iteraciones se mantiene sin valor para evitar mezclar unidades.

Construir un sistema rectangular compatible a partir de una solución conocida y recuperar ese vector.

Archivo: R/sistemas/L04_kaczmarz.R. Caso ejecutable: L04.

## L05 Eliminación por bloques con complemento de Schur [17]

Divide las incógnitas en dos grupos. Elimina el primero para resolver un sistema más pequeño en el segundo y después recupera el grupo eliminado.

### Datos de entrada

A y b; corte indica cuántas incógnitas pertenecen al primer bloque. El bloque usado y su complemento deben ser invertibles.

$$
Bx+Cy=f,\quad Dx+Ey=g
$$

$$
BY=C,\quad Bz=f,\quad S=E-DY
$$

$$
Sy=g-Dz,\quad Bx=f-Cy
$$

La notación evita calcular B⁻¹: Y y z se obtienen resolviendo sistemas. S es el complemento de Schur del bloque B.

### Procedimiento

1. Separa A y b de acuerdo con corte.

2. Resuelve los sistemas del bloque B para Y y z.

3. Forma S y resuelve el sistema de y.

4. Sustituye y en el bloque original para obtener x.

### Ejemplo explicado

En [[4,1],[1,3]] con corte=1, B=4 y S=3−1/4=11/4. El lado derecho reducido es 2−1/4=7/4. Por eso y=7/11 y x=(1−y)/4=1/11.

### Relación con R

~~~r
schur(A, b, corte)
~~~

Se usa drop=FALSE para conservar matrices de una fila o columna. Cada sistema auxiliar utiliza gauss_propio(), con pivoteo parcial.

### Condiciones y límites

Que A sea invertible no garantiza que el bloque B elegido sea invertible. Un corte inadecuado puede impedir esta forma de eliminación.

### Conteo y comprobación

La eliminación por bloques es directa. El conteo de los sistemas auxiliares no se suma como iteraciones del método sin una definición docente.

Recuperar una solución conocida para varios cortes y comprobar el comportamiento cuando un bloque es singular.

Archivo: R/sistemas/L05_schur.R. Caso ejecutable: L05.

## L06 Reducción cíclica [18]

En un sistema tridiagonal, cada incógnita solo se relaciona con sus vecinas. Se eliminan incógnitas alternadas para producir otro sistema tridiagonal más pequeño; al final se recuperan las eliminadas.

### Datos de entrada

Cuatro vectores del mismo tamaño: diagonal inferior, principal, superior y b. inferior[1]=0 y superior[n]=0.

$$
a_ix_{i-1}+d_ix_i+c_ix_{i+1}=b_i
$$

$$
\alpha=-a_i/d_{i-1},\quad \beta=-c_i/d_{i+1}
$$

$$
\widetilde d_i=d_i+\alpha c_{i-1}+\beta a_{i+1},\quad \widetilde b_i=b_i+\alpha b_{i-1}+\beta b_{i+1}
$$

$$
\widetilde a_i=\alpha a_{i-1},\quad \widetilde c_i=\beta c_{i+1}
$$

Los términos de un vecino se omiten si no existe. Los nuevos coeficientes conectan vecinos a dos posiciones de distancia.

### Procedimiento

1. Conserva posiciones impares y elimina las pares.

2. Construye el sistema reducido con las ecuaciones de los vecinos.

3. Repite hasta una sola incógnita.

4. Reconstruye cada incógnita par usando sus dos vecinas ya conocidas.

### Ejemplo explicado

Para 2x₁−x₂=1, −x₁+2x₂−x₃=0 y −x₂+2x₃=1, eliminar x₂ deja 1.5x₁−0.5x₃=1 y −0.5x₁+1.5x₃=1. El resultado es (1,1,1).

### Relación con R

~~~r
reduccion_ciclica(inferior, diagonal, superior, b)
~~~

La función interna reducir() realiza la recursión. Los vectores de cada nivel se mantienen separados para recuperar después las posiciones eliminadas.

### Condiciones y límites

Necesita pivotes no nulos. Esta es una implementación serial académica, no una implementación paralela para GPU.

### Conteo y comprobación

Se registran niveles de reducción como información técnica, pero la equivalencia con iteraciones comparativas está pendiente.

Resolver tamaños pares, impares y el caso de una sola ecuación; no asumir que n debe ser potencia de dos.

Archivo: R/sistemas/L06_reduccion_ciclica.R. Caso ejecutable: L06.

## Q01 Regla de Boole [19]

Estima el área de un panel usando cinco valores equiespaciados. La versión compuesta repite paneles de cuatro subintervalos.

### Datos de entrada

Función, límites a<b y número n de subintervalos múltiplo de cuatro.

$$
h=\frac{b-a}{4},\quad Q=\frac{2h}{45}(7f_0+32f_1+12f_2+32f_3+7f_4)
$$

La fórmula muestra un panel. En la versión compuesta, h=(b−a)/n y cada grupo de cuatro subintervalos aporta un panel.

### Procedimiento

1. Verifica n múltiplo de cuatro.

2. Calcula h y divide el intervalo en paneles.

3. Evalúa cinco puntos por panel y aplica los pesos.

4. Suma las contribuciones de todos los paneles.

### Ejemplo explicado

Para ∫₀¹x⁴ dx con un panel, h=1/4 y las muestras son 0,1/256,1/16,81/256,1. La suma ponderada produce 1/5, que es el valor exacto.

### Relación con R

~~~r
boole(f, a, b, n=4)
~~~

Los pesos c(7,32,12,32,7) se escriben explícitamente. n=4 significa cinco nodos, no cuatro.

### Condiciones y límites

Boole es exacta para polinomios de grado hasta cinco. Eso no implica exactitud para cualquier función. No aceptar n=7 como si fuera un panel válido.

### Conteo y comprobación

Un panel, un nodo y una iteración de refinamiento son conceptos distintos. El criterio de Said sigue pendiente.

Integrar x⁵ exactamente salvo redondeo y rechazar un n incompatible.

Archivo: R/integracion/Q01_boole.R. Caso ejecutable: Q01.

## Q02 Gauss Chebyshev de primera especie [20], [21]

Selecciona nodos especiales para una integral que incluye el peso 1/√(1−x²). Todos los pesos de cuadratura son iguales.

### Datos de entrada

g es la parte de la función que multiplica el peso. El intervalo de esta rutina es [−1,1].

$$
\int_{-1}^{1}\frac{g(x)}{\sqrt{1-x^2}}\,dx\approx\frac{\pi}{n}\sum_{k=1}^{n}g\left(\cos\frac{(2k-1)\pi}{2n}\right)
$$

n es el número de nodos. La función g no debe volver a incluir el peso que ya aparece en la fórmula.

### Procedimiento

1. Calcula los ángulos de los n nodos.

2. Obtén cada nodo con coseno.

3. Evalúa g en cada uno.

4. Suma y multiplica por π/n.

### Ejemplo explicado

Para g=x² y n=2, los nodos son ±√2/2. Ambos valores g son 1/2, por lo que la integral ponderada vale π/2.

### Relación con R

~~~r
gauss_chebyshev(g, n=4)
~~~

No se usan tablas externas ni un generador de cuadratura de un paquete. El cambio a una integral ordinaria requiere definir una g transformada y documentarla.

### Condiciones y límites

No calcula directamente ∫g(x)dx sin peso. Si se compara con una regla ordinaria, ambas deben representar exactamente la misma integral transformada y el mismo dominio.

### Conteo y comprobación

nodos no se reporta automáticamente como iteraciones. Pendiente de definición docente.

Integrar la constante 1 para obtener π y x² para obtener π/2.

Archivo: R/integracion/Q02_gauss_chebyshev.R. Caso ejecutable: Q02.

## Q03 Gauss Hermite [20], [22]

Está diseñada para integrales sobre toda la recta con peso exp(−x²). Sus nodos son ceros de los polinomios de Hermite en la convención de físicos.

### Datos de entrada

g representa el factor adicional al peso gaussiano. Esta implementación admite entre 1 y 20 nodos.

$$
H_0=1,\quad H_1=2x,\quad H_n=2xH_{n-1}-2(n-1)H_{n-2}
$$

$$
\int_{-\infty}^{\infty}e^{-x^2}g(x)\,dx\approx\sum_iw_i g(x_i)
$$

$$
w_i=\frac{2^{n-1}n!\sqrt{\pi}}{n^2[H_{n-1}(x_i)]^2}
$$

Los x_i son raíces de H_n. Las raíces se intercalan entre las del grado anterior, lo que permite encerrarlas y calcularlas con bisección propia.

### Procedimiento

1. Genera los polinomios mediante su recurrencia.

2. Encierra las raíces usando las del grado anterior y una cota exterior.

3. Calcula nodos con el auxiliar de bisección y después sus pesos.

4. Evalúa g y acumula la suma ponderada.

### Ejemplo explicado

Para n=2, los nodos son ±1/√2 y ambos pesos √π/2. Con g=x², la suma es √π/2≈0.886226925.

### Relación con R

~~~r
gauss_hermite(g, n=4)
~~~

La generación de nodos se desarrolla dentro del proyecto; no se usa eigen(), polyroot() ni un paquete de cuadratura. El límite n≤20 corresponde al alcance validado de este código.

### Condiciones y límites

No confundir exp(−x²) con exp(−x²/2), que usa otra convención y otro escalado. Tampoco es una integral ordinaria en un intervalo finito.

### Conteo y comprobación

El cálculo auxiliar de las raíces de Hermite no se mezcla con iteraciones de desempeño de la integración.

Comprobar momentos pares conocidos y que los pesos sumen √π.

Archivo: R/integracion/Q03_gauss_hermite.R. Caso ejecutable: Q03.

## Q04 Gauss Lobatto Legendre [20]

Elige nodos de cuadratura que incluyen ambos extremos. Los interiores se obtienen de la derivada de un polinomio de Legendre.

### Datos de entrada

Una función en [a,b] y n nodos totales, incluidos los extremos. Se admiten entre 2 y 20.

$$
x_1=-1,\quad x_n=1,\quad P'_{n-1}(x_i)=0\quad(1<i<n)
$$

$$
w_i=\frac{2}{n(n-1)[P_{n-1}(x_i)]^2}
$$

$$
t_i=\frac{a+b}{2}+\frac{b-a}{2}x_i,\quad Q=\frac{b-a}{2}\sum_iw_i f(t_i)
$$

P es un polinomio de Legendre. La transformación de t y el factor (b−a)/2 son necesarios fuera de [−1,1].

### Procedimiento

1. Agrega los extremos −1 y 1.

2. Calcula los nodos interiores a partir de P′.

3. Calcula los pesos en todos los nodos.

4. Transforma al intervalo pedido y suma las evaluaciones.

### Ejemplo explicado

Con n=3, los nodos son −1,0,1 y los pesos 1/3,4/3,1/3. Para x² en [−1,1], el resultado es 2/3.

### Relación con R

~~~r
gauss_lobatto(f, a, b, n=4)
~~~

Los polinomios de Legendre se evalúan por recurrencia. Sus ceros ayudan a encerrar los de la derivada, calculados con bisección propia.

### Condiciones y límites

n cuenta nodos, no subintervalos. La exactitud polinomial es 2n−3. Incluir los extremos impide evaluar integrandos que sean infinitos allí sin un tratamiento adicional.

### Conteo y comprobación

El número de nodos y las bisecciones auxiliares quedan separados del conteo comparativo pendiente.

Reproducir polinomios hasta grado 2n−3 y verificar el cambio de intervalo.

Archivo: R/integracion/Q04_gauss_lobatto.R. Caso ejecutable: Q04.

## Q05 Clenshaw Curtis [23]

Interpola la función en nodos de Chebyshev que se concentran cerca de los extremos e integra ese interpolante. Los pesos pueden calcularse directamente con sumas de cosenos.

### Datos de entrada

Función en un intervalo finito y al menos tres nodos, incluidos los extremos.

$$
x_j=\cos(j\pi/N),\quad j=0,\ldots,N,\quad N=n-1
$$

$$
w_j=\frac{2\delta_j}{N}\left[1-\sum_{k=1}^{\lfloor(N-1)/2\rfloor}\frac{2\cos(2kj\pi/N)}{4k^2-1}-E_j\right]
$$

δ_j vale 1/2 en los extremos y 1 dentro. E_j=cos(jπ)/(N²−1) si N es par, y cero si es impar. Después se transforma de [−1,1] a [a,b].

### Procedimiento

1. Genera los nodos coseno.

2. Calcula los pesos con la suma y el término de paridad.

3. Transforma nodos y pesos al intervalo pedido.

4. Evalúa f y suma sus contribuciones.

### Ejemplo explicado

Con tres nodos se obtienen −1,0,1 y pesos 1/3,4/3,1/3. Con cinco nodos, la integral de x⁴ en [−1,1] resulta 2/5.

### Relación con R

~~~r
clenshaw_curtis(f, a, b, n=5)
~~~

El código distingue N par e impar. No usa una transformada rápida ni dependencias externas para calcular los pesos.

### Condiciones y límites

No confundir la ubicación de los nodos con la de Gauss–Chebyshev: aquí se incluyen los extremos y se integra sin el peso singular.

### Conteo y comprobación

Los ciclos de cálculo de pesos y los nodos no se convierten en iteraciones comparativas sin confirmación.

Los pesos deben sumar la longitud del intervalo; comprobar polinomios interpolables.

Archivo: R/integracion/Q05_clenshaw_curtis.R. Caso ejecutable: Q05.

## Q06 Integración Monte Carlo simple [24]

Estima el promedio de la función usando puntos uniformes al azar y lo multiplica por la longitud del intervalo. Repetir con otra semilla puede producir un resultado distinto.

### Datos de entrada

Función de varianza finita sobre [a,b], número de muestras n≥2 y semilla.

$$
X_i\sim U(a,b),\quad Q_N=\frac{b-a}{N}\sum_{i=1}^{N}f(X_i)
$$

$$
\widehat{\mathrm{SE}}=(b-a)\frac{s_f}{\sqrt{N}}
$$

s_f es la desviación estándar de los valores muestreados. El error estándar estima incertidumbre estadística; no es una cota garantizada del error.

### Procedimiento

1. Fija la semilla y genera un punto uniforme por muestra.

2. Evalúa f y actualiza la suma y la media.

3. Actualiza una suma de desviaciones cuadradas sin guardar todas las muestras.

4. Devuelve la estimación y el error estándar.

### Ejemplo explicado

Si f=3 en [2,5], cualquier muestra produce 3, el promedio es 3 y el resultado es 9. Para x² en [0,1], la referencia exacta es 1/3 y la estimación varía por muestreo.

### Relación con R

~~~r
monte_carlo(f, a, b, n=10000, semilla=2026)
~~~

runif() y set.seed() forman parte de una instalación estándar de R. No se instala ni carga un paquete externo. La función restaura el estado aleatorio anterior.

### Condiciones y límites

Con varianza finita, el error típico decrece como 1/√N; multiplicar N por cuatro reduce aproximadamente a la mitad ese error, no garantiza un valor exacto.

### Conteo y comprobación

Said debe indicar si una muestra o un lote constituye una iteración. No se equipara automáticamente N con iteraciones de otros métodos.

Función constante exacta, repetición con la misma semilla y preservación del estado aleatorio.

Archivo: R/integracion/Q06_monte_carlo.R. Caso ejecutable: Q06.

## E01 Adams Bashforth de dos pasos [25]

Para avanzar en una EDO de primer orden utiliza la pendiente actual y la del punto anterior. Es explícito: el nuevo valor se obtiene sin resolver una ecuación adicional.

### Datos de entrada

y′=f(t,y), intervalo, valor inicial y n pasos uniformes, n≥2.

$$
y_{k+1}=y_k+\frac{h}{2}(3f_k-f_{k-1}),\quad f_k=f(t_k,y_k)
$$

Dos pasos significa que la fórmula necesita dos niveles previos. El valor y₁ se obtiene con un paso de RK4; después comienza AB2.

### Procedimiento

1. Calcula h y la malla.

2. Obtén y₁ con RK4 propio.

3. Combina la pendiente actual y la anterior.

4. Desplaza el historial y continúa hasta el extremo.

### Ejemplo explicado

Para y′=y, y(0)=1, h=0.1, RK4 produce y₁≈1.10517083. Entonces y₂≈1.10517083+0.05(3·1.10517083−1)=1.22094646.

### Relación con R

~~~r
adams_bashforth2(f, a, b, y0, n=20)
~~~

El historial guarda t e y. El arranque no se ejecuta con valores exactos ocultos: lo calcula rk4_paso().

### Condiciones y límites

El orden global es dos bajo condiciones adecuadas. Un método explícito puede requerir pasos pequeños por estabilidad, aunque la fórmula sea sencilla.

### Conteo y comprobación

Se guardan pasos de malla y un paso de arranque. Su uso como iteraciones de desempeño está pendiente.

Resolver y′=y y verificar que al reducir h a la mitad el error se reduzca aproximadamente por un factor cuatro.

Archivo: R/edo/E01_adams_bashforth2.R. Caso ejecutable: E01.

## E02 Adams Moulton de dos pasos y orden tres [25]

Aprovecha una pendiente futura junto con dos conocidas. Como la pendiente futura depende del valor todavía desconocido, hay que resolver una ecuación en cada avance.

### Datos de entrada

EDO de primer orden, dato inicial y malla uniforme. dfdy es opcional; si falta, se usa una diferencia central propia.

$$
y_{k+1}=y_k+\frac{h}{12}(5f_{k+1}+8f_k-f_{k-1})
$$

$$
F(z)=z-y_k-\frac{h}{12}[5f(t_{k+1},z)+8f_k-f_{k-1}]=0
$$

AM3 indica orden tres, aunque el método utiliza dos pasos. F es la ecuación que resuelve Newton interno, no una nueva EDO.

### Procedimiento

1. Obtén y₁ con RK4.

2. Forma F para el siguiente punto.

3. Usa una predicción de Euler como inicio de Newton.

4. Acepta la solución interna solo si cumple su tolerancia y guarda el avance.

### Ejemplo explicado

Para y′=y y h=0.1, la ecuación puede despejarse: y_(k+1)=[(1+8h/12)y_k−(h/12)y_(k−1)]/(1−5h/12). Esta forma permite comprobar el resultado del Newton interno.

### Relación con R

~~~r
adams_moulton3(f, a, b, y0, n=20, dfdy=NULL)
~~~

tol_interna y max_interna controlan únicamente la solución de F. El historial guarda el número de actualizaciones internas por paso.

### Condiciones y límites

Una sola corrección predictor–corrector no equivale a resolver esta ecuación implícita hasta tolerancia. La variante implementada sí intenta resolverla.

### Conteo y comprobación

Pasos de malla y Newton interno quedan separados; Said debe definir cómo quiere contabilizarlos.

Comprobar una EDO con solución exacta y concordancia entre derivada analítica y diferencia central.

Archivo: R/edo/E02_adams_moulton3.R. Caso ejecutable: E02.

## E03 Diferenciación hacia atrás BDF2 [25]

Aproxima la derivada futura utilizando tres valores sucesivos de la solución. Es un método implícito de dos pasos y orden dos.

### Datos de entrada

Problema y′=f(t,y), valor inicial y paso constante. El segundo valor se genera con RK4.

$$
3y_{k+1}-4y_k+y_{k-1}=2hf(t_{k+1},y_{k+1})
$$

$$
F(z)=3z-4y_k+y_{k-1}-2hf(t_{k+1},z)=0
$$

El nuevo valor aparece tanto fuera como dentro de f. Por eso no basta sustituir directamente y_k donde debe estar y_(k+1).

### Procedimiento

1. Construye la malla y el arranque.

2. Forma la ecuación implícita en z.

3. Resuélvela con Newton propio y controles internos.

4. Guarda el resultado junto con el historial de la solución.

### Ejemplo explicado

Si y′=y, queda (3−2h)y_(k+1)=4y_k−y_(k−1). Este despeje permite comparar la solución de Newton interno con una cuenta manual.

### Relación con R

~~~r
bdf2(f, a, b, y0, n=20, dfdy=NULL)
~~~

Si se entrega dfdy, la derivada interna es 3−2h·dfdy. De lo contrario se aproxima F′ por diferencia central.

### Condiciones y límites

El paso es constante en esta implementación. Cambiar arbitrariamente h y mantener los mismos coeficientes deja de ser esta fórmula BDF2.

### Conteo y comprobación

El número de pasos de malla no se suma automáticamente a las iteraciones internas. Criterio pendiente.

Para y′=y, al dividir h entre dos debe observarse la reducción de error propia de orden dos.

Archivo: R/edo/E03_bdf2.R. Caso ejecutable: E03.

## E04 Predictor corrector de Hamming modificado [26]

Usa cuatro niveles de la solución para predecir, modificar y corregir el valor futuro. Guarda la diferencia entre predicción y corrección para ajustar el siguiente avance.

### Datos de entrada

EDO de primer orden, malla uniforme con n≥4 y cuatro valores de arranque; tres se calculan con RK4.

$$
p_{k+1}=y_{k-3}+\frac{4h}{3}(2f_k-f_{k-1}+2f_{k-2})
$$

$$
m_{k+1}=p_{k+1}+\frac{112}{121}(c_k-p_k)
$$

$$
c_{k+1}=\frac{9y_k-y_{k-2}}{8}+\frac{3h}{8}[2f_k-f_{k-1}+f(t_{k+1},m_{k+1})]
$$

$$
y_{k+1}=c_{k+1}+\frac{9}{121}(p_{k+1}-c_{k+1})
$$

p es predictor sin modificar; m es predictor modificado; c es corrector. Es necesario conservar p y c originales para el siguiente ciclo.

### Procedimiento

1. Calcula y₁,y₂,y₃ con RK4 y comienza con diferencia histórica cero.

2. Calcula p y aplica la modificación con el historial.

3. Evalúa la pendiente futura en m y calcula c.

4. Obtén y, conserva p y c y actualiza las pendientes conocidas.

### Ejemplo explicado

Para y′=y, y(0)=1 y h=0.1, los primeros cuatro datos se obtienen con RK4. El primer predictor usa y₀ y las pendientes de los niveles 1,2,3; su modificación inicial es cero porque aún no existe una diferencia predictor–corrector previa.

### Relación con R

~~~r
hamming(f, a, b, y0, n=20)
~~~

Se guardan columnas predictor y corrector. No se sustituye el predictor original por el valor final al actualizar la diferencia histórica.

### Condiciones y límites

La página de referencia contiene una errata tipográfica en una fórmula de texto; se sigue el bloque Program y se documentan las cuatro etapas.

### Conteo y comprobación

Las cuatro etapas no se convierten sin más en cuatro iteraciones. Se guarda el avance de malla y queda pendiente el criterio comparativo.

Comparar con exp(t) y comprobar reducción del error al refinar la malla.

Archivo: R/edo/E04_hamming.R. Caso ejecutable: E04.

## E05 Störmer Verlet con velocidades [27]

Actualiza posición y velocidad utilizando la aceleración antes y después del avance. Es apropiado para ecuaciones de movimiento cuya aceleración depende del tiempo y la posición.

### Datos de entrada

Aceleración a(t,y), posición y velocidad iniciales, intervalo y paso uniforme.

$$
y_{k+1}=y_k+h v_k+\frac{h^2}{2}a(t_k,y_k)
$$

$$
v_{k+1}=v_k+\frac{h}{2}[a(t_k,y_k)+a(t_{k+1},y_{k+1})]
$$

La aceleración futura se evalúa en la nueva posición. Ambas condiciones iniciales son necesarias para un problema de segundo orden.

### Procedimiento

1. Calcula la aceleración actual.

2. Avanza la posición.

3. Calcula la aceleración en la nueva posición y el tiempo futuro.

4. Promedia ambas aceleraciones para actualizar la velocidad.

### Ejemplo explicado

Para y″=−y, y₀=1, v₀=0 y h=0.1, la posición siguiente es 0.995. La nueva aceleración es −0.995 y v₁=−0.09975.

### Relación con R

~~~r
verlet(aceleracion, a, b, y0, v0, n=20)
~~~

El historial contiene t, y y v. El resultado principal es la posición final; la velocidad sigue disponible en la tabla.

### Condiciones y límites

Esta fórmula no cubre directamente una aceleración dependiente de la velocidad, como cierto rozamiento. No requiere otro método para iniciar el primer paso.

### Conteo y comprobación

El avance de posición y velocidad pertenece a un mismo paso físico. Su equivalencia con iteraciones debe confirmarse.

Usar el oscilador armónico: posición cos(t) y velocidad −sin(t).

Archivo: R/edo/E05_verlet.R. Caso ejecutable: E05.

## E06 Método de Numerov [28]

Aprovecha la estructura de una EDO lineal de segundo orden sin término de primera derivada para relacionar tres nodos. En la forma entregada se resuelve un problema de valor inicial.

### Datos de entrada

La ecuación debe escribirse y″=g(t)y+s(t). Se proporcionan posición y velocidad iniciales; el segundo valor de posición se genera con un paso RK4 del sistema equivalente.

$$
\left(1-\frac{h^2g_{k+1}}{12}\right)y_{k+1}=2\left(1+\frac{5h^2g_k}{12}\right)y_k
$$

$$
\qquad-\left(1-\frac{h^2g_{k-1}}{12}\right)y_{k-1}+\frac{h^2}{12}(s_{k+1}+10s_k+s_{k-1})
$$

g y s se evalúan en los nodos de la malla. Si un libro escribe y″=−q(t)y+s(t), entonces g=−q.

### Procedimiento

1. Reescribe correctamente la ecuación y separa g de s.

2. Obtén y₁ con RK4 usando y′=v y v′=g(t)y+s(t).

3. Calcula el lado derecho de la recurrencia.

4. Comprueba el denominador futuro, despeja y y continúa.

### Ejemplo explicado

Para y″=−y, y(0)=0, v(0)=1, g=−1 y s=0. La fórmula queda (1+h²/12)y_(k+1)=2(1−5h²/12)y_k−(1+h²/12)y_(k−1). La solución de referencia es sin(t).

### Relación con R

~~~r
numerov(g, s, a, b, y0, v0, n=20)
~~~

La rutina no utiliza valores exactos de sin(h) para iniciar; calcula el arranque. El código no resuelve automáticamente problemas de frontera.

### Condiciones y límites

No confundir el defecto local de la recurrencia con el error global acumulado. Una ecuación con y′ o no lineal requiere otro tratamiento.

### Conteo y comprobación

Se distinguen el paso de arranque y los avances de la recurrencia. Conteo comparativo pendiente.

Oscilador con solución sin(t) y ecuación y″=2, cuya solución con datos cero es t².

Archivo: R/edo/E06_numerov.R. Caso ejecutable: E06.

<!-- PAGE -->

## Resultados reproducibles del ejemplo inicial

Con tol=1e−8, para x³−x−2, intervalo [1,2], semilla 1.5 y terna (1,1.5,2) según el método:

| Método | Iteraciones | Terminó |
|---|---|---|
| Biseccion | 28 | TRUE |
| Newton | 3 | TRUE |
| Ridders | 3 | TRUE |
| Brent_Dekker | 6 | TRUE |
| Muller | 3 | TRUE |
| Halley | 2 | TRUE |
| Ostrowski | 2 | TRUE |
| Laguerre | 2 | TRUE |

Para A=[[4,1],[1,3]], b=(1,2) y x₀=(0,0), con parámetros fijos del ejemplo:

| Método | Iteraciones |
|---|---|
| Gauss_Seidel | 8 |
| SOR_omega_1_1 | 9 |
| Richardson_omega_0_2 | 28 |

Estas tablas corresponden a esta implementación y a estos datos, no a una clasificación universal. Se reproducen con:

~~~sh
Rscript ejecutar.R --comparar
~~~

## Ruta de estudio del equipo

Empieza por el problema y sus datos. Haz el ejemplo a mano, encuentra el paso en el código, ejecuta otro dato conocido y una entrada incompatible. Cada responsable tiene diez métodos; el revisor cruza los resultados. El código inicial fue preparado con apoyo de IA: la comprensión y revisión del equipo siguen siendo necesarias.
