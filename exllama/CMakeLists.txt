# include_directories(${CUDA_TOOLKIT_ROOT_DIR}/include)
# link_directories(${CUDA_TOOLKIT_ROOT_DIR}/lib64)

file(GLOB SOURCES *.cu)
file(GLOB SOURCES cuda_func/*.cu)
add_library(exllama_cuda_kernels SHARED ${SOURCES})
set_target_properties(exllama_cuda_kernels PROPERTIES CUDA_ARCHITECTURES "75;80;86")
