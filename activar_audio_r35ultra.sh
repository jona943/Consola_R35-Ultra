#!/bin/bash
set -e

STORAGE_DIR="/media/dev-jonathan/STORAGE1"

if [ ! -d "$STORAGE_DIR" ]; then
    echo "Error: La particion STORAGE1 no esta montada en $STORAGE_DIR"
    exit 1
fi

echo "=========================================================="
echo "  ACTIVADOR DE AUDIO Y AMPLIFICADOR PARA R35 ULTRA"
echo "=========================================================="
echo ""

# 1. Configurar profile.d para modo de audio Legacy SPK
echo "[1/4] Configurando perfil de audio por hardware en profile.d..."
cat << 'EOF' | sudo tee "$STORAGE_DIR/.config/profile.d/001-device_config" > /dev/null
# Device Features
DEVICE_BATTERY_LED_STATUS="true"
DEVICE_TEMP_SENSOR="/sys/devices/virtual/thermal/thermal_zone0/temp"

# Enable legacy direct audio routing for clone boards (SPK amplifier)
AUDIO_MANAGEMENT=legacy
EOF

cat << 'EOF' | sudo tee "$STORAGE_DIR/.config/profile.d/002-audio_path" > /dev/null
DEVICE_PLAYBACK_PATH="SPK"
EOF

# 2. Crear custom_start.sh para inicializar el amplificador rk817 al encender
echo "[2/4] Creando script de inicio automatico de audio (custom_start.sh)..."
cat << 'EOF' | sudo tee "$STORAGE_DIR/.config/custom_start.sh" > /dev/null
#!/bin/bash
# Activador de amplificador y canales ALSA para RK3326 EE-Clones
sleep 1
amixer sset 'Playback Path' 'SPK' 2>/dev/null || amixer sset 'Playback Path' 'Speaker' 2>/dev/null || true
amixer sset 'Master' 95% unmute 2>/dev/null || true
amixer sset 'Playback' 95% unmute 2>/dev/null || true
amixer sset 'Speaker' 95% unmute 2>/dev/null || true
amixer sset 'Headphone' 95% unmute 2>/dev/null || true
amixer sset 'Digital' 95% unmute 2>/dev/null || true
EOF
sudo chmod +x "$STORAGE_DIR/.config/custom_start.sh"

# 3. Configurar es_settings.cfg de EmulationStation
echo "[3/4] Configurando dispositivo de audio en EmulationStation..."
cat << 'EOF' | sudo tee "$STORAGE_DIR/.config/emulationstation/es_settings.cfg" > /dev/null
<?xml version="1.0"?>
<config>
  <string name="AudioCard" value="default" />
  <string name="AudioDevice" value="Playback" />
  <int name="AudioVolume" value="95" />
  <bool name="AudioEnable" value="true" />
  <bool name="NavigationSounds" value="true" />
  <bool name="VideoAudio" value="true" />
</config>
EOF

# 4. Asignar permisos y sincronizar
echo "[4/4] Aplicando permisos y sincronizando..."
sudo chmod -R 777 "$STORAGE_DIR/.config"
sync

echo ""
echo "=========================================================="
echo "  CONFIGURACION DE AUDIO APLICADA CON EXITO"
echo "=========================================================="
echo "1. Enrutamiento directo al altavoz (SPK) activado."
echo "2. Amplificador rk817 desmuteado al 95%."
echo "3. EmulationStation configurado en AudioDevice=Playback."
echo "=========================================================="
