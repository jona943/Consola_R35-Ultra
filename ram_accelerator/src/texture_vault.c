#include "../include/ram_vault.h"
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

bool ram_vault_init(RamVaultContext* ctx, bool create_new) {
    if (!ctx) return false;
    ctx->shm_fd = -1;
    ctx->mapped_addr = NULL;
    ctx->header = NULL;

    int flags = O_RDWR;
    if (create_new) {
        flags |= O_CREAT | O_TRUNC;
    }

    ctx->shm_fd = shm_open(SHM_VAULT_NAME, flags, 0666);
    if (ctx->shm_fd < 0) {
        fprintf(stderr, "[RAM-Vault] Error shm_open: %s\n", strerror(errno));
        return false;
    }

    if (create_new) {
        if (ftruncate(ctx->shm_fd, TOTAL_VAULT_SIZE) != 0) {
            fprintf(stderr, "[RAM-Vault] Error ftruncate: %s\n", strerror(errno));
            close(ctx->shm_fd);
            return false;
        }
    }

    ctx->mapped_addr = mmap(NULL, TOTAL_VAULT_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, ctx->shm_fd, 0);
    if (ctx->mapped_addr == MAP_FAILED) {
        fprintf(stderr, "[RAM-Vault] Error mmap: %s\n", strerror(errno));
        close(ctx->shm_fd);
        return false;
    }

    ctx->header = (VaultHeader*)ctx->mapped_addr;

    if (create_new) {
        memset(ctx->mapped_addr, 0, sizeof(VaultHeader));
        ctx->header->magic = 0x52333556; // 'R35V'
        ctx->header->version = 1;
        ctx->header->total_size = TOTAL_VAULT_SIZE;
        ctx->header->texture_offset = sizeof(VaultHeader);
        ctx->header->vertex_offset = ctx->header->texture_offset + TEXTURE_VAULT_SIZE;
        ctx->header->jit_offset = ctx->header->vertex_offset + VERTEX_VAULT_SIZE;
        printf("[RAM-Vault] Boveda de 400 MB creada exitosamente en /dev/shm\n");
    } else {
        if (ctx->header->magic != 0x52333556) {
            fprintf(stderr, "[RAM-Vault] Magic header invalido.\n");
            ram_vault_cleanup(ctx);
            return false;
        }
        printf("[RAM-Vault] Conectado exitosamente a la boveda existente.\n");
    }

    return true;
}

void ram_vault_cleanup(RamVaultContext* ctx) {
    if (!ctx) return;
    if (ctx->mapped_addr && ctx->mapped_addr != MAP_FAILED) {
        munmap(ctx->mapped_addr, TOTAL_VAULT_SIZE);
        ctx->mapped_addr = NULL;
    }
    if (ctx->shm_fd >= 0) {
        close(ctx->shm_fd);
        ctx->shm_fd = -1;
    }
}

void* ram_vault_get_textures(const RamVaultContext* ctx) {
    if (!ctx || !ctx->mapped_addr) return NULL;
    return (uint8_t*)ctx->mapped_addr + ctx->header->texture_offset;
}

void* ram_vault_get_vertices(const RamVaultContext* ctx) {
    if (!ctx || !ctx->mapped_addr) return NULL;
    return (uint8_t*)ctx->mapped_addr + ctx->header->vertex_offset;
}

void* ram_vault_get_jit(const RamVaultContext* ctx) {
    if (!ctx || !ctx->mapped_addr) return NULL;
    return (uint8_t*)ctx->mapped_addr + ctx->header->jit_offset;
}
