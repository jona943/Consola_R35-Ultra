CC ?= gcc
CFLAGS = -std=c11 -O3 -Wall -Wextra -pthread -I./include
LDFLAGS = -pthread -lrt

CROSS_CC = aarch64-linux-gnu-gcc
CROSS_CFLAGS = -std=c11 -O3 -mcpu=cortex-a35 -march=armv8-a+simd -Wall -Wextra -pthread -I./include

all: bin/ram_orchestrator bin/test_benchmark aarch64

bin/ram_orchestrator: src/ram_orchestrator.c src/texture_vault.c src/neon_geometry.c
	@mkdir -p bin
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

bin/test_benchmark: src/test_benchmark.c src/texture_vault.c src/neon_geometry.c
	@mkdir -p bin
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Compilación cruzada para la consola R35 Ultra (Cortex-A35 NEON)
aarch64: bin_aarch64/ram_orchestrator bin_aarch64/test_benchmark

bin_aarch64/ram_orchestrator: src/ram_orchestrator.c src/texture_vault.c src/neon_geometry.c
	@mkdir -p bin_aarch64
	$(CROSS_CC) $(CROSS_CFLAGS) -o $@ $^ $(LDFLAGS)

bin_aarch64/test_benchmark: src/test_benchmark.c src/texture_vault.c src/neon_geometry.c
	@mkdir -p bin_aarch64
	$(CROSS_CC) $(CROSS_CFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "=== ¡BINARIOS ARM64 CORTEX-A35 COMPILADOS CON EXITO! ==="

clean:
	rm -rf bin bin_aarch64
