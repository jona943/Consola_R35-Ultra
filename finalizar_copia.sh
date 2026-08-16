#!/bin/bash
set -e

MOUNT_DIR="/media/dev-jonathan/STORAGE"
SRC_DIR="/home/dev-jonathan/Escritorio/R35_Ultra/copia_r35Ultra"

echo "=========================================================="
echo "  FINALIZACIÓN DE BIOS, TEMAS Y MÚSICA (ROCKNIX)"
echo "=========================================================="
echo ""

echo "[1/3] Copiando BIOS oficiales completas..."
sudo mkdir -p "$MOUNT_DIR/roms/bios" "$MOUNT_DIR/bios"
sudo cp -r "$SRC_DIR/bios/"* "$MOUNT_DIR/roms/bios/"
sudo cp -r "$SRC_DIR/bios/"* "$MOUNT_DIR/bios/"

echo "[2/3] Copiando temas y música ambiental..."
sudo mkdir -p "$MOUNT_DIR/.config/emulationstation/themes" "$MOUNT_DIR/music"
sudo cp -r "$SRC_DIR/themes/"* "$MOUNT_DIR/.config/emulationstation/themes/"
sudo cp -r "$SRC_DIR/BGM/"* "$MOUNT_DIR/music/"

sudo chmod -R 777 "$MOUNT_DIR"

echo "[3/3] Sincronizando memoria flash física (sync)..."
sync

echo ""
echo "=========================================================="
echo "  ¡TODO ESTÁ 100% LISTO Y COPIADO EN TU MICROSD!"
echo "=========================================================="
echo "Ya puedes retirar la tarjeta e insertarla en tu consola R35 Ultra."
echo "=========================================================="
