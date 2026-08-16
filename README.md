# Repositorio R35 Ultra (2025/2026)

Este repositorio contiene la memoria tecnica, colecciones curadas de juegos, imagenes de sistemas operativos, configuraciones de referencia y scripts de automatizacion para la consola portatil R35 Ultra (Rockchip RK3326 / EE-Clone).

---

## Estructura del Repositorio

```
Consola_R35-Ultra/
├── README.md                              <- Este documento (Guia de acceso rapido)
├── MEMORIA_TECNICA_PROYECTO_R35_ULTRA.md  <- Memoria tecnica maestra integral
│
├── docs/                                  <- Documentacion tecnica y bitacoras
│   ├── BITACORA_PRUEBAS_SISTEMAS.md       <- Registro detallado de pruebas de OS
│   ├── GUIA_MIGRACION_Y_SISTEMAS_R35_ULTRA.md
│   └── DIAGNOSTICO_Y_PLAN_LIMPIEZA.md
│
├── config_samples/                        <- Ejemplos de configuracion y plantillas
│   ├── README.md
│   ├── extlinux.conf.rocknix_clean
│   ├── extlinux.conf.original_with_debug
│   ├── 001-device_config.audio_fix
│   ├── custom_start.sh.audio_fix
│   ├── es_settings.cfg.audio_fix
│   ├── boot.ini.arkos4clone
│   ├── system-dirs.conf.rocknix
│   └── gamelist.xml.sample
│
├── scripts/                               <- Scripts de automatizacion
│   ├── corregir_rutas_y_arranque.sh       <- Asigna ROMs a games-internal y limpia inicio
│   ├── activar_audio_r35ultra.sh          <- Calibra amplificador y activa altavoz RK817
│   ├── flashear_rocknix_b.sh              <- Flasheador oficial ROCKNIX (Imagen B)
│   ├── finalizar_copia.sh                 <- Sincroniza BIOS, temas y musica
│   ├── reparar_y_copiar.sh                <- Reparacion ext4 y transferencia con rsync
│   ├── formatear_y_copiar.sh              <- Formateador FAT32 para OS de fabrica
│   └── legacy/                            <- Scripts de pruebas anteriores
│
├── images/                                <- Imagenes de sistemas operativos
│   ├── ROCKNIX/                           <- ROCKNIX-RK3326-b.img (Ganador 100%)
│   ├── AmberELEC/                         <- AmberELEC-RG351MP.img
│   └── ArkOS/                             <- ArkOS MultiPanel
│
├── copia_r35Ultra/                        <- Coleccion curada de 18 GB (1.669 juegos + portadas HD)
└── dtb_r36ultra/                          <- Arboles de dispositivos de respaldo
```

---

## Comandos Rapidos

### 1. Activar juegos y limpiar arranque:
```bash
./corregir_rutas_y_arranque.sh
```

### 2. Calibrar y desmutear audio (Codec RK817):
```bash
./activar_audio_r35ultra.sh
```

### 3. Flashear ROCKNIX desde cero a una nueva MicroSD:
```bash
./flashear_rocknix_b.sh
```

### 4. Copiar BIOS, Temas y Musica:
```bash
./finalizar_copia.sh
```

---

## Resumen Tecnico del Hardware:
* Sistema Oficial Compatible: ROCKNIX (Imagen B - Linux 6.x Mainline).
* Audio: Codec Rockchip RK817 configurado en modo directo SPK (Legacy) y custom_start.sh.
* Video: Bus secundario MIPI DSI con control de brillo PWM habilitado.
* Motivo de compatibilidad: Los sistemas con Kernel 4.4 (ArkOS / AmberELEC) disparan el corte de energia por proteccion (LED Rojo). El Kernel 6.x moderno de ROCKNIX energiza la placa al 100% (LED Azul).
