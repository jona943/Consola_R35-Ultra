# Bitacora de Pruebas, Telemetria y Rendimiento en ROCKNIX (R35 Ultra)

Este documento registra cronologicamente todas las sesiones de prueba, configuraciones aplicadas, resultados medidos, hallazgos de fallos y comparativas directas contra el sistema de fabrica (EmuELEC).

---

## 📊 Matriz Comparativa de Pruebas

| Sesion / Prueba | Configuracion Aplicada | FPS Cinematicas | FPS Batalla Real | Estado del Audio | Causa Tecnica del Resultado |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Referencia (EmuELEC 4.7)** | Direct DRM/KMS, Mali DDK, 4-Core Affinity | 60 FPS | **30 - 45 FPS** | Limpio (ALSA directo) | Renderizado directo sin compositor intermedio. |
| **Prueba 1 (ROCKNIX Stock)** | Linux 6.12, 1.296 GHz, PipeWire stock | 10 FPS | **5 - 6 FPS** | Tartamudeo leve | Limite de pausa + hilos sin mapear en Core 0. |
| **Prueba 2 (ROCKNIX Clock Fix)** | DTB 1.512 GHz + Mali clk_mali fix | 30 FPS | **5 - 7 FPS** | Limpio (PipeWire 44.1k) | Reloj GPU activo pero cuello de botella en render. |
| **Prueba 3 (ROCKNIX Settings)** | RenderingMode=0, SkipBufferEffects, NEON | 45-60 FPS | **7 FPS** | Excelente | Audio fluido; cuello de botella en compositor Sway/Wayland. |

---

## 🔬 Registro Detallado de Hallazgos y Diagnosticos

### 1. Lo que SÍ ha funcionado con exito:
* **Audio y Sincronizacion:** La calibracion de PipeWire a 44100 Hz y 1024 quantum redujo el uso de CPU de 42% a 15%, logrando que las cinematicas se escuchen perfectas y sin chasquidos.
* **Energizacion de Puertos:** Parche 5V VBUS en OTG y bus SDIO funcional.
* **Reparto de CPU:** La afinidad exacta (`EmuThread` en Core 3, `PoolW` en Core 2) distribuye la carga al ~45-50% por nucleo sin saturar ningun procesador individual.

### 2. Lo que NO ha funcionado y genera los 7 FPS en Batalla:
* **Capa Compositora Sway/Wayland:** En ROCKNIX, los juegos no se ejecutan directamente en la pantalla (Direct DRM/KMS) como en EmuELEC, sino a traves de una ventana gestionada por el compositor **Sway (wlroots Wayland)**. En batallas complejas, Sway realiza una copia intermedia de cada fotograma (DMA-BUF blit), colapsando el ancho de banda de la memoria LPDDR3.
* **Backend Grafico (GLES vs Vulkan):** El ejecutable standalone de PPSSPP en ROCKNIX esta forzando llamadas a traves de la capa de compatibilidad EGL/Wayland.

---

*Documento en actualizacion constante tras cada sesion de telemetria.*

---

## 🔬 Sesion 4: Descubrimiento del Reseteo Silencioso de EmulationStation

* **Sintoma:** Al reiniciar o entrar al juego, la tasa caia a 7 FPS en combate a pesar de haber editado `ppsspp.ini`.
* **Causa Raiz Descubierta:** El script del sistema `/usr/bin/start_ppsspp.sh` contenia directivas `if [ "${SKIPB}" = "1" ]` que, al no recibir parametros desde EmulationStation, **forzaban activamente `SkipBufferEffects = False` y `AutoFrameSkip = False` en cada lanzamiento**, borrando nuestras optimizaciones antes de abrir el binario.
* **Solucion Aplicada:** Se creo `/storage/.config/scripts/start_ppsspp.sh` blindado con inyeccion obligatoria de `RenderingMode=0`, `SkipBufferEffects=True`, `AutoFrameSkip=True` y `SoftwareSkinning=True`, montado sobre `/usr/bin/start_ppsspp.sh`.

---

## 🔬 Sesion 5: Correccion de VSync Wayland y Modo de Búfer

* **Sintoma:** Bloqueo a 15 FPS desde el menu de inicio y tirones severos al forzar `RenderingMode=0`.
* **Causa Raiz:** 
  1. `RenderingMode = 0` (No-buffered) rompe el pipeline de render en versiones modernas de PPSSPP en Wayland/GLES, impidiendo dibujar menus y textos a tiempo.
  2. `VSync = True` generaba un bloqueo de doble sincronizacion contra el compositor **Sway** (60Hz / 2 = 30 / 2 = 15 FPS fijo).
* **Solucion Aplicada:** Se establecio el **Perfil de Oro Comprobado**:
  * `RenderingMode = 1` (Buffered).
  * `VSync = False` y `VSyncInterval = False` (Elimina doble VSync contra Wayland).
  * `AutoFrameSkip = True` con `FrameSkip = 2` (Salto dinamico inteligente).
  * `RenderDuplicateFrames = True` (Renderiza duplicados a 60 Hz).
  * `SoftwareSkinning = True` (NEON SIMD).

---

## 🔬 Sesion 6: Descubrimiento de la GPU Sin Devfreq (Reloj a 200 MHz)

* **Sintoma:** Bloqueo a 13-15 FPS en menus y 6-7 FPS en combate incluso con todos los ajustes en bajo.
* **Diagnostico de Kernel (dmesg):**
  ```
  mali ff400000.gpu: Kernel DDK version r52p0-00eac0
  mali ff400000.gpu: Clock not available for devfreq
  mali ff400000.gpu: Continuing without devfreq
  ```
* **Causa Raiz de Hardware:** El driver `mali_kbase r52p0` no pudo enlazar el reloj para devfreq en el Device Tree, por lo que **la GPU Mali-G31 se mantiene permanentemente en su frecuencia base de arranque (200 MHz)** en lugar de escalar a los 520 - 560 MHz que exige God of War.
* **Impacto:** Con la GPU corriendo a solo el 35% de su velocidad real (200 MHz vs 560 MHz), cualquier juego 3D pesado se ahoga a 13 FPS en menus y 6-7 FPS en combate.

---

## 🔬 Sesion 7: Aplicacion de la Solucion de Raiz (Devfreq GPU a 560 MHz)

* **Diagnostico de Raiz:** `mali_kbase` r52p0 requeria `clocks = <0x02 0x49 0x02 0x49>` y `clock-names = "core\0gpu"` para inicializar el controlador de frecuencia dinamica devfreq.
* **Solucion de Raiz Aplicada:**
  1. Se reescribio el nodo `gpu@ff400000` con `clocks` duales (`core\0gpu`) y `power_policy = "always_on"`.
  2. Se compilo y flasheo `rk3326-gameconsole-eeclone-gpu-devfreq.dtb` directamente en `/flash/`.
  3. Esto permite que el kernel escale la GPU Mali-G31 de 200 MHz a **560 MHz**, triplicando el ancho de banda grafico.

---

## 🔬 Sesion 8: Descubrimiento del Reloj AXI ACLK_GPU (0xaa) Faltante

* **Diagnostico de Hardware:** En la arquitectura Rockchip RK3326/PX30, la GPU Mali Bifrost requiere **DOS relojes obligatorios**:
  1. `SCLK_GPU` (Clock ID 73 / `0x49` en hex): Reloj central del núcleo gráfico (*clk_mali*).
  2. `ACLK_GPU` (Clock ID 170 / `0xaa` en hex): Reloj del bus AXI de interconexión (*aclk_gpu / bus*).
* **El Fallo Original:** En el DTB de ROCKNIX solo existía `0x49`, por lo que el driver `mali_kbase` no podía sincronizar el bus AXI y abortaba devfreq.
* **Corrección Aplicada:** Se compilo `gpu@ff400000` con `clocks = <0x02 0x49 0x02 0xaa>` y `clock-names = "clk_mali\0bus"`.
* **Prueba Comparativa Paralela:** Se configuró EmulationStation para probar también el emulador **RetroArch (ppsspp core)**.

---

## 🔬 Sesion 9: Compresión de Framebuffer AFBC y Panel 720x720

* **Diagnostico de Rendimiento:** La resolución virtual del compositor Wayland/Sway es `720x720` (518,400 píxeles por pasada).
* **El Cuello de Botella:** La variable `MALI_WAYLAND_AFBC=0` venía desactivada por defecto, obligando a la GPU Mali-G31 a escribir y leer fotogramas RGBA de 32 bits sin comprimir sobre la memoria RAM a 60 Hz.
* **Ajuste Aplicado:** Se forzo `export MALI_WAYLAND_AFBC=1` (Compresión de Framebuffer ARM por hardware) y `export vblank_mode=0` para desbloquear el ancho de banda del bus de memoria LPDDR3.

---

## 🔬 Sesion 10: Fallo de Compresion AFBC en Wayland (Pantalla Negra)

* **Sintoma:** Pantalla negra completa al iniciar el juego; se escuchaba el audio pero no habia salida de video ni acceso al menu de PPSSPP.
* **Causa Raiz:** El compositor Sway/wlroots no soporta el escaneo directo de búferes comprimidos AFBC en el panel DSI, provocando que Wayland rechace los fotogramas y la pantalla quede en negro.
* **Accion Aplicada:** Se restablecio `MALI_WAYLAND_AFBC=0` y `RenderingMode = 1` (Buffered) para restaurar la salida de video al 100%.
