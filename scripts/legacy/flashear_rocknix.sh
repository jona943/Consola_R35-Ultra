#!/bin/bash
set -e

IMG_PATH="/home/dev-jonathan/Escritorio/R35_Ultra/ROCKNIX-RK3326.img"
TARGET_DEV="/dev/sdb"

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No se encuentra la imagen en $IMG_PATH"
    exit 1
fi

echo "=========================================================="
echo "  FLASHEADOR OFICIAL ROCKNIX 2026 (RK3326 / R35 ULTRA)"
echo "=========================================================="
echo "Origen: $IMG_PATH (2.1 GB)"
echo "Destino: $TARGET_DEV (MicroSD 48.8 GB)"
echo "=========================================================="
echo ""

echo "[1/2] Desmontando particiones activas en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/2] Grabando imagen ROCKNIX a bajo nivel..."
sudo dd if="$IMG_PATH" of="$TARGET_DEV" bs=8M status=progress conv=fsync

echo ""
echo "=========================================================="
echo "  ¡FLASHEO DE ROCKNIX COMPLETADO EXITOSAMENTE!"
echo "=========================================================="
echo ""
echo "SIGUIENTES PASOS:"
echo "1. Retira la MicroSD de tu PC e insértala en tu consola R35 Ultra."
echo "2. Enciende la consola: ROCKNIX autodectará tu pantalla y expandirá el almacenamiento."
echo "3. Espera 1-2 minutos hasta que cargue la interfaz principal."
echo "=========================================================="
