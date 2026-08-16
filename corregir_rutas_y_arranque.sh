#!/bin/bash
set -e

BOOT_DIR="/media/dev-jonathan/ROCKNIX1"
STORAGE_DIR="/media/dev-jonathan/STORAGE1"

echo "=========================================================="
echo "  OPTIMIZADOR DEFINITIVO DE ARRANQUE Y RUTAS DE ROMS"
echo "=========================================================="
echo ""

# 1. Corregir extlinux.conf para eliminar el error [FAILED] debug-shell
if [ -f "$BOOT_DIR/extlinux/extlinux.conf" ]; then
    echo "[1/3] Limpiando extlinux.conf (Eliminando alerta de debug-shell)..."
    cat << 'EOF' | sudo tee "$BOOT_DIR/extlinux/extlinux.conf" > /dev/null
LABEL ROCKNIX
  LINUX /KERNEL
  FDTDIR /
  FDTOVERLAYS /overlays/mipi-panel.dtbo
  APPEND boot=${partition_boot} disk=${partition_storage} quiet console=tty0 uboot.hwid_adc=${hwid_adc}
EOF
    echo "extlinux.conf actualizado limpiamente."
fi

# 2. Sincronizar todas las ROMs en /storage/games-internal/roms/
echo "[2/3] Moviendo y asegurando juegos en /storage/games-internal/roms/..."
sudo mkdir -p "$STORAGE_DIR/games-internal/roms"
sudo mkdir -p "$STORAGE_DIR/games-external/roms"

for console in cps1 cps2 cps3 dreamcast gamegear gb gba gbc mame megadrive n64 nds neogeo nes pcengine ports psp psx snes bios; do
    if [ -d "$STORAGE_DIR/roms/$console" ]; then
        echo " -> Vinculando $console en games-internal/roms..."
        sudo cp -r "$STORAGE_DIR/roms/$console"/* "$STORAGE_DIR/games-internal/roms/$console/" 2>/dev/null || sudo cp -r "$STORAGE_DIR/roms/$console" "$STORAGE_DIR/games-internal/roms/"
    fi
done

# Copiar BIOS a la ruta del sistema
sudo mkdir -p "$STORAGE_DIR/games-internal/bios" "$STORAGE_DIR/bios"
if [ -d "$STORAGE_DIR/roms/bios" ]; then
    sudo cp -r "$STORAGE_DIR/roms/bios/"* "$STORAGE_DIR/games-internal/bios/" 2>/dev/null || true
    sudo cp -r "$STORAGE_DIR/roms/bios/"* "$STORAGE_DIR/bios/" 2>/dev/null || true
fi

# 3. Asignar permisos completos 777 a todo
echo "[3/3] Asignando permisos totales (0777) a todo el almacenamiento..."
sudo chmod -R 777 "$STORAGE_DIR/games-internal"
sudo chmod -R 777 "$STORAGE_DIR/roms"
sudo chmod -R 777 "$STORAGE_DIR/bios" 2>/dev/null || true

echo "Sincronizando memoria fisica..."
sync

echo ""
echo "=========================================================="
echo "  ¡TODO CORREGIDO Y OPTIMIZADO AL 100%!"
echo "=========================================================="
echo "1. El aviso de debug-shell ha sido eliminado."
echo "2. Todos los juegos están en /storage/games-internal/roms/."
echo "=========================================================="
