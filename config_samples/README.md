# Ejemplos de Archivos de Configuración Modificados

Esta carpeta contiene copias de referencia y plantillas de los archivos de configuración críticos que fueron modificados o analizados durante el proceso de adaptación de la consola **R35 Ultra (2025/2026)**.

---

## Índice de Archivos:

| Archivo | Sistema | Función / Modificación Realizada |
|---|---|---|
| **[`extlinux.conf.rocknix_clean`](./extlinux.conf.rocknix_clean)** | **ROCKNIX (Actual)** | **Configuración definitiva de arranque.** Utiliza Kernel 6.x, asigna la pantalla MIPI DSI secundaria y remueve la alerta `debug-shell`. |
| **[`extlinux.conf.original_with_debug`](./extlinux.conf.original_with_debug)** | **ROCKNIX (Original)** | Configuración original con `systemd.debug_shell=ttyS2` que provocaba el mensaje rojo `[FAILED]` al iniciar. |
| **[`boot.ini.arkos4clone`](./boot.ini.arkos4clone)** | **ArkOS4Clone** | Archivo `boot.ini` utilizado en la prueba de ArkOS con frecuencias de CPU (`1296 MHz`) y DDR (`666 MHz`). |
| **[`system-dirs.conf.rocknix`](./system-dirs.conf.rocknix)** | **ROCKNIX** | Mapeo de directorios internos del sistema donde se descubrió la ruta real `/storage/games-internal/roms/`. |
| **[`gamelist.xml.sample`](./gamelist.xml.sample)** | **EmulationStation** | Estructura limpia de metadatos con títulos reales, descripciones y enlaces a carátulas oficiales en `images/`. |
