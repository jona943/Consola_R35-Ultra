# Memoria Técnica Integral del Proyecto: R35 Ultra (2025/2026)

Este documento es el registro maestro y memoria técnica de todo el trabajo de diagnóstico, ingeniería de compatibilidad de hardware, instalación de sistema operativo y curación de juegos realizado en la consola portátil **R35 Ultra**.

---

## 1. Ficha Técnica y Diagnóstico de Hardware

* **Dispositivo:** Consola Portátil R35 Ultra / Serie EE-Clone (Fabricación finales de 2025 / Adquirida en febrero de 2026).
* **Procesador (SoC):** Rockchip RK3326 (Quad-Core ARM Cortex-A35 @ 1.5 GHz, GPU Mali-G31 MP2).
* **Memoria RAM:** 1 GB DDR3L.
* **Almacenamiento Interno (eMMC/NAND):** Sistema operativo original de fábrica precargado (arranca automáticamente si no hay tarjeta MicroSD insertada o si la tarjeta falla).
* **Ranura MicroSD:** Ranura única con prioridad de arranque por hardware sobre la memoria interna.

---

## 2. El Desafío de Compatibilidad: Diagnóstico del PMIC y Pantalla

Durante el proceso de pruebas se descubrió el motivo exacto por el cual las imágenes tradicionales de la comunidad fallaban en esta consola:

### [Fallo] ¿Por qué fallaron ArkOS 2.0, ArkOS Panel 5, ArkOS4Clone y AmberELEC?
* **Causa:** Todas estas distribuciones están basadas en el **Kernel Linux 4.4 legacy** (2018–2021).
* **El fallo eléctrico:** La placa base de la R35 Ultra (fabricada a finales de 2025) monta un chip de administración de energía (**PMIC**) moderno con un mapa de voltajes por bus I2C que el Kernel 4.4 no sabe inicializar.
* **Resultado:** La consola se apagaba por protección de sobrevoltaje y hacía parpadear el **LED Rojo**.

### [Hardware OK] ¿Por qué triunfó ROCKNIX (Kernel Linux 6.x Mainline)?
* **La solución de energía:** ROCKNIX incluye el Kernel 6.x moderno con controladores actualizados para los chips de energía de placas 2025/2026, logrando energizar la placa de forma estable (**LED Azul Sólido**).
* **La solución de pantalla (Imagen "B"):** En consolas clones (*EE-Clones / R35 Ultra / K36*), el bus de video MIPI-DSI y el circuito de brillo PWM están conectados a un canal secundario. La **Imagen "B" oficial de ROCKNIX (`...-b.img.gz`)** viene compilada exclusivamente para habilitar este canal de video y retroiluminación.

---

## 3. Historial de Pruebas Realizadas

| # | Sistema / Configuración | Kernel | Resultado | Diagnóstico Técnico |
|---|---|---|---|---|
| 1 | **ArkOS 2.0 MultiPanel** | Linux 4.4 | [Fallo] **LED Rojo** | PMIC no soportado en Kernel 4.4 $\rightarrow$ Corte de energía. |
| 2 | **ArkOS Panel 5 (Custom Image)** | Linux 4.4 | [Fallo] **LED Rojo** | Mismo corte por incompatibilidad de voltajes. |
| 3 | **ArkOS4Clone (`r36ultra.dtb`)** | Linux 4.4 | [Fallo] **LED Rojo** | Confirma que ningún Kernel 4.4 maneja la energía de esta placa. |
| 4 | **AmberELEC-RG351MP** | Linux 4.4 | [Fallo] **LED Rojo** | Mismo comportamiento de corte de energía por Kernel 4.4. |
| 5 | **ROCKNIX (Imagen A)** | Linux 6.x | [Hardware OK] **LED Azul Sólido** | El Kernel 6.x arrancó al 100%, pero la imagen A es para marcas comerciales (DSI0). |
| 6 | **ROCKNIX (Imagen B para Clones)** | **Linux 6.x** | [Exito] **100% ÉXITO TOTAL** | **Video inicializado en panel secundario, brillo activo, LED azul y sistema corriendo a máxima velocidad.** |

---

## 4. Curación de la Colección de Juegos (18 GB)

Se realizó una depuración exhaustiva para transformar la consola en un centro de juegos retro premium:

* **Eliminación de basura:** Se depuraron más de 78 carpetas vacías y sistemas obsoletos.
* **Colección final:** **1.669 Juegos Curados** sin títulos duplicados, versiones corruptas o clones innecesarios.
* **Integración de títulos especiales del usuario:**
  * *Crash Bandicoot (USA)* (PS1 - Formato `.bin` + `.cue`).
  * *Doom (USA) (Rev 1)* (PS1 - Pistas de audio completas + `.cue`).
  * *Yu-Gi-Oh! Forbidden Memories (USA)* (PS1 - Formato `.bin` + `.cue`).
  * *The Flintstones* (SNES).
  * *Super Bros 10 Kung Fu Mario* (NES).
* **Carátulas en HD:** **1.002 Carátulas Oficiales** en alta definición descargadas y vinculadas en cada carpeta `images/`.
* **Metadatos Limpios:** 17 archivos `gamelist.xml` con nombres reales y descripciones ordenadas.
* **Pack de BIOS Oficiales:** Instaladas en `/storage/roms/bios/` y `/storage/bios/` (PS1, Dreamcast, PSP, Neo-Geo, MAME, CPS1/2/3).

---

## 5. Distribución de Juegos por Plataforma

| Consola | Carpeta | Juegos | Estado de Portadas / BIOS |
|---|---|---|---|
| **PlayStation 1 (PSX)** | `roms/psx/` | 3 títulos pesados | 100% Portadas HD + BIOS `scph1001.bin` |
| **PSP (PlayStation Portable)** | `roms/psp/` | 9 títulos optimizados | 100% Portadas HD |
| **Sega Dreamcast** | `roms/dreamcast/` | 11 títulos | 100% Portadas HD + BIOS `dc_boot.bin` |
| **Nintendo 64** | `roms/n64/` | 78 clásicos | 100% Portadas HD |
| **Game Boy Advance (GBA)** | `roms/gba/` | 199 esenciales | 100% Portadas HD + BIOS `gba_bios.bin` |
| **Super Nintendo (SNES)** | `roms/snes/` | 128 esenciales | 100% Portadas HD |
| **Nintendo NES** | `roms/nes/` | 648 clásicos | 100% Portadas HD |
| **Game Boy (GB)** | `roms/gb/` | 84 esenciales | 100% Portadas HD |
| **Game Boy Color (GBC)** | `roms/gbc/` | 67 esenciales | 100% Portadas HD |
| **Nintendo DS (NDS)** | `roms/nds/` | 12 esenciales | 100% Portadas HD + BIOS `biosnds7/9.rom` |
| **Sega Mega Drive / Genesis** | `roms/megadrive/` | 126 esenciales | 100% Portadas HD |
| **Sega Game Gear** | `roms/gamegear/` | 44 esenciales | 100% Portadas HD |
| **SNK Neo-Geo** | `roms/neogeo/` | 106 clásicos arcade | 100% Portadas HD + BIOS `neogeo.zip` |
| **Capcom CPS1, CPS2, CPS3** | `roms/cps1,2,3/` | 66 clásicos de pelea | 100% Portadas HD + QSound BIOS |
| **Arcade / MAME** | `roms/mame/` | 56 clásicos | 100% Portadas HD |
| **PC Engine / TG-16** | `roms/pcengine/` | 37 títulos | 100% Portadas HD |

---

## 6. Guía de Uso, Red y Mantenimiento

### A. Acceso Remoto por SSH (Servidor en la consola)
1. Conecta la consola a tu red Wi-Fi (usando un dongle USB Wi-Fi conectado al puerto OTG).
2. Activa la opción **SSH** en el menú de red de ROCKNIX.
3. Conéctate desde cualquier computadora:
   ```bash
   ssh root@IP_DE_LA_CONSOLA
   # Contraseña: root (o rocknix)
   ```

### B. Cómo agregar más juegos en el futuro
* **Vía PC (Lector de tarjetas):** Conecta la MicroSD a tu PC, abre la partición `STORAGE` y coloca los nuevos archivos en `/media/dev-jonathan/STORAGE/roms/NOMBRE_CONSOLA/`.
* **Vía Red (Samba / SMB):** Escribe en el explorador de archivos de tu computadora: `\\IP_DE_LA_CONSOLA\roms`.

### C. Scripts de Restauración Automatizados (Guardados en este repositorio)
* **`./flashear_rocknix_b.sh`:** Flashea la imagen ganadora de ROCKNIX B a la tarjeta MicroSD.
* **`./finalizar_copia.sh`:** Sincroniza BIOS, temas y música de fondo.

---

*Memoria técnica generada y preservada en el repositorio local `R35_Ultra`.*
