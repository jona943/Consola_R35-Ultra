import os, time, glob

time.sleep(2.5) # Esperar a que el emulador inicialice sus hilos
pid = None

# Buscar PID de PPSSPPSDL
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
    exit(0)

# Aplicar afinidades POSIX exactas
for task_dir in glob.glob(f"/proc/{pid}/task/*"):
    try:
        tid = int(os.path.basename(task_dir))
        with open(f"{task_dir}/comm", "r") as f:
            comm = f.read().strip()
        
        if comm == "Emu":
            os.sched_setaffinity(tid, {3}) # Core 3 Exclusivo para JIT MIPS
        elif comm in ["PPSSPPSDL", "mali-cmar-backe"]:
            os.sched_setaffinity(tid, {2}) # Core 2 para Render GPU
        elif "PoolWorker" in comm or comm == "IO":
            os.sched_setaffinity(tid, {1}) # Core 1 para Vertices e I/O
        else:
            os.sched_setaffinity(tid, {0}) # Core 0 para Audio y Sistema
    except Exception:
        pass
