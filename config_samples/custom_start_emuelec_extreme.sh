#!/bin/sh
# Desbloqueo Extremo de Rendimiento EmuELEC R35 Ultra (1.512 GHz + GPU Always On + RAM Cache)

# 1. CPU a 1.512 GHz Permanente
echo 1512000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 2>/dev/null || true
echo 1512000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 2>/dev/null || true
echo "performance" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null || true

# 2. GPU Mali-G31 Always On
echo always_on > /sys/class/misc/mali0/device/power_policy 2>/dev/null || true

# 3. RAM Cache Inmortal (Pre-carga de ISOs en RAM)
sysctl -w vm.vfs_cache_pressure=1 2>/dev/null || true
sysctl -w vm.dirty_ratio=40 2>/dev/null || true
sysctl -w vm.swappiness=1 2>/dev/null || true

# 4. Margenes Termicos a 90 C
echo 90000 > /sys/class/thermal/thermal_zone0/trip_point_0_temp 2>/dev/null || true
echo 95000 > /sys/class/thermal/thermal_zone0/trip_point_1_temp 2>/dev/null || true
