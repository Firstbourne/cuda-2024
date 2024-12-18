#include "gemm_cublas.h"
#include <vector>
#include <cublas_v2.h>
#include <cuda_runtime.h>
#include <stdexcept>

std::vector<float> GemmCUBLAS(const std::vector<float>& a,
                              const std::vector<float>& b,
                              int n) {

    std::vector<float> c(n * n);

    float *d_a, *d_b, *d_c;

    cudaMalloc((void**)&d_a, n * n * sizeof(float));
    cudaMalloc((void**)&d_b, n * n * sizeof(float));
    cudaMalloc((void**)&d_c, n * n * sizeof(float));

    cudaMemcpy(d_a, a.data(), n * n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b.data(), n * n * sizeof(float), cudaMemcpyHostToDevice);

    cublasHandle_t handle;
    cublasCreate(&handle);

    const float alpha = 1.0f;
    const float beta = 0.0f;

    cublasSgemm(handle, 
                CUBLAS_OP_N, CUBLAS_OP_N, 
                n, n, n, 
                &alpha, 
                d_b, n, 
                d_a, n, 
                &beta, 
                d_c, n);

    cudaMemcpy(c.data(), d_c, n * n * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cublasDestroy(handle);

    return c;
}
