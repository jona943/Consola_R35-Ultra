#pragma once

#include <cstdint>
#include <cstddef>
#include <string>

namespace R35Engine {

// Constantes de memoria compartida
constexpr const char* SHM_VAULT_NAME = "/r35_ram_vault";
constexpr size_t TEXTURE_VAULT_SIZE = 200 * 1024 * 1024;  // 200 MB
constexpr size_t VERTEX_VAULT_SIZE  = 100 * 1024 * 1024;  // 100 MB
constexpr size_t JIT_VAULT_SIZE     = 100 * 1024 * 1024;  // 100 MB
constexpr size_t TOTAL_VAULT_SIZE   = TEXTURE_VAULT_SIZE + VERTEX_VAULT_SIZE + JIT_VAULT_SIZE; // 400 MB

// Estructura de vértice 3D (32 bytes alineados)
struct alignas(16) Vertex3D {
    float x, y, z, w;       // Coordenadas homogéneas
    float u, v;             // Coordenadas de textura UV
    uint32_t color;         // Color RGBA8888
    uint32_t flags;         // Banderas de renderizado
};

// Matriz de transformación 4x4
struct alignas(16) Matrix4x4 {
    float m[16];
};

// Cabecera del Vault de Memoria Compartida en /dev/shm
struct VaultHeader {
    uint32_t magic;         // 0x52333556 ('R35V')
    uint32_t version;       // Version 1
    uint64_t total_size;
    
    // Offsets de los búferes
    uint64_t texture_offset;
    uint64_t vertex_offset;
    uint64_t jit_offset;
    
    // Estadísticas de rendimiento en tiempo real
    uint64_t textures_cached;
    uint64_t vertices_processed;
    uint64_t jit_blocks_stored;
    float current_fps;
    float cpu_load;
};

// Clase para gestionar el Vault en Memoria Compartida
class RamVault {
public:
    RamVault();
    ~RamVault();

    bool initialize(bool create_new = false);
    void cleanup();

    void* getTextureBuffer() const;
    void* getVertexBuffer() const;
    void* getJitBuffer() const;
    VaultHeader* getHeader() const;

private:
    int shm_fd_{-1};
    void* mapped_addr_{nullptr};
    VaultHeader* header_{nullptr};
};

} // namespace R35Engine
