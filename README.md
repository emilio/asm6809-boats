Hundir la flota
===============

Juego de los barquitos en ensamblador, para computadores II

## Autores

* **Emilio Cobos Álvarez** <emiliocobos@usal.es> (70912324-N)
* **Eduardo Alonso Robles** <edualorobles@usal.es> (70901036-V)

## Estructura

El juego está dividido en seis archivos imprescindibles:

* `IO.asm`: Subrutinas de entrada y salida de datos.
* `presentation.asm`: Subrutina y variables para presentar el programa, nada del otro mundo.
* `rand.asm`: Implementación cutre de un PRNG.
* `game_io.asm`: Archivo con las subrutinas principales para el manejo del juego. Es el más denso y digno de mención.
* `game_loop.asm`: Usa las subrutinas anteriores adecuadamente para aplicar la lógica del juego.
* `main.asm`: Inicialización del programa, es un archivo relativamente simple.

## Datos interesantes

### Script `dobuild` y edición de `build/ensambla`

El script `dobuild` sólo llama a `ensambla` con las opciones correctas.

El script `ensambla` ha sido editado para que guarde los archivos binarios y de enlazado en el directorio `bin`.

### Estructura del mapa

El juego está implementado de tal manera que el mapa son dos campos de 64 bits:

```
FIELD:
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0

USER_FIELD:
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
			.byte 0
```

#### ¿El motivo?

En un principio creimos que implementarlo así sería beneficioso para el uso de memoria (reduce el mapa a 16 bytes en lugar de los 64 que requeriría la implementación más _predecible_).

Visto con perspectiva esto aumenta la dificultad de ciertos aspectos del juego (aumentando ciclos de reloj a la hora de disparar, por ejemplo).

El dilema es: **¿Es esa optimización en el uso de la memoria suficientemente grande para justificar el cambio?**

Visto con perspectiva, la respuesta es **NO, salvo que estuvieramos super apurados con la memoria** (con un par de cadenas ascii ya te has comido los 48 bytes que te ahorras).

No obstante más como reto que como otra cosa seguimos con el desarrollo de esta manera.

### Tiempo de desarrollo

No llevamos una cuenta exacta de las horas que le hemos dedicado a este jueguecito (la mayoría, sobre todo al principio, a juzgar por el historial de commits que puedes con `git log master`, han sido horas de insomnio de madrugada).

### Subrutinas destacadas

Ésta es (para nosotros) la lista de subrutinas de más difícil entendimiento:

* `int_to_mask`: Genera una máscara con un sólo bit activo y la almacena en `TEMP_BYTE`. El bit activo depende del valor del registro `B`, siendo `B` un número del 0 al 7, indicando la cordenada `y` del mapa. Para el caso, genera (2^(7-b))
* `game_print_map`: Imprime el mapa.
* `game_generate_map`: Genera el mapa aleatoriamente.
* `game_ask`: Introducción de casilla y validación.


## Más curiosidades/dudas?

Hemos procurado ser exhaustivos en la documentación del código, así que sólo tienes que echar un vistazo.
