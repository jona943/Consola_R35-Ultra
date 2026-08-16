#!/bin/bash
set -e

IMG_PATH="/home/dev-jonathan/Escritorio/R35_Ultra/ArkOS_R35S-R36S_v2.0_MultiPanel.img"
TARGET_DEV="/dev/sdb"

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No se encuentra la imagen en $IMG_PATH"
    exit 1
fi

echo "=========================================================="
echo "  FLASHEADOR OFICIAL ARKOS 2.0 (R35 / R36S)"
echo "=========================================================="
echo "Origen: $IMG_PATH (7.58 GB)"
echo "Destino: $TARGET_DEV (MicroSD 48.8 GB)"
echo "=========================================================="
echo ""

echo "[1/2] Desmontando particiones activas en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/2] Grabando imagen en $TARGET_DEV a alta velocidad (bloques de 8MB)..."
echo "Por favor espera mientras se transfieren los bloques y se sincroniza la memoria flash..."
echo ""

sudo dd if="$IMG_PATH" of="$TARGET_DEV" bs=8M status=progress conv=fsync

echo ""
echo "=========================================================="
echo "  ¡FLASHEO COMPLETADO CON ÉXITO!"
echo "=========================================================="
echo ""
echo "SIGUIENTES PASOS:"
echo "1. Expulsa y retira la MicroSD de la PC e insértala en tu consola."
echo "2. Enciende la consola: ArkOS expandirá automáticamente el almacenamiento."
echo "3. Apágala de forma segura (Start -> Quit -> Shutdown)."
echo "4. Reconéctala a la PC para transferir la carpeta 'copia_r35Ultra' a EASYROMS."
echo "=========================================================="
