#include "../include/ram_vault.hpp"
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <cstring>
#include <iostream>

namespace R35Engine {

RamVault::RamVault() = default;

RamVault::~RamVault() {
    cleanup();
}

bool RamVault::initialize(bool create_new) {
    int flags = O_RDWR;
    if (create_new) {
        flags |= O_CREAT | O_TRUNC;
    }

    shm_fd_ = shm_open(SHM_VAULT_NAME, flags, 0666);
    if (shm_fd_ < 0) {
        std::cerr << "[RAM-Vault] Error al abrir shm_open: " << strerror(errno) << std::endl;
        return false;
    }

    if (create_new) {
        if (ftruncate(shm_fd_, TOTAL_VAULT_SIZE) != 0) {
            std::cerr << "[RAM-Vault] Error en ftruncate: " << strerror(errno) << std::endl;
            close(shm_fd_);
            return false;
        }
    }

    mapped_addr_ = mmap(nullptr, TOTAL_VAULT_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd_, 0);
    if (mapped_addr_ == MAP_FAILED) {
        std::cerr << "[RAM-Vault] Error en mmap: " << strerror(errno) << std::endl;
        close(shm_fd_);
        return false;
    }

    header_ = reinterpret_cast<VaultHeader*>(mapped_addr_);

    if (create_new) {
        std::memset(mapped_addr_, 0, sizeof(VaultHeader));
        header_->magic = 0x52333556; // 'R35V'
        header_->version = 1;
        header_->total_size = TOTAL_VAULT_SIZE;
        header_->texture_offset = sizeof(VaultHeader);
        header_->vertex_offset = header_->texture_offset + TEXTURE_VAULT_SIZE;
        header_->jit_offset = header_->vertex_offset + VERTEX_VAULT_SIZE;
        std::cout << "[RAM-Vault] Bóveda de 400 MB creada exitosamente en /dev/shm" << std::endl;
    } else {
        if (header_->magic != 0x52333556) {
            std::cerr << "[RAM-Vault] Magic header inválido en memoria compartida." << std::endl;
            cleanup();
            return false;
        }
        std::cout << "[RAM-Vault] Conectado exitosamente a la bóveda existente." << std::endl;
    }

    return true;
}

void RamVault::cleanup() {
    if (mapped_addr_ && mapped_addr_ != MAP_FAILED) {
        munmap(mapped_addr_, TOTAL_VAULT_SIZE);
        mapped_addr_ = nullptr;
    }
    if (shm_fd_ >= 0) {
        close(shm_fd_);
        shm_fd_ = -1;
    }
}

void* RamVault::getTextureBuffer() const {
    if (!mapped_addr_) return nullptr;
    return reinterpret_cast<uint8_t*>(mapped_addr_) + header_->texture_offset;
}

void* RamVault::getVertexBuffer() const {
    if (!mapped_addr_) return nullptr;
    return reinterpret_cast<uint8_t*>(mapped_addr_) + header_->vertex_offset;
}

void* RamVault::getJitBuffer() const {
    if (!mapped_addr_) return nullptr;
    return reinterpret_cast<uint8_t*>(mapped_addr_) + header_->jit_offset;
}

VaultHeader* RamVault::getHeader() const {
    return header_;
}

} // namespace R35Engine
