#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/images/ROCKNIX/ROCKNIX-RK3326-b.img" ]; then
    IMG_PATH="$SCRIPT_DIR/images/ROCKNIX/ROCKNIX-RK3326-b.img"
elif [ -f "$SCRIPT_DIR/../images/ROCKNIX/ROCKNIX-RK3326-b.img" ]; then
    IMG_PATH="$SCRIPT_DIR/../images/ROCKNIX/ROCKNIX-RK3326-b.img"
else
    IMG_PATH="/home/dev-jonathan/Escritorio/R35_Ultra/ROCKNIX-RK3326-b.img"
fi
TARGET_DEV="/dev/sdb"

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No se encuentra la imagen en $IMG_PATH"
    exit 1
fi

echo "=========================================================="
echo "  FLASHEADOR OFICIAL ROCKNIX 2026 (IMAGEN B - EE-CLONES)"
echo "=========================================================="
echo "Origen: $IMG_PATH (2.05 GB - Edición para Clones con Panel Secundario)"
echo "Destino: $TARGET_DEV (MicroSD 48.8 GB)"
echo "=========================================================="
echo ""

echo "[1/2] Desmontando particiones activas en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/2] Grabando imagen ROCKNIX (Edición B) a bajo nivel con sincronización..."
sudo dd if="$IMG_PATH" of="$TARGET_DEV" bs=8M status=progress conv=fsync

echo ""
echo "=========================================================="
echo "  ¡FLASHEO DE LA IMAGEN B COMPLETADO EXITOSAMENTE!"
echo "=========================================================="
echo ""
echo "SIGUIENTES PASOS:"
echo "1. Retira la MicroSD de la PC e insértala en tu consola R35 Ultra."
echo "2. Enciende la consola: La Imagen B inicializará el panel secundario y el brillo PWM."
echo "3. Espera 1 a 2 minutos hasta ver la pantalla de inicio de ROCKNIX."
echo "=========================================================="
