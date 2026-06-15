# Evidencia 2 - Comunicación UART en Verilog

Este repositorio contiene la implementación y simulación de un sistema de comunicación **UART** desarrollado en **Verilog HDL**. El proyecto incluye dos módulos principales: un transmisor UART (`uart_tx`) y un receptor UART (`uart_rx`), junto con sus respectivos bancos de prueba para verificar su funcionamiento mediante simulación.

## Autores

| Nombre                        | Matrícula | Carrera                      |
| ----------------------------- | --------- | ---------------------------- |
| Agatha Adaluz Liewald Suárez  | A00841137 | Ingeniería Física Industrial |
| José Abdiel López Valdez      | A01255464 | Ingeniería Mecatrónica       |
| Axel Duarte Salgado           | A01646418 | Ingeniería Mecatrónica       |
| Mateo Josué Vasconéz González | A00839664 | Ingeniería en Nanotecnología |

## Descripción general

UART, por sus siglas en inglés *Universal Asynchronous Receiver-Transmitter*, es un protocolo de comunicación serial asíncrono ampliamente utilizado para transmitir datos entre dispositivos digitales. A diferencia de otros protocolos, UART no requiere una señal de reloj compartida entre transmisor y receptor, ya que la sincronización se realiza mediante bits de inicio y parada.

En este proyecto se implementan dos módulos independientes:

* `uart_tx.v`: módulo transmisor UART.
* `uart_rx.v`: módulo receptor UART.

Además, se incluyen testbenches para comprobar la correcta transmisión y recepción de datos:

* `tb_uart_tx.v`: banco de pruebas para el transmisor.
* `tb_uart_rx.v`: banco de pruebas para el receptor.

## Estructura del repositorio

```text
Actividad-Evidencia_2-main/
│
├── uart_tx.v          # Módulo transmisor UART
├── uart_rx.v          # Módulo receptor UART
│
├── tb_uart_tx.v       # Testbench del transmisor UART
├── tb_uart_rx.v       # Testbench del receptor UART
│
├── uart_tx.out        # Archivo compilado de simulación del transmisor
├── uart_rx.out        # Archivo compilado de simulación del receptor
│
├── tb_uart_tx.vcd     # Archivo de ondas generado por la simulación del transmisor
├── tb_uart_rx.vcd     # Archivo de ondas generado por la simulación del receptor
│
└── sim                # Archivo o recurso asociado a simulación
```

## Funcionamiento del sistema

El sistema UART implementado utiliza una trama básica compuesta por:

1. **Bit de inicio**: indica el comienzo de una transmisión. Tiene valor lógico `0`.
2. **Bits de datos**: se transmiten 8 bits de información.
3. **Bit de parada**: indica el final de la transmisión. Tiene valor lógico `1`.

La línea de transmisión permanece en estado alto (`1`) cuando no se están enviando datos.

## Módulo transmisor: `uart_tx.v`

El módulo `uart_tx` se encarga de recibir un dato paralelo de 8 bits y enviarlo de forma serial a través de la salida `tx`.

### Entradas

| Señal      | Tamaño | Descripción                     |
| ---------- | -----: | ------------------------------- |
| `clk`      |  1 bit | Señal de reloj                  |
| `rst`      |  1 bit | Señal de reinicio               |
| `tx_start` |  1 bit | Señal que inicia la transmisión |
| `data`     | 8 bits | Dato que se desea transmitir    |

### Salidas

| Señal     | Tamaño | Descripción                       |
| --------- | -----: | --------------------------------- |
| `tx`      |  1 bit | Línea serial de transmisión       |
| `tx_done` |  1 bit | Indica que la transmisión terminó |

### Estados del transmisor

El transmisor utiliza una máquina de estados finitos, FSM, con cuatro estados:

| Estado  | Descripción                                                |
| ------- | ---------------------------------------------------------- |
| `IDLE`  | Estado de espera. La línea `tx` permanece en alto.         |
| `START` | Envía el bit de inicio, con valor `0`.                     |
| `DATA`  | Envía los 8 bits del dato, uno por uno.                    |
| `STOP`  | Envía el bit de parada, con valor `1`, y activa `tx_done`. |

## Módulo receptor: `uart_rx.v`

El módulo `uart_rx` recibe datos seriales por la entrada `rx` y reconstruye el byte original en la salida `data_out`.

### Entradas

| Señal | Tamaño | Descripción               |
| ----- | -----: | ------------------------- |
| `clk` |  1 bit | Señal de reloj            |
| `rst` |  1 bit | Señal de reinicio         |
| `rx`  |  1 bit | Línea serial de recepción |

### Salidas

| Señal      | Tamaño | Descripción                                   |
| ---------- | -----: | --------------------------------------------- |
| `data_out` | 8 bits | Dato recibido reconstruido                    |
| `rx_done`  |  1 bit | Indica que la recepción terminó correctamente |

### Estados del receptor

El receptor también utiliza una máquina de estados finitos con cuatro estados:

| Estado  | Descripción                                   |
| ------- | --------------------------------------------- |
| `IDLE`  | Espera a detectar el bit de inicio.           |
| `START` | Confirma el inicio de la recepción.           |
| `DATA`  | Recibe los 8 bits de datos.                   |
| `STOP`  | Verifica el bit de parada y activa `rx_done`. |

## Simulación del transmisor

El archivo `tb_uart_tx.v` prueba el funcionamiento del módulo transmisor UART.

Durante la simulación se transmiten tres datos:

```verilog
8'hAA
8'h55
8'hF0
```

Cada dato se carga en la entrada `data`, se activa la señal `tx_start` y posteriormente se espera la activación de `tx_done`, lo que indica que la transmisión finalizó correctamente.

## Simulación del receptor

El archivo `tb_uart_rx.v` prueba el funcionamiento del módulo receptor UART.

Durante la simulación se envían manualmente dos tramas seriales a la entrada `rx`:

```verilog
8'hAA
8'h55
```

El receptor detecta el bit de inicio, almacena los 8 bits de datos y valida el bit de parada. Cuando la recepción termina, la señal `rx_done` se activa y el dato recibido se muestra en consola.

## Requisitos para ejecutar el proyecto

Para compilar y simular los archivos Verilog se recomienda utilizar:

* [Icarus Verilog](https://steveicarus.github.io/iverilog/)
* [GTKWave](https://gtkwave.sourceforge.net/) para visualizar las formas de onda

## Instrucciones de ejecución

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd Actividad-Evidencia_2-main
```

### 2. Compilar y ejecutar el transmisor UART

```bash
iverilog -o uart_tx.out uart_tx.v tb_uart_tx.v
vvp uart_tx.out
```

Esto generará el archivo:

```bash
tb_uart_tx.vcd
```

Para visualizar las ondas:

```bash
gtkwave tb_uart_tx.vcd
```

### 3. Compilar y ejecutar el receptor UART

```bash
iverilog -o uart_rx.out uart_rx.v tb_uart_rx.v
vvp uart_rx.out
```

Esto generará el archivo:

```bash
tb_uart_rx.vcd
```

Para visualizar las ondas:

```bash
gtkwave tb_uart_rx.vcd
```

## Resultados esperados

Al ejecutar el testbench del transmisor, se deben observar mensajes similares a los siguientes:

```text
Aplicando reset...
Transmitiendo dato xAA
Transmision 1 completada
Transmitiendo dato x55
Transmision 2 completada
Transmitiendo dato xF0
Transmision 3 completada
SIMULACION FINALIZADA
```

Al ejecutar el testbench del receptor, se deben observar mensajes similares a:

```text
Enviando trama xAA
Byte recibido correctamente
Dato recibido = aa
Enviando trama x55
Segunda recepción completada
Dato recibido = 55
SIMULACION FINALIZADA
```

## Archivos de ondas `.vcd`

Los archivos `.vcd` permiten analizar gráficamente el comportamiento de las señales digitales durante la simulación.

En ellos se pueden observar señales como:

* `clk`
* `rst`
* `tx_start`
* `data`
* `tx`
* `tx_done`
* `rx`
* `data_out`
* `rx_done`

Estos archivos son útiles para verificar visualmente la secuencia de transmisión y recepción de datos UART.

## Observaciones técnicas

La implementación utiliza una FSM simple para controlar el flujo de transmisión y recepción. En esta versión, cada bit se procesa en ciclos consecutivos de reloj definidos por el testbench. Esto permite comprobar el funcionamiento lógico del protocolo UART de forma didáctica y directa.

El diseño puede ser ampliado posteriormente agregando:

* Generador de baudios.
* Parámetro configurable para frecuencia de reloj.
* Bits de paridad.
* Verificación de errores.
* Comunicación completa entre transmisor y receptor en un mismo testbench.

## Conclusión

Este proyecto demuestra el funcionamiento básico de una comunicación UART mediante módulos escritos en Verilog. A través del transmisor y receptor implementados, se simula el envío y recepción de datos seriales de 8 bits, verificando su comportamiento con bancos de prueba y archivos de ondas.

La evidencia permite comprender cómo se estructuran las tramas UART, cómo se controlan mediante máquinas de estado y cómo se validan mediante simulación digital.
