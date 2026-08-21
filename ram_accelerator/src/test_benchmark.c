#include "../include/ram_vault.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
    printf("=== TEST BENCHMARK C11: RENDIMIENTO DE MEMORIA RAM Y NEON ===\n");

    RamVaultContext vault;
    if (!ram_vault_init(&vault, true)) {
        fprintf(stderr, "Error al inicializar Vault en benchmark.\n");
        return 1;
    }

    const size_t TEST_VERTICES = 100000; // 100,000 vértices
    float* in_v = (float*)malloc(TEST_VERTICES * 4 * sizeof(float));
    float* out_v = (float*)malloc(TEST_VERTICES * 4 * sizeof(float));
    for (size_t i = 0; i < TEST_VERTICES * 4; i++) {
        in_v[i] = 1.5f;
    }

    float matrix[16] = {
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        10.0f, 20.0f, 30.0f, 1.0f
    };

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    neon_transform_vertices_4x(matrix, in_v, out_v, TEST_VERTICES);

    clock_gettime(CLOCK_MONOTONIC, &end);

    double elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
    double rate_mverts = (TEST_VERTICES / (elapsed_ms / 1000.0)) / 1000000.0;

    printf("-> Transformacion de 100,000 vertices completada en: %.4f ms\n", elapsed_ms);
    printf("-> Tasa de rendimiento: %.2f Millones de Vertices/seg\n", rate_mverts);

    free(in_v);
    free(out_v);
    ram_vault_cleanup(&vault);
    printf("=== BENCHMARK C11 COMPLETADO EXITOSAMENTE ===\n");
    return 0;
}
