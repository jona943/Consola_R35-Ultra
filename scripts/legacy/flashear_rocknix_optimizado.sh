#!/bin/bash
set -e

IMG_PATH="/home/dev-jonathan/Escritorio/R35_Ultra/ROCKNIX-RK3326.img"
TARGET_DEV="/dev/sdb"

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No se encuentra la imagen en $IMG_PATH"
    exit 1
fi

echo "=========================================================="
echo "  FLASHEADOR OFICIAL ROCKNIX 2026 (R35 ULTRA OPTIMIZADO)"
echo "=========================================================="
echo "Origen: $IMG_PATH (2.05 GB)"
echo "Destino: $TARGET_DEV (MicroSD 48.8 GB)"
echo "DTB Asignado: rk3326-batlexp-g350.dtb (R35 / G350 MIPI Display)"
echo "=========================================================="
echo ""

echo "[1/3] Desmontando particiones activas en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/3] Grabando imagen ROCKNIX a bajo nivel..."
sudo dd if="$IMG_PATH" of="$TARGET_DEV" bs=8M status=progress conv=fsync
sleep 2

echo "[3/3] Configurando parámetros de pantalla en extlinux.conf..."
MOUNT_DIR="/media/dev-jonathan/ROCKNIX"
sudo mkdir -p "$MOUNT_DIR"
sudo mount "${TARGET_DEV}1" "$MOUNT_DIR"

cat << 'EOF' | sudo tee "$MOUNT_DIR/extlinux/extlinux.conf" > /dev/null
LABEL ROCKNIX
  LINUX /KERNEL
  FDT /rk3326-batlexp-g350.dtb
  APPEND boot=${partition_boot} disk=${partition_storage} quiet console=ttyS2,1500000 console=tty0 systemd.debug_shell=ttyS2 uboot.hwid_adc=${hwid_adc} video=DSI-1:640x480@60
EOF

echo "Configuración aplicada:"
cat "$MOUNT_DIR/extlinux/extlinux.conf"
echo ""

echo "Sincronizando y desmontando..."
sync
sudo umount "$MOUNT_DIR"

echo ""
echo "=========================================================="
echo "  ¡FLASHEO Y CONFIGURACIÓN COMPLETADOS CON ÉXITO!"
echo "=========================================================="
echo "Ya puedes retirar la MicroSD e insertarla en tu consola."
echo "=========================================================="
