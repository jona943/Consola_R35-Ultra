# Guía Técnica: Migración y Sistemas Operativos para R35 Ultra

Este documento contiene el registro técnico, análisis de hardware y los pasos para instalar y probar firmwares alternativos (**ArkOS, dArkOS, AmberELEC, ROCKNIX**) en la consola portátil **R35 Ultra / R36S** en el futuro.

---

## 1. Diagnóstico de Hardware (R35 Ultra)

* **Procesador (SoC):** Rockchip RK3326 (Quad-Core ARM Cortex-A35 @ 1.5 GHz, GPU Mali-G31 MP2).
* **Memoria RAM:** 1 GB DDR3L.
* **Pantalla:** 3.5" IPS 640x480 (o panel panorámico 720x720 según variante).
* **Almacenamiento Interno:** Memoria eMMC/NAND con sistema operativo de fábrica precargado.
* **Ranura MicroSD:** Diseñada principalmente para juegos (`ROMS`) o para sobreescribir el arranque si la tarjeta posee un gestor de arranque (*bootloader*) compatible con el árbol de dispositivos (**DTB**) de la placa base.

> [!NOTE]
> **¿Por qué parpadeó el LED rojo al probar la imagen MultiPanel?** > El LED rojo intermitente se activa por protección del circuito integrado de administración de energía (**PMIC / AXP228 / RK817**). Ocurre cuando el archivo `.dtb` cargado en la partición `BOOT` intenta configurar un mapa de voltajes que no coincide exactamente con los reguladores de la placa madre. Al no coincidir, la consola se apaga de emergencia y arranca desde su almacenamiento interno.

---

## 2. Imágenes y Distribuciones de ArkOS Específicas para Clones

Si deseas probar un nuevo sistema operativo en el futuro, estas son las compilaciones más compatibles y actualizadas para esta placa:

### A. dArkOSRE-R36 (Específico para placas modernas y clones R35/R36)
* **Repositorio oficial:** [GitHub - southoz/dArkOSRE-R36](https://github.com/southoz/dArkOSRE-R36)
* **Descarga de Releases:** [Releases de dArkOSRE](https://github.com/southoz/dArkOSRE-R36/releases)
* **Características:**
  * Desarrollado específicamente para consolas con placas modernas (**SoySauce, Y3506, G80CA, V12**).
  * Control Center integrado para brillo, volumen y LED.
  * Selector automático de DTB para evitar fallos de encendido o LED rojo.

### B. ArkOS4Clone (Porting con herramienta de análisis DTB)
* **Repositorio oficial:** [GitHub - lcdyk0517/arkos4clone](https://github.com/lcdyk0517/arkos4clone)
* **Herramienta Web DTB Analyzer:** [dtbTools](https://lcdyk0517.github.io/dtbTools.html)
* **Características:**
  * Permite subir los archivos `.dtb` de tu consola para identificar la revisión exacta de pantalla y hardware.
  * Genera el kernel y DTB a la medida de tu dispositivo.

### C. AmberELEC (Alternativa ultra estable basada en 351ELEC)
* **Web oficial:** [AmberELEC.org](https://amberelec.org/)
* **Descarga para RK3326:** Versión para RG351MP / Clones RK3326.
* **Características:**
  * Interfaz visual pulida, menús simplificados y marcos (*bezels*) automáticos.

---

## 3. Procedimiento para Probar Nuevos Sistemas desde Terminal

### Paso 1: Flashear la imagen raw a la MicroSD
```bash
# 1. Identificar la unidad MicroSD (usualmente /dev/sdb)
lsblk

# 2. Desmontar cualquier partición activa
sudo umount /dev/sdb* 2>/dev/null || true

# 3. Flashear la imagen descomprimida (.img)
sudo dd if=/ruta/hacia/tu_imagen.img of=/dev/sdb bs=8M status=progress conv=fsync
```

---

### Paso 2: Si la consola no enciende o parpadea en rojo (Ajuste de DTB)
La partición `BOOT` (FAT32) contiene la carpeta `ScreenFiles/`. Si una pantalla o voltaje no coincide:

1. Conecta la MicroSD a tu PC.
2. Abre la partición `BOOT`.
3. Copia los archivos de la carpeta correspondiente según el panel a la raíz de `BOOT`:
   * **Panel 1 (`ScreenFiles/Panel 1`):** Pantalla revisada tipo 1.
   * **Panel 2 (`ScreenFiles/Panel 2`):** Pantalla revisada tipo 2.
   * **Panel 4 - V22 (`ScreenFiles/Panel 4 - V22`):** Para placas tipo V12/V22.
   * **Panel 5 (`ScreenFiles/Panel 5`):** Incluye su propio kernel `Image` (ideal si otros paneles fallan).
4. Ejecuta `sync` en tu terminal y expulsa la tarjeta de forma segura.

---

## 4. Estado Actual del Repositorio de Juegos Curados

En este equipo tienes almacenada la colección completa y depurada en:
 **Ruta local:** `/home/dev-jonathan/Escritorio/R35_Ultra/copia_r35Ultra` (18 GB)

* **Juegos incluidos:** 1.669 títulos esenciales organizados por consola (*NES, SNES, N64, GBA, GBC, GB, Megadrive, PS1, PSP, Dreamcast, Neo-Geo, CPS1/2/3, MAME, NDS, PC Engine, Game Gear*).
* **Metadatos:** 17 archivos `gamelist.xml` limpios y sin errores de entrada/salida.
* **Carátulas:** 1.002 carátulas oficiales en alta definición vinculadas en sus carpetas `images/`.
* **Archivos del sistema:** BIOS completas, temas de EmulationStation y música ambiental.

---

### Para usar la MicroSD exclusivamente con los juegos (en cualquier momento):
Ejecuta en tu terminal:
```bash
cd /home/dev-jonathan/Escritorio/R35_Ultra
./formatear_y_copiar.sh
```
Esto formateará la MicroSD en FAT32 con el nombre `ROMS` y copiará los 18 GB automáticamente para jugar con el sistema de fábrica.
