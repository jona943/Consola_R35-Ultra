# Investigacion de Hardware y Activacion de Wi-Fi Nativo RK915 en ROCKNIX

Este documento detalla el proceso de ingenieria inversa, diagnostico a nivel de bus de hardware y resolucion de problemas para el adaptador de red inalámbrico en la consola **R35 Ultra** ejecutando **ROCKNIX (Linux 6.12.79 aarch64)**.

---

## 1. El Problema Inicial

Al arrancar ROCKNIX de forma estandar:
1. **La antena interna Wi-Fi no aparecia en el sistema:** El comando `ip link` y `iw dev` no mostraban la interfaz `wlan0`.
2. **Los adaptadores USB Wi-Fi externos no encendian:** Al conectar un dongle USB-C OTG pasivo (como el Realtek RTL8188EUS), el LED del dongle permanecia apagado sin recibir alimentacion electrica.
3. **Error de direccion IP virtual (10.63.192.82):** El demonio de red `iwd` caia en modo de emergencia P2P/Wi-Fi Direct al no poder enlazar con el router local por falta de configuracion IPv4.

---

## 2. Ingenieria Inversa del Device Tree (.dtb)

Al decompilar y comparar el archivo `rk3326-gameconsole-eeclone.dtb` de ROCKNIX contra el arbol de dispositivos original de fabrica (`rk3326-r36ultra-linux.dtb`), se descubrieron dos anomalias criticas de configuracion:

### A. Puerto USB-C OTG sin Suministro de 5V VBUS
* **Causa:** En el DTB de ROCKNIX, el nodo del controlador USB `usb@ff300000` operaba en modo `otg` generico sin la propiedad `vbus-supply`, dejando el pin `GPIO3_A4` (regulador `vcc_host`) sin activar.
* **Solucion Aplicada:** Se forzo `dr_mode = "host";` y se enlazo `vbus-supply = <&vcc_host>;`, garantizando 5 Voltios obligatorios en el puerto OTG para cualquier accesorio pasivo.

### B. Bus SDIO Interno (`mmc@ff380000`) Asignado a Ranura Falsa TF2
* **Causa:** El DTB de ROCKNIX estaba disenado para consolas clonicas R36S de 2 ranuras MicroSD, asignando el bus `mmc2` a una deteccion de tarjeta plastica (`cd-gpios`, `supports-sd;`). Al no detectar una segunda MicroSD en la ranura inexistente, el bus permanrecia apagado a 0V.
* **Solucion Aplicada:** Se elimino `cd-gpios` y se reconfiguro el bus como **SDIO interno no extraible**:
  ```dts
  mmc@ff380000 {
      supports-sdio;
      no-sd;
      no-mmc;
      non-removable;
      keep-power-in-suspend;
      status = "okay";
  };
  ```

---

## 3. Descubrimiento y Deteccion del Chip Fisico en el Bus SDIO

Tras compilar e instalar el nuevo DTB corregido, el bus `mmc2` energizo el circuito integrado soldado en la placa madre, respondiendo con los siguientes identificadores de hardware verificados por sysfs:

```
SDIO_ID=0296:5348
MODALIAS=sdio:c00v0296d5348
Vendor ID: 0x0296 (Rockchip / GCT Semiconductor)
Device ID: 0x5348 (Modelo Oficial RK915)
Dispositivos Enumerados:
  ├── mmc2:0001:1 -> Interfaz WLAN Wi-Fi 802.11 b/g/n
  └── mmc2:0001:2 -> Interfaz Bluetooth HCI
```

---

## 4. Estado Actual y Hoja de Ruta para el Driver rk915.ko

* **Estado de Hardware:** **100% Funcional y Enumerado.** El silicio RK915 recibe energia y se comunica en el bus SDIO a 50 MHz.
* **Estado de Software:** El kernel `Linux 6.12.79` de ROCKNIX carece del modulo compilado `rk915.ko` (originario de los kernels BSP de Rockchip Linux 4.4/5.10).
* **Objetivo Inmediato:** Obtener el codigo fuente del driver `rkwifi` / `rk915` adaptado para la API de red `cfg80211` de Linux 6.x o compilar el modulo `aarch64` para cargarlo dinamicamente desde `/storage/.config/modules/`.

---

*Documento técnico de ingenieria inversa para la consola R35 Ultra (2025/2026).*
