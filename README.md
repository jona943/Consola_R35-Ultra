# Repositorio R35 Ultra (2025/2026)

Este repositorio contiene la memoria tecnica maestra, documentacion de ingenieria inversa, guias de configuracion, scripts de automatizacion y catalogo de juegos optimizado para la consola portatil **R35 Ultra** (Rockchip RK3326 revision v12).

---

## 1. Decision Arquitectonica Final

* **Sistema Operativo Definitivo:** **EmuELEC 4.7-Nexus Nativo (Kernel 4.4 KMS)** en almacenamiento interno eMMC.
* **Justificacion:**  
  Tras evaluar y poner a punto tanto sistemas modernos (ROCKNIX en Linux 6.x) como el sistema nativo de fabrica, se determino que la arquitectura de **renderizado directo por hardware (Direct DRM/KMS)** de EmuELEC entrega el 100% de la capacidad de la GPU Mali-G31 al emulador sin la sobrecarga del compositor Wayland, permitiendo correr juegos 3D exigentes como *God of War: Chains of Olympus* a **35-40 FPS fluidos**.
* **Tarjeta MicroSD:** Utilizada como almacenamiento dedicado para el **Catalogo Reducido Top 7 Esenciales** y herramientas nativas.

---

## 2. Estructura del Repositorio

```
Consola_R35-Ultra/
├── README.md                              <- Este documento (Resumen del estado final)
├── MEMORIA_TECNICA_PROYECTO_R35_ULTRA.md  <- Memoria tecnica maestra exhaustiva
│
├── docs/                                  <- Documentacion tecnica y bitacoras
│   ├── BITACORA_PRUEBAS_SISTEMAS.md       <- Registro de pruebas de arranque y OS
│   ├── GUIA_MIGRACION_Y_SISTEMAS_R35_ULTRA.md
│   └── DIAGNOSTICO_Y_PLAN_LIMPIEZA.md
│
├── config_samples/                        <- Ejemplos de configuracion y respaldos
│   ├── README.md
│   ├── ppsspp.ini.optimized               <- Perfil turbo para God of War y PSP
│   ├── custom_start.sh.performance_and_audio
│   └── gamelist.xml.sample
│
├── scripts/                               <- Scripts de automatizacion y mantenimiento
│   ├── copiar_top7_final.py               <- Transferencia de juegos Top 7 y caratulas
│   ├── activar_audio_r35ultra.sh          <- Calibracion de audio ALSA / RK817
│   ├── flashear_rocknix_b.sh              <- Respaldo de imagen ROCKNIX B
│   └── legacy/                            <- Scripts de pruebas anteriores
│
├── copia_r35Ultra/                        <- Repositorio de ROMs de respaldo y caratulas HD
└── dtb_r36ultra/                          <- Arboles de dispositivos
```

---

## 3. Optimizaciones Principales Aplicadas a la Consola

1. **Desbloqueo Permanente de Acceso Root por SSH:**  
   Inyeccion de claves criptograficas en eMMC interna mediante arranque cruzado. Acceso directo con `ssh root@emuelec.local`.
2. **Overclock de Hardware a 1.512 GHz:**  
   CPU fijada a 1.512 GHz y GPU Mali-G31 a 520 MHz de forma persistente en cada inicio.
3. **Perfil Turbo PPSSPP para PSP:**  
   Reloj emulado calibrado a 180 MHz, renderizado sin bufer y estiramiento dinamico de audio (`AudioResampler = True`) para eliminar cortes de sonido.
4. **Catalogo Reducido Top 7 Esenciales:**  
   63 titulos de elite en PSP, NDS, GBA, SNES, N64, PS1, Neo-Geo, CPS1/2/3 y NES con caratulas oficiales en HD vinculadas al 100%.
5. **Herramienta Nativa en PORTS:**  
   `Diagnostico y Estado del Sistema` integrado directamente en el carrusel de consolas con telemetria en vivo por hardware (`text_viewer`).

---

## 4. Acceso Rapido por SSH

Para acceder a la consola desde cualquier terminal en la misma red Wi-Fi:

```bash
ssh root@emuelec.local
# o por IP:
ssh root@192.168.1.66
```

---

*Repositorio mantenido para la consola R35 Ultra (2026).*
