#include "../include/ram_vault.hpp"
#include <iostream>
#include <thread>
#include <chrono>
#include <csignal>
#include <unistd.h>
#include <sched.h>

static bool g_running = true;

void signal_handler(int sig) {
    std::cout << "\n[Orchestrator] Señal " << sig << " recibida. Deteniendo..." << std::endl;
    g_running = false;
}

int main(int argc, char** argv) {
    std::signal(SIGINT, signal_handler);
    std::signal(SIGTERM, signal_handler);

    std::cout << "=======================================================" << std::endl;
    std::cout << "   R35 ULTRA - MOTOR DE ACELERACION RAM & NEON v1.0    " << std::endl;
    std::cout << "=======================================================" << std::endl;

    // 1. Asignar este demonio al Núcleo 2 (Vectorial & RAM Manager)
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(2, &cpuset);
    if (sched_setaffinity(0, sizeof(cpuset), &cpuset) == 0) {
        std::cout << "[Orchestrator] Afinidad fijada con éxito en Núcleo {2}" << std::endl;
    }

    // 2. Inicializar la Bóveda de 400 MB en Memoria Compartida
    R35Engine::RamVault vault;
    if (!vault.initialize(true)) {
        std::cerr << "[Orchestrator] Falló la inicialización del RAM Vault." << std::endl;
        return 1;
    }

    R35Engine::VaultHeader* header = vault.getHeader();
    std::cout << "[Orchestrator] Bóveda activa y lista para PPSSPP." << std::endl;

    while (g_running) {
        std::this_thread::sleep_for(std::chrono::seconds(2));
        if (header) {
            // Actualizar estadísticas
            header->current_fps = 30.0f;
        }
    }

    vault.cleanup();
    std::cout << "[Orchestrator] Servicio finalizado limpiamente." << std::endl;
    return 0;
}
