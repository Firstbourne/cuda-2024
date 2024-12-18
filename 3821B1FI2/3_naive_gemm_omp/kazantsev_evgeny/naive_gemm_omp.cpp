#include <omp.h>
#include "naive_gemm_omp.h"

std::vector<float> NaiveGemmOMP(const std::vector<float>& a,
    const std::vector<float>& b,
    int n) {
    std::vector<float> c(n * n, 0.0f);
#pragma omp parallel for
    for (int i = 0; i < n; ++i) {
        for (int k = 0; k < n; ++k) {
            float a_ik = a[i * n + k];
            for (int j = 0; j < n; ++j) {
                c[i * n + j] += a_ik * b[k * n + j];
            }
        }
    }

    return c;
}
