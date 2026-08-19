import os, time, glob

time.sleep(2.0)
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
    pids = [int(p) for p in os.listdir("/proc") if p.isdigit() and os.path.exists(f"/proc/{p}/comm") and open(f"/proc/{p}/comm").read().strip() == "PPSSPPSDL"]
    if pids:
        pid = pids[0]
    else:
        exit(0)

print(f"Aplicando balanceo quirurgico anti-tirones para PID {pid}...")

for task_dir in glob.glob(f"/proc/{pid}/task/*"):
    try:
        tid = int(os.path.basename(task_dir))
        with open(f"{task_dir}/comm", "r") as f:
            comm = f.read().strip()
        
        # 1. Hilo JIT MIPS de Kratos: Core 3 EXCLUSIVO
        if comm == "Emu":
            os.sched_setaffinity(tid, {3})
            assigned = "Core {3} (Exclusivo JIT MIPS)"
            
        # 2. Hilos de Vertices (PoolWorkers 0-7) e I/O: Core 2 EXCLUSIVO (Eleva Core 2 de 38% a 70%)
        elif "PoolWorker" in comm or comm == "IO":
            os.sched_setaffinity(tid, {2})
            assigned = "Core {2} (Vertex PoolWorkers & IO)"
            
        # 3. Renderizado y Driver GPU Mali: Core 1
        elif comm in ["PPSSPPSDL", "mali-cmar-backe"] or "mali" in comm:
            os.sched_setaffinity(tid, {1})
            assigned = "Core {1} (Render & Mali GPU Driver)"
            
        # 4. Audio SAS, ALSA y Ring Buffer: Core 0
        elif comm in ["SAS", "SDLAudioP2", "SDLHotplugALSA"]:
            os.sched_setaffinity(tid, {0})
            assigned = "Core {0} (Audio Engine & System)"
            
        # 5. Secundarios: Core 0
        else:
            os.sched_setaffinity(tid, {0})
            assigned = "Core {0} (Secondary)"
            
        print(f"  TID {tid} ({comm}) -> {assigned}")
    except Exception as e:
        print(f"  Error en {tid}: {e}")
