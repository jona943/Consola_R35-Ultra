#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(__ARM_NEON) || defined(__aarch64__)
#include <arm_neon.h>

void neon_transform_vertices_4x(const float* __restrict__ matrix,
                                const float* __restrict__ in_verts,
                                float* __restrict__ out_verts,
                                size_t vertex_count) {
    float32x4_t m0 = vld1q_f32(matrix);
    float32x4_t m1 = vld1q_f32(matrix + 4);
    float32x4_t m2 = vld1q_f32(matrix + 8);
    float32x4_t m3 = vld1q_f32(matrix + 12);

    for (size_t i = 0; i < vertex_count; i += 4) {
        float32x4_t x = vld1q_f32(in_verts + i * 4);
        float32x4_t y = vld1q_f32(in_verts + (i + 1) * 4);
        float32x4_t z = vld1q_f32(in_verts + (i + 2) * 4);
        float32x4_t w = vld1q_f32(in_verts + (i + 3) * 4);

        float32x4_t res = vmulq_f32(m0, x);
        res = vmlaq_f32(res, m1, y);
        res = vmlaq_f32(res, m2, z);
        res = vaddq_f32(res, m3);

        vst1q_f32(out_verts + i * 4, res);
    }
}

#else

void neon_transform_vertices_4x(const float* __restrict__ matrix,
                                const float* __restrict__ in_verts,
                                float* __restrict__ out_verts,
                                size_t vertex_count) {
    for (size_t i = 0; i < vertex_count; i++) {
        float x = in_verts[i * 4 + 0];
        float y = in_verts[i * 4 + 1];
        float z = in_verts[i * 4 + 2];
        float w = in_verts[i * 4 + 3];

        out_verts[i * 4 + 0] = matrix[0] * x + matrix[4] * y + matrix[8] * z + matrix[12] * w;
        out_verts[i * 4 + 1] = matrix[1] * x + matrix[5] * y + matrix[9] * z + matrix[13] * w;
        out_verts[i * 4 + 2] = matrix[2] * x + matrix[6] * y + matrix[10] * z + matrix[14] * w;
        out_verts[i * 4 + 3] = matrix[3] * x + matrix[7] * y + matrix[11] * z + matrix[15] * w;
    }
}

#endif

#ifdef __cplusplus
}
#endif
