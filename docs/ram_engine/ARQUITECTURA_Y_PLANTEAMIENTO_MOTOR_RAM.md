# Arquitectura Tecnica: Motor de Aceleracion por Memoria RAM y SIMD NEON para PPSSPP

**Proyecto:** Acelerador de Rendimiento Hibrido RAM-GPU para Consola Portatil R35 Ultra (Rockchip RK3326)  
**Objetivo:** Intercambiar el excedente de memoria RAM disponible (500+ MB) y la potencia vectorial de la CPU Cortex-A35 (ARM NEON) para eliminar el cuello de botella de la GPU Mali-G31 en escenarios 3D criticos.

---

## 1. Justificacion y Planteamiento del Problema

| Componente | Capacidad Hardware | Estado en Emulacion Estandar | Solucion Propuesta |
| :--- | :--- | :--- | :--- |
| **Memoria RAM (LPDDR3)** | 1024 MB Físicos | Subutilizada (Solo usa ~280 MB, 540 MB libres) | **Crear un Vault en RAM de 400 MB con acceso Zero-Copy.** |
| **GPU Mali-G31 MP2** | 2 Shader Cores (520 MHz) | Sobrecargada en decodificacion CLUT y transformacion 3D | **Delegar descompresion y vertices a la CPU y memoria.** |
| **CPU Cortex-A35** | Quad-Core 1.512 GHz + NEON | 40-50% de capacidad ociosa en combate | **Activar procesamiento vectorial SIMD de 128 bits.** |

---

## 2. Diagrama de Flujo y Arquitectura del Sistema

```
+───────────────────────────────────────────────────────────────────────────────+
|                  PIPELINE DE ACELERACIÓN POR MEMORIA RAM                      |
+───────────────────────────────────────────────────────────────────────────────+
|                                                                               |
|  [ ALMACENAMIENTO: MicroSD ISO ]                                              |
|         │                                                                     |
|         ▼ (Lectura en Bloques de 4MB con read_ahead_kb)                       |
|  ┌─────────────────────────────────────────────────────────────────────────┐  |
|  │  BÓVEDA DE MEMORIA COMPARTIDA (POSIX SHM - 400 MB EN /dev/shm)          │  |
|  │  ├─ 200 MB: Texturas Decodificadas a RGBA8888 (Texture Vault)          │  |
|  │  ├─ 100 MB: Búfer Circular de Vértices Transformados (Ring-Buffer)      │  |
|  │  └─ 100 MB: Caché Permanente de Bloques JIT ARM64 (Code Vault)         │  |
|  └─────────────────────────────────────────────────────────────────────────┘  |
|         │                                             │                       |
|         │ (Texturas pre-convertidas)                  │ (Matrices de huesos)  |
|         ▼                                             ▼                       |
|  [ NÚCLEO 1: GPU MALI-G31 ]                    [ NÚCLEO 2: ARM NEON SIMD ]    |
|   Solo dibuja polígonos finales                Transformación de esqueletos   |
|   sin sobrecarga de descompresión              en paralelo (4 floats/ciclo)   |
|                                                                               |
+───────────────────────────────────────────────────────────────────────────────+
```

---

## 3. Desglose Modular del Software

### Módulo 1: *RAM Texture Vault & CLUT Unpacker* (`texture_vault.cpp`)
* **Lenguaje:** C++20 con soporte POSIX Shared Memory (`shm_open`, `mmap`).
* **Función:** Intercepta la carga de texturas paletizadas (CLUT 4-bit / 8-bit) de la PSP y las expande a formato nativo `RGBA8888` directamente en la memoria RAM antes de que el cuadro sea renderizado.
* **Beneficio:** La GPU Mali-G31 recibe texturas nativas listas para consumir, eliminando el 100% del cálculo de paletas y desentrelazado.

### Módulo 2: *NEON SIMD Vector Geometry Transformer* (`neon_geometry.c`)
* **Lenguaje:** C con Intrínsecos ARM NEON (`<arm_neon.h>`).
* **Función:** Asignado exclusivamente al **Núcleo 2 de la CPU**, procesa las transformaciones de matrices 4x4 y el *Skinning* de esqueletos utilizando registros vectoriales de 128 bits (`float32x4_t`), calculando 4 vértices simultáneamente por ciclo.
* **Beneficio:** Reduce a la mitad el número de pasadas de *Vertex Shaders* en la GPU.

### Módulo 3: *Persistent JIT Code Vault* (`jit_vault.cpp`)
* **Lenguaje:** C++20.
* **Función:** Aloja las instrucciones MIPS recompiladas a ARM64 en un búfer de ejecución persistente protegido con permisos `PROT_READ | PROT_WRITE | PROT_EXEC`, evitando la invalidación de bloques JIT en transiciones de salas.

### Módulo 4: *Kernel & Sidecar Orchestrator Daemon* (`ram_orchestrator.c`)
* **Lenguaje:** C11 (POSIX Realtime).
* **Función:** Demonio en segundo plano que fija la afinidad quirúrgica de los 4 núcleos, asigna prioridad de tiempo real (`SCHED_FIFO` / `nice -20`), y supervisa los márgenes de memoria y temperatura.

---

## 4. Plan de Pruebas y Metricas de Exito

| Fase | Tarea | Metrica de Validacion |
| :--- | :--- | :--- |
| **Fase 1** | Creacion del demonio de Memoria Compartida en C++ | Reserva y mapeo exitoso de 400 MB en `/dev/shm`. |
| **Fase 2** | Implementacion de funciones vectoriales NEON | Prueba de transformacion de 10,000 vertices en < 0.5 ms. |
| **Fase 3** | Hook e integracion con el lanzador de PPSSPP | Eliminacion de caidas en el Templo de Zeus (Target: 30-40 FPS fijos). |

---

*Documento de diseno y arquitectura de ingenieria para R35 Ultra (2026).*
