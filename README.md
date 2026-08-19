# Repositorio R35 Ultra (2025/2026)

Este repositorio contiene la memoria tecnica maestra, documentacion de ingenieria inversa, guias de configuracion, scripts de automatizacion y catalogo de juegos optimizado para la consola portatil **R35 Ultra** (Rockchip RK3326 revision v12).

---

## 1. Ficha Tecnica y Hardware Confirmado

| Componente | Especificacion Verificada en Hardware |
| :--- | :--- |
| **Dispositivo / Modelo** | **R35 Ultra** / Serie EE-Clone (`Rockchip rk3326 evb lpddr3 v12 board`, revision 2025/2026) |
| **Procesador (SoC)** | **Rockchip RK3326** (Quad-Core ARM Cortex-A35 64-bit @ 1.3 GHz base, overclockeado a **1.512 GHz**) |
| **Graficos (GPU)** | **ARM Mali-G31 MP2** (Arquitectura Bifrost v7.0.9, DDK g18p0 @ **520 MHz**) |
| **Memoria RAM** | **1 GB LPDDR3** (Bus de alta velocidad @ 666 MHz) |
| **Pantalla** | Panel cuadrado **MIPI DSI de 720 x 720 pixeles** (formato 1:1, tasa de refresco 54.54 Hz) |
| **Audio y PMIC** | **Rockchip RK817** (Codec de audio de alta definicion I2S y gestion energetica) |
| **Bateria** | Li-Po recargable de **~3000 mAh** (4.2V max / 2832 mAh diseno reportado) con carga USB-C |
| **Conectividad Wi-Fi** | **Rockchip RK915 integrado** por bus SDIO `mmc2` (interfaz `wlan0` nativa, sin dongles USB) |
| **Almacenamiento Interno** | **4 GB eMMC** (`mmcblk0` particionado en `/flash` y `/storage` con **EmuELEC 4.7-Nexus**) |
| **Almacenamiento Externo** | Ranura **MicroSD (TF1)** (`mmcblk1` con soporte para ext4, FAT32 y exFAT) |
| **Conectividad Bluetooth** | Pila Bluetooth activa en Kernel (BlueZ / HCI / RFCOMM / HIDP) |

---

## 2. Decision Arquitectonica Final

* **Sistema Operativo Definitivo:** **EmuELEC 4.7-Nexus Nativo (Kernel Linux 5.10.160 KMS)** en almacenamiento interno eMMC.
* **Justificacion:**  
  Tras evaluar y poner a punto tanto sistemas modernos (ROCKNIX en Linux 6.x) como el sistema nativo de fabrica, se determino que la arquitectura de **renderizado directo por hardware (Direct DRM/KMS)** de EmuELEC entrega el 100% de la capacidad de la GPU Mali-G31 al emulador sin la sobrecarga del compositor Wayland, permitiendo correr juegos 3D exigentes como *God of War: Chains of Olympus* a **35-40 FPS fluidos**.
* **Tarjeta MicroSD:** Utilizada como almacenamiento dedicado para el **Catalogo Reducido Top 7 Esenciales** y herramientas nativas.

---

## 3. Estructura del Repositorio

```
Consola_R35-Ultra/
├── README.md                              <- Este documento (Ficha tecnica y resumen del estado final)
├── MEMORIA_TECNICA_PROYECTO_R35_ULTRA.md  <- Memoria tecnica maestra exhaustiva
│
├── docs/                                  <- Documentacion tecnica y bitacoras
│   ├── BITACORA_PRUEBAS_SISTEMAS.md       <- Registro de pruebas de arranque y OS
│   ├── GUIA_MIGRACION_Y_SISTEMAS_R35_ULTRA.md
│   └── DIAGNOSTICO_Y_PLAN_LIMPIEZA.md
│
├── config_samples/                        <- Ejemplos de configuracion y respaldos
│   ├── README.md                          <- Catalogo de perfiles de configuracion turbo
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

## 4. Optimizaciones Principales Aplicadas a la Consola

1. **Desbloqueo Permanente de Acceso Root por SSH:**  
   Inyeccion de claves criptograficas en eMMC interna mediante arranque cruzado. Acceso directo con `ssh root@emuelec.local` o por IP sin requerir clave.
2. **Gestion Dinamica de Energia y Rendimiento (408 MHz - 1.512 GHz):**  
   CPU calibrada con gobernador `interactive` inteligente (baja a 408 MHz en reposo y escala a 1.512 GHz en <10 ms bajo carga), GPU Mali-G31 en `simple_ondemand` y ahorro de energia activo en Wi-Fi RK915.
3. **Expansion y Optimizacion de Memoria RAM con ZRAM (512 MB ZSTD):**  
   Activacion de dispositivo de bloque swap comprimido en memoria volatil utilizando algoritmo ZSTD de alta densidad (`vm.page-cluster = 0`, `vm.swappiness = 60`), eliminando cierres por falta de memoria (OOM) en emuladores pesados sin desgaste de disco.
4. **Perfil Turbo PPSSPP y Software Skinning para PSP:**  
   Reloj emulado a 222 MHz, desbloqueo de motor a 60 FPS (`_C1 60 FPS`), `SoftwareSkinning = True` (asistencia de CPU ARM NEON a la GPU Mali-G31), mapeo completo de gatillos traseros (L1/L2/R1/R2) y estiramiento dinamico de audio (`AudioResampler = True`) con anillo de bufer ALSA elastico.
5. **Catalogo Reducido Top 7 Esenciales:**  
   63 titulos de elite en PSP, NDS, GBA, SNES, N64, PS1, Neo-Geo, CPS1/2/3 y NES con caratulas oficiales en HD vinculadas al 100%.
6. **Herramienta Nativa en PORTS:**  
   `Diagnostico y Estado del Sistema` integrado directamente en el carrusel de consolas con telemetria en vivo por hardware (`text_viewer`).

---

## 5. Acceso Rapido por SSH

Para acceder a la consola desde cualquier terminal o dispositivo en la misma red Wi-Fi:

```bash
# Conexion por mDNS (desde Linux/macOS):
ssh root@emuelec.local

# O directamente por IP:
ssh root@192.168.1.64
```

* **Usuario:** `root`
* **Contraseña:** `emuelec` (Habilitada de forma permanente para cualquier computadora, SFTP, WinSCP o FileZilla).

---

*Repositorio mantenido para la consola R35 Ultra (2025/2026).*
