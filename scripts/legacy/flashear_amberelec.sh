#!/bin/bash
set -e

IMG_PATH="/home/dev-jonathan/Escritorio/R35_Ultra/AmberELEC-RG351MP.img"
TARGET_DEV="/dev/sdb"

if [ ! -f "$IMG_PATH" ]; then
    echo "Error: No se encuentra la imagen en $IMG_PATH"
    exit 1
fi

echo "=========================================================="
echo "  FLASHEADOR OFICIAL AMBERELEC (RG351MP / RK3326)"
echo "=========================================================="
echo "Origen: $IMG_PATH (2.05 GB)"
echo "Destino: $TARGET_DEV (MicroSD 48.8 GB)"
echo "=========================================================="
echo ""

echo "[1/2] Desmontando particiones activas en $TARGET_DEV..."
sudo umount ${TARGET_DEV}* 2>/dev/null || true
sleep 1

echo "[2/2] Grabando imagen AmberELEC a bajo nivel con sincronización..."
sudo dd if="$IMG_PATH" of="$TARGET_DEV" bs=8M status=progress conv=fsync

echo ""
echo "=========================================================="
echo "  ¡FLASHEO DE AMBERELEC COMPLETADO EXITOSAMENTE!"
echo "=========================================================="
echo ""
echo "SIGUIENTES PASOS:"
echo "1. Retira la MicroSD de la PC e insértala en tu consola."
echo "2. Enciende la consola: AmberELEC expandirá el almacenamiento y cargará EmulationStation."
echo "3. Espera 1 a 2 minutos hasta ver la interfaz en pantalla."
echo "=========================================================="
