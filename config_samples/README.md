# Ejemplos de Archivos de Configuracion y Perfiles Turbo (config_samples/)

Esta carpeta contiene copias de referencia, perfiles de rendimiento optimizados y plantillas de los archivos de configuracion criticos para la consola R35 Ultra (2025/2026).

---

## Indice de Archivos de Configuracion

| Archivo | Sistema / Emulador | Funcion y Optimizaciones Incluidas |
| :--- | :--- | :--- |
| **`ppsspp.ini.optimized`** | PPSSPP (Sony PSP) | Perfil turbo con Overclock a 1.512 GHz, reloj emulado a 180 MHz, renderizado directo sin bufer (`SkipBufferEffects = True`) y estiramiento dinamico de audio (`AudioResampler = True`). Permite correr *God of War: Chains of Olympus* a **35-40 FPS fluidos**. |
| **`Flycast.opt`** | Flycast (Sega Dreamcast) | Perfil de alto rendimiento con `alpha_sorting = per-strip (fast)`, eliminacion de sombras de volumen, resolucion nativa 640x480 y suavizado de cinematicas para *Legacy of Kain: Soul Reaver*. |
| **`custom_start.sh.performance_and_audio`** | EmuELEC / Linux | Script de inicio con gobernador interactivo (408 MHz a 1.512 GHz), escalado de GPU Mali (`simple_ondemand`), swap comprimido **ZRAM de 512 MB con algoritmo ZSTD**, ahorro Wi-Fi y desbloqueo SSH. |
| **`extlinux.conf.rocknix_clean`** | ROCKNIX (Kernel 6.x) | Configuracion definitiva de arranque para ROCKNIX con asignacion del panel MIPI DSI secundario. |
| **`extlinux.conf.original_with_debug`** | ROCKNIX (Original) | Configuracion original con `systemd.debug_shell=ttyS2` de referencia. |
| **`001-device_config.audio_fix`** | ROCKNIX | Configuracion `profile.d` para modo `AUDIO_MANAGEMENT=legacy` en consolas clonadas. |
| **`boot.ini.arkos4clone`** | ArkOS4Clone | Archivo `boot.ini` utilizado en las pruebas de compatibilidad de cargadores de arranque. |
| **`gamelist.xml.sample`** | EmulationStation | Plantilla de estructura limpia de metadatos con enlaces a caratulas oficiales HD. |
