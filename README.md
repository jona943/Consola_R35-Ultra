# Repositorio R35 Ultra (2025/2026)

Este repositorio contiene la memoria técnica, colecciones curadas de juegos, imágenes de sistemas operativos y scripts de automatización para la consola portátil **R35 Ultra (Rockchip RK3326 / EE-Clone)**.

---

## Estructura del Repositorio

```
R35_Ultra/
├── README.md                              <- Este documento (Guía de acceso rápido)
├── MEMORIA_TECNICA_PROYECTO_R35_ULTRA.md  <- Memoria técnica maestra integral
│
├── docs/                                  <- Documentación técnica y bitácoras
│   ├── BITACORA_PRUEBAS_SISTEMAS.md       <- Registro detallado de pruebas de OS
│   ├── GUIA_MIGRACION_Y_SISTEMAS_R35_ULTRA.md
│   └── DIAGNOSTICO_Y_PLAN_LIMPIEZA.md
│
├── scripts/                               <- Scripts de automatización
│   ├── corregir_rutas_y_arranque.sh       <- Asigna ROMs a games-internal y limpia inicio
│   ├── flashear_rocknix_b.sh              <- Flasheador oficial ROCKNIX (Imagen B)
│   ├── finalizar_copia.sh                 <- Sincroniza BIOS, temas y música
│   ├── reparar_y_copiar.sh                <- Reparación ext4 y transferencia con rsync
│   ├── formatear_y_copiar.sh              <- Formateador FAT32 para OS de fábrica
│   └── legacy/                            <- Scripts de pruebas anteriores
│
├── images/                                <- Imágenes de sistemas operativos
│   ├── ROCKNIX/                           <- ROCKNIX-RK3326-b.img (Ganador 100%)
│   ├── AmberELEC/                         <- AmberELEC-RG351MP.img
│   └── ArkOS/                             <- ArkOS MultiPanel
│
├── copia_r35Ultra/                        <- Colección curada de 18 GB (1.669 juegos + portadas HD)
└── dtb_r36ultra/                          <- Árboles de dispositivos de respaldo
```

---

## Comandos Rápidos

### 1. Activar juegos y limpiar arranque (Uso actual):
```bash
./corregir_rutas_y_arranque.sh
```

### 2. Flashear ROCKNIX desde cero a una nueva MicroSD:
```bash
./flashear_rocknix_b.sh
```

### 3. Copiar BIOS, Temas y Música:
```bash
./finalizar_copia.sh
```

---

## Resumen Técnico del Hardware:
* **Sistema Oficial Compatible:** **`ROCKNIX (Imagen B - Linux 6.x Mainline)`**.
* **Motivo:** Los sistemas con Kernel 4.4 (ArkOS / AmberELEC) disparan el corte de energía por protección (**LED Rojo**). El Kernel 6.x moderno de ROCKNIX energiza la placa al 100% (**LED Azul**) y la Imagen B habilita el bus de pantalla MIPI secundario y el control de brillo PWM.
