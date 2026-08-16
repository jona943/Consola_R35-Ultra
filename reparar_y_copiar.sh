#!/bin/bash
set -e

TARGET_PART="/dev/sdb2"
MOUNT_DIR="/media/dev-jonathan/STORAGE"
SRC_DIR="/home/dev-jonathan/Escritorio/R35_Ultra/copia_r35Ultra"

echo "=========================================================="
echo "  REPARACIÓN DE PARTICIÓN Y TRANSFERENCIA DE JUEGOS"
echo "=========================================================="
echo ""

echo "[1/4] Desmontando $TARGET_PART para verificar y reparar el sistema de archivos..."
sudo umount "$TARGET_PART" 2>/dev/null || true
sleep 1

echo "Ejecutando comprobación e2fsck..."
sudo e2fsck -fy "$TARGET_PART" || true
sleep 1

echo "[2/4] Montando $TARGET_PART en $MOUNT_DIR en modo lectura/escritura..."
sudo mkdir -p "$MOUNT_DIR"
sudo mount -o rw "$TARGET_PART" "$MOUNT_DIR"
sudo chmod -R 777 "$MOUNT_DIR"

echo "[3/4] Transfiriendo consolas y juegos a /storage/roms/ (con reanudación)..."
sudo mkdir -p "$MOUNT_DIR/roms"

for console in cps1 cps2 cps3 dreamcast gamegear gb gba gbc mame megadrive n64 nds neogeo nes pcengine ports psp psx snes; do
    if [ -d "$SRC_DIR/$console" ]; then
        echo " -> Sincronizando $console..."
        sudo rsync -rh --info=progress2 "$SRC_DIR/$console" "$MOUNT_DIR/roms/"
    fi
done

echo "[4/4] Sincronizando BIOS, temas y música de fondo..."
sudo mkdir -p "$MOUNT_DIR/roms/bios" "$MOUNT_DIR/bios" "$MOUNT_DIR/.emulationstation/themes" "$MOUNT_DIR/music"
sudo rsync -rh --info=progress2 "$SRC_DIR/bios/" "$MOUNT_DIR/roms/bios/"
sudo rsync -rh --info=progress2 "$SRC_DIR/bios/" "$MOUNT_DIR/bios/"
sudo rsync -rh --info=progress2 "$SRC_DIR/themes/" "$MOUNT_DIR/.emulationstation/themes/"
sudo rsync -rh --info=progress2 "$SRC_DIR/BGM/" "$MOUNT_DIR/music/"

sudo chmod -R 777 "$MOUNT_DIR"

echo ""
echo "Sincronizando memoria física (sync)..."
sync

echo ""
echo "=========================================================="
echo "  ¡TODOS LOS JUEGOS Y ARCHIVOS QUEDARON COPIADOS AL 100%!"
echo "=========================================================="
echo "Ya puedes retirar la MicroSD e insertarla en tu consola."
echo "=========================================================="
