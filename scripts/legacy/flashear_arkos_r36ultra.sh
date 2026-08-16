#!/bin/bash
set -e

IMG_PATH="/home/dev-jonathan/Escritorio/R35_Ultra/ArkOS_R35S-R36S_v2.0_MultiPanel.img"
TARGET_DEV="/dev/sdb"
DTB_DIR="/home/dev-jonathan/Escritorio/R35_Ultra/dtb_r36ultra"

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No se encuentra la imagen en $IMG_PATH"
    exit 1
fi

echo "=========================================================="
echo "  FLASHEADOR OFICIAL ARKOS PARA R36/R35 ULTRA (2026)"
echo "=========================================================="
echo "Origen: $IMG_PATH (7.58 GB)"
echo "Destino: $TARGET_DEV (MicroSD)"
echo "DTB Dedicado: rk3326-r36ultra-linux.dtb (Fix de energía + pantalla)"
echo "=========================================================="
echo ""

echo "[1/3] Desmontando particiones activas en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/3] Grabando imagen ArkOS a bajo nivel en $TARGET_DEV..."
sudo dd if="$IMG_PATH" of="$TARGET_DEV" bs=8M status=progress conv=fsync
sleep 2

echo "[3/3] Aplicando DTB y configuración de energía específica para R36/R35 Ultra..."
MOUNT_DIR="/media/dev-jonathan/BOOT"
sudo mkdir -p "$MOUNT_DIR"
sudo mount "${TARGET_DEV}1" "$MOUNT_DIR"

sudo cp "$DTB_DIR/rk3326-r36ultra-linux.dtb" "$MOUNT_DIR/rk3326-r36ultra-linux.dtb"
sudo cp "$DTB_DIR/rk3326-r36ultrax-linux.dtb" "$MOUNT_DIR/rk3326-r36ultrax-linux.dtb"
sudo cp "$DTB_DIR/boot.ini" "$MOUNT_DIR/boot.ini"

echo "Sincronizando y desmontando..."
sync
sudo umount "$MOUNT_DIR"

echo ""
echo "=========================================================="
echo "  ¡FLASHEO Y PARCHE DE R36 ULTRA APLICADO CON ÉXITO!"
echo "=========================================================="
echo "Ya puedes retirar la MicroSD e insertarla en tu consola."
echo "=========================================================="
