import os, time, glob

time.sleep(1.0)
pid = None

for _ in range(10):
    try:
        with open("/tmp/ppsspp_pid.txt", "r") as f:
            pid = int(f.read().strip())
        if os.path.exists(f"/proc/{pid}"):
            break
    except Exception:
        pass
    time.sleep(1)

if not pid or not os.path.exists(f"/proc/{pid}"):
    pids = [int(p) for p in os.listdir("/proc") if p.isdigit() and os.path.exists(f"/proc/{p}/comm") and open(f"/proc/{p}/comm").read().strip().lower() in ["ppsspp", "ppssppsdl"]]
    if pids:
        pid = pids[0]
    else:
        exit(0)

print(f"=== APLICANDO AFINIDAD QUIRURGICA EXACTA PARA ROCKNIX (PID {pid}) ===")

for task_dir in glob.glob(f"/proc/{pid}/task/*"):
    try:
        tid = int(os.path.basename(task_dir))
        with open(f"{task_dir}/comm", "r") as f:
            comm = f.read().strip()
        
        # 1. Hilo JIT MIPS (Emu o EmuThread): Core 3 EXCLUSIVO
        if "emu" in comm.lower():
            os.sched_setaffinity(tid, {3})
            assigned = "Core {3} (Exclusivo JIT MIPS EmuThread)"
            
        # 2. Hilos de Vertices (PoolW / PoolWorker) e I/O: Core 2 EXCLUSIVO
        elif "poolw" in comm.lower() or comm == "IO":
            os.sched_setaffinity(tid, {2})
            assigned = "Core {2} (Vertex PoolW & IO)"
            
        # 3. Renderizado y Driver GPU Mesa Panfrost: Core 1
        elif "mali" in comm.lower() or "panfrost" in comm.lower() or comm.lower() in ["ppsspp", "ppssppsdl"]:
            os.sched_setaffinity(tid, {1})
            assigned = "Core {1} (Render & Panfrost GPU Driver)"
            
        # 4. Audio SAS, ALSA, PulseAudio / PipeWire: Core 0
        elif comm in ["SAS", "SDLAudioP2", "SDLHotplugALSA", "PulseMainloop", "PulseHotplug"]:
            os.sched_setaffinity(tid, {0})
            assigned = "Core {0} (Audio Engine & System)"
            
        # 5. Secundarios: Core 0
        else:
            os.sched_setaffinity(tid, {0})
            assigned = "Core {0} (Secondary)"
            
        print(f"  TID {tid} ({comm}) -> {assigned}")
    except Exception as e:
        print(f"  Error en {tid}: {e}")
