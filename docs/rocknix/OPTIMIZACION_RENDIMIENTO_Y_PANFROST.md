# Optimizacion Extrema de Rendimiento y Mesa Panfrost en ROCKNIX

Este documento detalla la arquitectura de optimizacion, desbloqueo de frecuencias y calibracion del planificador **EEVDF (Linux 6.12.79)** con el controlador **Mesa Panfrost** en la consola portátil **R35 Ultra**.

---

## 1. Modificaciones de Kernel y Frecuencias Desbloqueadas

| Parametro | Valor de Fabrica (ROCKNIX) | Valor Optimizado R35 Ultra |
| :--- | :--- | :--- |
| **Frecuencia Maxima CPU** | 1.296 GHz (1296000 kHz) | **1.512 GHz (1512000 kHz)** |
| **Gobernador CPU** | `ondemand` (Causa tirones) | **`performance` (Reloj fijo)** |
| **Frecuencia GPU Mali-G31** | Variable con throttling | **560 MHz Permanente** |
| **Gobernador Devfreq GPU** | `simple_ondemand` | **`performance`** |
| **Thermal Throttling Trip 0** | 70.0 C | **85.0 C** |
| **Thermal Throttling Trip 1** | 85.0 C | **95.0 C** |
| **vm.vfs_cache_pressure** | 100 (Descarga RAM agresiva)| **10 (Precarga ISO en RAM)** |

---

## 2. Inyeccion Quirurgica de Afinidad Multi-Nucleo (POSIX `sched_setaffinity`)

Debido a que el emulador PPSSPP standalone en ROCKNIX se ejecuta sobre el planificador EEVDF de Linux 6.12, implementamos el script `/storage/.config/scripts/ppsspp_affinity_optimizer.py` para asignar los hilos a nucleos dedicados:

```
+───────────────────────────────────────────────────────────────────────────+
|                  MATRIZ DE AFINIDAD MULTI-NUCLEO EN ROCKNIX               |
+───────────────────────────────────────────────────────────────────────────+
| NUCLEO 3: [CPU Allegrex MIPS Dynarec JIT] -> Hilo 'Emu'                   |
| NUCLEO 2: [Transformacion de Vertices / SW Skinning] -> 'PoolWorkers 0-7' |
| NUCLEO 1: [Renderizado Grafico y Driver Mesa Panfrost] -> 'PPSSPP / GPU'  |
| NUCLEO 0: [Motor de Audio SAS, ALSA Ring Buffer y Linux Kernel IRQ]       |
+───────────────────────────────────────────────────────────────────────────+
```

---

## 3. Automatizacion Persistente en `custom_start.sh`

Todas las optimizaciones se ejecutan de forma automatica y persistente al encender la consola a traves de `/storage/.config/custom_start.sh`:
* Vinculacion de scripts mediante `mount --bind`.
* Bloqueo de gobernadores a maximo rendimiento.
* Elevacion de margenes termicos.
* Activacion del pre-caching en RAM de 1 GB.

---

*Memoria de optimizacion de rendimiento para ROCKNIX en R35 Ultra (2025/2026).*
