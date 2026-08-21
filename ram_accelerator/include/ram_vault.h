#ifndef RAM_VAULT_H
#define RAM_VAULT_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#define SHM_VAULT_NAME "/r35_ram_vault"
#define TEXTURE_VAULT_SIZE (200ULL * 1024ULL * 1024ULL) // 200 MB
#define VERTEX_VAULT_SIZE  (100ULL * 1024ULL * 1024ULL) // 100 MB
#define JIT_VAULT_SIZE     (100ULL * 1024ULL * 1024ULL) // 100 MB
#define TOTAL_VAULT_SIZE   (TEXTURE_VAULT_SIZE + VERTEX_VAULT_SIZE + JIT_VAULT_SIZE) // 400 MB

typedef struct __attribute__((aligned(16))) {
    float x, y, z, w;
    float u, v;
    uint32_t color;
    uint32_t flags;
} Vertex3D;

typedef struct __attribute__((aligned(16))) {
    float m[16];
} Matrix4x4;

typedef struct {
    uint32_t magic;         // 0x52333556 ('R35V')
    uint32_t version;       // Version 1
    uint64_t total_size;
    
    uint64_t texture_offset;
    uint64_t vertex_offset;
    uint64_t jit_offset;
    
    uint64_t textures_cached;
    uint64_t vertices_processed;
    uint64_t jit_blocks_stored;
    float current_fps;
    float cpu_load;
} VaultHeader;

typedef struct {
    int shm_fd;
    void* mapped_addr;
    VaultHeader* header;
} RamVaultContext;

bool ram_vault_init(RamVaultContext* ctx, bool create_new);
void ram_vault_cleanup(RamVaultContext* ctx);
void* ram_vault_get_textures(const RamVaultContext* ctx);
void* ram_vault_get_vertices(const RamVaultContext* ctx);
void* ram_vault_get_jit(const RamVaultContext* ctx);

void neon_transform_vertices_4x(const float* __restrict__ matrix,
                                const float* __restrict__ in_verts,
                                float* __restrict__ out_verts,
                                size_t vertex_count);

#endif // RAM_VAULT_H
