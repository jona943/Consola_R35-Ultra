# Memoria Tecnica de ROCKNIX en R35 Ultra (Kernel Linux 6.12 Mainline)

Este directorio concentra toda la investigacion tecnica, ingenieria inversa de hardware, adaptacion de controladores de red y optimizacion extrema de rendimiento para el sistema operativo **ROCKNIX (Linux 6.12.79 aarch64)** en la consola portatil **R35 Ultra (Rockchip RK3326 revision v12)**.

---

## 1. Estructura de Documentacion

| Documento | Descripcion |
| :--- | :--- |
| **`INVESTIGACION_HARDWARE_Y_WIFI_NATIVO_RK915.md`** | Registro exhaustivo del descubrimiento del bus SDIO `0296:5348`, correccion del Device Tree (`.dtb`) para energia 5V VBUS en puerto OTG y portabilidad del driver `rk915.ko`. |
| **`OPTIMIZACION_RENDIMIENTO_Y_PANFROST.md`** | *(En desarrollo)* Desbloqueo termico a 90 C, CPU a 1.512 GHz, afinidad de 4 nucleos en planificador EEVDF y optimizaciones de Mesa Panfrost para emuladores 3D. |

---

## 2. Radiografia de Hardware Confirmada en ROCKNIX

| Parametro | Valor Identificado |
| :--- | :--- |
| **Sistema Operativo** | ROCKNIX (Build 20260801, Linux Kernel 6.12.79 aarch64) |
| **SoC** | Rockchip RK3326 (Quad Cortex-A35 64-bit) |
| **GPU 3D** | ARM Mali-G31 MP2 con driver Mesa Panfrost |
| **Bus SDIO Interno** | `mmc@ff380000` (MMC2, 4 bits, 50 MHz) |
| **Chip Wi-Fi/BT Soldado** | **Rockchip RK915 (SDIO ID: `0296:5348`)** |
| **Funciones Detectadas** | `mmc2:0001:1` (WLAN Wi-Fi) / `mmc2:0001:2` (Bluetooth HCI) |
| **Puerto USB-C OTG** | `usb@ff300000` (Host DWC2 con 5V VBUS en `GPIO3_A4`) |

---

*Directorio mantenido para el proyecto de ingenieria inversa R35 Ultra.*
