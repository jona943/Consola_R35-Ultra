#!/bin/bash
set -e

SRC_DIR="/home/dev-jonathan/Escritorio/R35_Ultra/copia_r35Ultra"
TARGET_DEV="/dev/sdb"
TARGET_PART="${TARGET_DEV}1"

if [ ! -d "$SRC_DIR" ]; then
    echo "Error: No se encuentra el directorio origen en $SRC_DIR"
    exit 1
fi

echo "=========================================================="
echo "  FORMATEO Y TRANSFERENCIA DE JUEGOS CURADOS (R35 ULTRA)"
echo "=========================================================="
echo "Origen: $SRC_DIR (18 GB - 1.669 juegos + BIOS + Portadas HD)"
echo "Destino: $TARGET_DEV (MicroSD 48.8 GB)"
echo "=========================================================="
echo ""

echo "[1/4] Desmontando particiones en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/4] Creando tabla de particiones MBR y partición única..."
sudo parted -s "$TARGET_DEV" mklabel msdos mkpart primary fat32 1MiB 100%
sleep 1

echo "[3/4] Formateando $TARGET_PART en FAT32 con etiqueta 'ROMS'..."
sudo mkfs.vfat -F 32 -n "ROMS" "$TARGET_PART"
sleep 1

# Mount using a clean mountpoint
MOUNT_DIR="/media/dev-jonathan/ROMS"
sudo mkdir -p "$MOUNT_DIR"
sudo mount "$TARGET_PART" "$MOUNT_DIR"
sudo chown -R dev-jonathan:dev-jonathan "$MOUNT_DIR"

echo "[4/4] Copiando los 18 GB de juegos curados, BIOS y carátulas..."
echo "Iniciando transferencia de alta velocidad..."
echo ""

rsync -rh --info=progress2 "$SRC_DIR/" "$MOUNT_DIR/"

echo ""
echo "Sincronizando memoria flash..."
sync

echo ""
echo "=========================================================="
echo "  ¡TRANSFERENCIA COMPLETADA EXITOSAMENTE!"
echo "=========================================================="
echo ""
echo "La MicroSD ya contiene:"
echo "  - 1.669 juegos curados organizados por consola"
echo "  - BIOS de emuladores (PS1, Dreamcast, MAME, etc.)"
echo "  - Temas y música de fondo"
echo "  - Carátulas oficiales enlazadas en gamelist.xml"
echo ""
echo "Ya puedes retirar la tarjeta e insertarla en tu consola."
echo "=========================================================="
