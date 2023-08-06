#include <cuda_runtime.h>

#include <string>

extern "C" {
__device__ __host__ void Abc_Start();
__device__ __host__ void Abc_Stop();
typedef struct Abc_Frame_t_ Abc_Frame_t;
typedef struct Abc_Ntk_t_ Abc_Ntk_t;
typedef struct Vec_Ptr_t_ Vec_Ptr_t;
typedef struct Abc_Obj_t_ Abc_Obj_t;
__device__ __host__ Abc_Frame_t* Abc_FrameGetGlobalFrame();
__device__ __host__ int Cmd_CommandExecute(Abc_Frame_t* pAbc,
                                           const char* sCommand);
__device__ __host__ Abc_Ntk_t* Abc_FrameReadNtk(Abc_Frame_t* pAbc);
}

__device__ __host__ Abc_Ntk_t* read_circuit() {
  auto abc = Abc_FrameGetGlobalFrame();
  Cmd_CommandExecute(abc, "tiny.blif");
  Cmd_CommandExecute(abc, "print_stats");
  return Abc_FrameReadNtk(abc);
}

__global__ void SimulationKernel() {
  Abc_Start();
  auto network = read_circuit();
  Abc_Stop();
}

int main(int argc, char const* argv[]) {
  SimulationKernel<<<1, 1>>>();
  return 0;
}
