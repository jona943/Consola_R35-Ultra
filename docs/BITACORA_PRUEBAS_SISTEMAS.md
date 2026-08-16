# Bitácora Exhaustiva de Pruebas de Sistemas Operativos (R35 Ultra)

Este documento detalla cada una de las pruebas de sistemas operativos realizadas en la consola **R35 Ultra (2025/2026)**, los síntomas observados (comportamiento del LED indicador, pantalla y energía), el diagnóstico técnico de la falla y la solución definitiva alcanzada.

---

## Diagnóstico del Hardware y Causa Raíz

* **Dispositivo:** R35 Ultra (adquirida en febrero de 2026, placa de finales de 2025).
* **SoC:** Rockchip RK3326 (ARM Cortex-A35 @ 1.5 GHz).
* **El Problema Fundamental:** La placa base monta un circuito integrado de administración de energía (**PMIC**) y reguladores de voltaje modernos de 2025. Los sistemas operativos de la comunidad retro construidos sobre el **Kernel Linux 4.4 legacy** (2018–2021) no poseen los controladores I2C para negociar los voltajes con este PMIC. Como mecanismo de protección por hardware contra sobrecalentamiento/cortocircuito, la consola corta la energía y entra en modo de alerta (**LED Rojo Parpadeante**).

---

## Bitácora Detallada de Pruebas

### [Fallo] Prueba 1: ArkOS 2.0 MultiPanel (Kernel Linux 4.4)
* **Imagen:** `ArkOS_R35S-R36S_v2.0_MultiPanel.img` (7.58 GB).
* **Configuración:** DTB por defecto (`rk3326-r35s-linux.dtb`).
* **Comportamiento:** Al pulsar el botón de encendido, la pantalla permanece completamente negra y el **LED parpadea en rojo**.
* **Diagnóstico:** El Kernel 4.4 no inicializa el PMIC 2025. Corte de energía por seguridad del hardware.

---

### [Fallo] Prueba 2: ArkOS MultiPanel (Panel 4 y Panel 5)
* **Configuración:** Reemplazo de DTBs por `rk3326-r35s-linux.dtb` (Panel 4) y `Panel 5` con kernel personalizado de la comunidad.
* **Comportamiento:** **LED parpadea en rojo** de inmediato.
* **Diagnóstico:** La incompatibilidad no reside en el panel de la pantalla sino en la capa de energía del Kernel 4.4.

---

### [Fallo] Prueba 3: ArkOS4Clone (`lcdyk0517/arkos4clone`)
* **Configuración:** Árbol dedicado `rk3326-r36ultra-linux.dtb` y archivo [`boot.ini.arkos4clone`](../config_samples/boot.ini.arkos4clone) con ajuste de frecuencias (`max_cpufreq=1296`, `max_ddrfreq=666`).
* **Comportamiento:** **LED parpadea en rojo**. Pantalla apagada.
* **Diagnóstico:** Confirma de forma concluyente que **ningún build de ArkOS basado en Linux 4.4 puede energizar esta revisión de placa 2025/2026**.

---

### [Fallo] Prueba 4: AmberELEC (Edición RG351MP / aarch64)
* **Imagen:** `AmberELEC-RG351MP.aarch64-20230203.img.gz` (2.05 GB descomprimido).
* **Configuración:** Build de AmberELEC basado en JeOS 64 bits con U-Boot dedicado.
* **Comportamiento:** **LED parpadea en rojo**.
* **Diagnóstico:** Aunque AmberELEC usa binarios `aarch64`, su kernel base para RK3326 continúa siendo la rama 4.4 de Rockchip, sufriendo el mismo bloqueo de PMIC.

---

### [Hardware OK] Prueba 5: ROCKNIX - Imagen "A" (Kernel Linux 6.x Mainline)
* **Imagen:** `ROCKNIX-RK3326.aarch64-20260801-a.img.gz` con `rk3326-gameconsole-eeclone.dtb`.
* **Comportamiento:** **¡LED AZUL SÓLIDO!** (Sin parpadeo rojo, sin corte de energía). La pantalla permanece en negro.
* **Diagnóstico:** * **¡Éxito de Hardware!** El Kernel Linux 6.x moderno energizó la placa a la perfección, ejecutó los scripts de inicio y expandió la partición a 46.4 GB en segundo plano (`fs-resize.log`).
  * **Falla de Pantalla:** La Imagen "A" está compilada para consolas de marca comercial (Anbernic) que usan el bus de video primario (DSI0).

---

### [Exito] Prueba 6: ROCKNIX - Imagen "B" para Clones (SOLUCIÓN DEFINITIVA)
* **Imagen:** `ROCKNIX-RK3326.aarch64-20260801-b.img.gz` (Edición oficial para consolas clones EE-Clones / K36 / R35 Ultra / R36Max).
* **Configuración:** Mapeo de pantalla MIPI secundaria y control de brillo PWM (`mipi-panel.dtbo`).
* **Comportamiento:** **¡100% FUNCIONAL!**
  * **LED Azul Sólido encendido.**
  * **Pantalla inicializada con imagen nítida a 60 FPS y control de brillo activo.**
  * **Sistema operativo cargando EmulationStation y núcleos de 64 bits a máxima velocidad.**

---

## Ajustes Post-Instalación Aplicados

1. **Limpieza del arranque ([`extlinux.conf.rocknix_clean`](../config_samples/extlinux.conf.rocknix_clean)):**
   * Se removió `systemd.debug_shell=ttyS2` para eliminar el mensaje cosmético `[FAILED] Failed to start debug-shell.service`.
2. **Ruta de juegos en ROCKNIX ([`system-dirs.conf.rocknix`](../config_samples/system-dirs.conf.rocknix)):**
   * En sistemas con una sola tarjeta MicroSD, ROCKNIX lee los juegos en **`/storage/games-internal/roms/`**. Se trasladaron los 1.669 juegos a esta ruta con permisos `0777`.
