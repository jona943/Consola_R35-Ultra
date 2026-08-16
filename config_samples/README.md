# Ejemplos de Archivos de Configuracion Modificados

Esta carpeta contiene copias de referencia y plantillas de los archivos de configuracion criticos que fueron modificados o analizados durante el proceso de adaptacion de la consola R35 Ultra (2025/2026).

---

## Indice de Archivos:

| Archivo | Sistema | Funcion / Modificacion Realizada |
|---|---|---|
| [`extlinux.conf.rocknix_clean`](./extlinux.conf.rocknix_clean) | ROCKNIX (Actual) | Configuracion definitiva de arranque. Utiliza Kernel 6.x, asigna la pantalla MIPI DSI secundaria y remueve la alerta debug-shell. |
| [`extlinux.conf.original_with_debug`](./extlinux.conf.original_with_debug) | ROCKNIX (Original) | Configuracion original con systemd.debug_shell=ttyS2 que provocaba el mensaje rojo [FAILED] al iniciar. |
| [`001-device_config.audio_fix`](./001-device_config.audio_fix) | ROCKNIX | Configuracion de perfil profile.d que activa el modo AUDIO_MANAGEMENT=legacy para consolas clonadas. |
| [`custom_start.sh.audio_fix`](./custom_start.sh.audio_fix) | ROCKNIX | Script de inicio automatico que desmutea los canales Master, Speaker y Playback del chip RK817 al 95%. |
| [`es_settings.cfg.audio_fix`](./es_settings.cfg.audio_fix) | EmulationStation | Ajuste del dispositivo de audio a AudioDevice=Playback y volumen al 95%. |
| [`boot.ini.arkos4clone`](./boot.ini.arkos4clone) | ArkOS4Clone | Archivo boot.ini utilizado en la prueba de ArkOS con frecuencias de CPU (1296 MHz) y DDR (666 MHz). |
| [`system-dirs.conf.rocknix`](./system-dirs.conf.rocknix) | ROCKNIX | Mapeo de directorios internos del sistema donde se descubrio la ruta real /storage/games-internal/roms/. |
| [`gamelist.xml.sample`](./gamelist.xml.sample) | EmulationStation | Estructura limpia de metadatos con titulos reales, descripciones y enlaces a caratulas oficiales en images/. |
