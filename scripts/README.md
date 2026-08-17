# Carpeta de Scripts de Automatizacion y Mantenimiento (scripts/)

Este directorio contiene los scripts ejecutables utilizados para la transferencia, calibracion de hardware, flasheo y puesta a punto de la consola R35 Ultra.

---

## Indice de Scripts Principales

| Script | Lenguaje | Proposito y Uso |
| :--- | :---: | :--- |
| **`copiar_top7_final.py`** | Python 3 | Script automatizado para transferir juegos curados, caratulas HD y metadatos limpios a la tarjeta MicroSD. |
| **`activar_audio_r35ultra.sh`** | Bash | Calibra el codec de audio Rockchip RK817 por hardware, conmuta el multiplexor a altavoz interno (`SPK`) y ajusta niveles de volumen. |
| **`corregir_rutas_y_arranque.sh`** | Bash | Vincula las carpetas de ROMs con las rutas internas del sistema y limpia los servicios de depuracion en el arranque. |
| **`flashear_rocknix_b.sh`** | Bash | Script para flashear la imagen de respaldo oficial de ROCKNIX (Imagen B para clones con pantalla MIPI DSI secundaria) en tarjetas MicroSD. |
| **`formatear_y_copiar.sh`** | Bash | Formatea particiones con etiquetas compatibles y transfiere la coleccion inicial con verificacion de integridad. |
| **`reparar_y_copiar.sh`** | Bash | Ejecuta reparacion de sistemas de archivos ext4 con `e2fsck` y transfiere archivos usando `rsync` con soporte de reanudacion. |
| **`finalizar_copia.sh`** | Bash | Sincroniza paquetes de BIOS oficiales, temas visuales y musica de fondo (BGM). |

---

## Subcarpeta `legacy/`

Contiene scripts temporales, pruebas iniciales y archivos de ayuda utilizados durante las fases previas del proyecto.
