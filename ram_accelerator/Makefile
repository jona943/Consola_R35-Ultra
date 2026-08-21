CXX ?= g++
CC ?= gcc
CXXFLAGS = -std=c++20 -O3 -Wall -Wextra -pthread -I./include
CFLAGS = -O3 -Wall -Wextra -pthread -I./include
LDFLAGS = -pthread -lrt

# Targets
all: bin/ram_orchestrator bin/test_benchmark

bin/ram_orchestrator: src/ram_orchestrator.cpp src/texture_vault.cpp src/neon_geometry.c
	@mkdir -p bin
	$(CXX) $(CXXFLAGS) -o $@ src/ram_orchestrator.cpp src/texture_vault.cpp src/neon_geometry.c $(LDFLAGS)

bin/test_benchmark: src/test_benchmark.cpp src/texture_vault.cpp src/neon_geometry.c
	@mkdir -p bin
	$(CXX) $(CXXFLAGS) -o $@ src/test_benchmark.cpp src/texture_vault.cpp src/neon_geometry.c $(LDFLAGS)

# Compilación cruzada para la consola R35 Ultra (ARM64 Cortex-A35 NEON)
aarch64:
	@mkdir -p bin_aarch64
	aarch64-linux-gnu-g++ -std=c++20 -O3 -mcpu=cortex-a35 -march=armv8-a+simd -pthread -I./include -o bin_aarch64/ram_orchestrator src/ram_orchestrator.cpp src/texture_vault.cpp src/neon_geometry.c -lrt
	aarch64-linux-gnu-g++ -std=c++20 -O3 -mcpu=cortex-a35 -march=armv8-a+simd -pthread -I./include -o bin_aarch64/test_benchmark src/test_benchmark.cpp src/texture_vault.cpp src/neon_geometry.c -lrt
	@echo "=== BINARIOS ARM64 COMPILADOS CON EXITO PARA R35 ULTRA ==="

clean:
	rm -rf bin bin_aarch64
