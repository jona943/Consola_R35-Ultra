#include "../include/ram_vault.hpp"
#include <iostream>
#include <chrono>
#include <vector>

extern "C" void neon_transform_vertices_4x(const float* __restrict__ matrix,
                                           const float* __restrict__ in_verts,
                                           float* __restrict__ out_verts,
                                           size_t vertex_count);

int main() {
    std::cout << "=== TEST BENCHMARK: RENDIMIENTO DE MEMORIA RAM Y NEON ===" << std::endl;

    // 1. Benchmark de Memoria Compartida
    R35Engine::RamVault vault;
    if (!vault.initialize(true)) {
        std::cerr << "Error al inicializar Vault en benchmark." << std::endl;
        return 1;
    }

    const size_t TEST_VERTICES = 100000; // 100,000 vértices
    std::vector<float> in_v(TEST_VERTICES * 4, 1.5f);
    std::vector<float> out_v(TEST_VERTICES * 4, 0.0f);
    float matrix[16] = {
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        10.0f, 20.0f, 30.0f, 1.0f
    };

    auto start = std::chrono::high_resolution_clock::now();
    neon_transform_vertices_4x(matrix, in_v.data(), out_v.data(), TEST_VERTICES);
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double, std::milli> elapsed = end - start;
    std::cout << "-> Transformacion de 100,000 vertices completada en: " << elapsed.count() << " ms" << std::endl;
    std::cout << "-> Tasa de rendimiento: " << (TEST_VERTICES / (elapsed.count() / 1000.0)) / 1000000.0 << " Millones de Vertices/seg" << std::endl;

    vault.cleanup();
    std::cout << "=== BENCHMARK COMPLETADO EXITOSAMENTE ===" << std::endl;
    return 0;
}
