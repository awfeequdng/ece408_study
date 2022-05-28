#include <iostream>
#include <cuda_runtime.h>

__global__ void vecAddKernel(int *d_a, int *d_b, int *d_c, int n) {
	int id = blockIdx.x * blockDim.x + threadIdx.x;
	if (id < n) {
		d_c[id] = d_a[id] + d_b[id];
	}
}

int main() {

	const int MAX = 500;
	int a[MAX] = {1, 2,3, 4, 5};
	int b[MAX] = {2,3, 4, 5, 6};
	int c[MAX] = {0};
	
	int *d_a;
	int *d_b;
	int *d_c;
	cudaMalloc(&d_a, sizeof(a));
	cudaMalloc(&d_b, sizeof(a));
	cudaMalloc(&d_c, sizeof(a));

	cudaMemcpy(d_a, a, sizeof(a), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(a), cudaMemcpyHostToDevice);
	int N = 1020;
	dim3 grid(ceil(N/256));
	dim3 block(256);
		
	vecAddKernel<<<grid, block>>>(d_a, d_b, d_c, MAX);
	//cudaDeviceSynchronize();
	cudaMemcpy(c, d_c, sizeof(a), cudaMemcpyDeviceToHost);
	for(int i = 0; i < MAX; i++) {
		std::cout << " " << c[i];
		if (i % 10 == 0) std::cout << std::endl;
	}
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	return 0;
}


