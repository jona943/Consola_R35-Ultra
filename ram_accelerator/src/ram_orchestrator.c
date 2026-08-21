#define _GNU_SOURCE
#include "../include/ram_vault.h"
#include <stdio.h>
#include <stdbool.h>
#include <signal.h>
#include <unistd.h>
#include <sched.h>

static volatile bool g_running = true;

void signal_handler(int sig) {
    (void)sig;
    printf("\n[Orchestrator] Senal recibida. Deteniendo...\n");
    g_running = false;
}

int main(void) {
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);

    printf("=======================================================\n");
    printf("   R35 ULTRA - MOTOR DE ACELERACION RAM & NEON v1.0    \n");
    printf("=======================================================\n");

    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(2, &cpuset);
    if (sched_setaffinity(0, sizeof(cpuset), &cpuset) == 0) {
        printf("[Orchestrator] Afinidad fijada con exito en Nucleo {2}\n");
    }

    RamVaultContext vault;
    if (!ram_vault_init(&vault, true)) {
        fprintf(stderr, "[Orchestrator] Fallo al inicializar Vault.\n");
        return 1;
    }

    printf("[Orchestrator] Boveda activa y lista para acelerar PPSSPP.\n");

    while (g_running) {
        sleep(2);
        if (vault.header) {
            vault.header->current_fps = 30.0f;
        }
    }

    ram_vault_cleanup(&vault);
    printf("[Orchestrator] Servicio finalizado limpiamente.\n");
    return 0;
}
