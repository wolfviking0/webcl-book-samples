//
// Book:      OpenCL(R) Programming Guide
// Authors:   Aaftab Munshi, Benedict Gaster, Timothy Mattson, James Fung, Dan Ginsburg
// ISBN-10:   0-321-74964-2
// ISBN-13:   978-0-321-74964-2
// Publisher: Addison-Wesley Professional
// URLs:      http://safari.informit.com/9780132488006/
//            http://www.openclprogrammingguide.com
//


// vecadd.cpp
//
//    This is a simple example that demonstrates use OpenCL C++ Wrapper API.

// Enable OpenCL C++ exceptions
#define __CL_ENABLE_EXCEPTIONS


#include <CL/cl.hpp>

#include <cstdio>
#include <cstdlib>
#include <iostream>

#define BUFFER_SIZE 20

int A[BUFFER_SIZE];
int B[BUFFER_SIZE];
int C[BUFFER_SIZE];

static char
kernelSourceCode[] = 
"__kernel void                                                               \n"
"vadd(__global int * a, __global int * b, __global int * c)                                                                     \n"
"{                                                                           \n"
"    size_t i =  get_global_id(0);                                           \n"
"                                                                            \n"
"    c[i] = a[i] + b[i];                                                     \n"
"}                                                                           \n"
;


int
main(int argc, char ** argv)
{
    cl_int err;

    // Parse command line options
    //
    int use_gpu = 1;
    for(int i = 0; i < argc && argv; i++)
    {
        if(!argv[i])
            continue;
            
        if(strstr(argv[i], "cpu"))
            use_gpu = 0;        

        else if(strstr(argv[i], "gpu"))
            use_gpu = 1;
    }

    printf("Parameter detect %s device\n",use_gpu==1?"GPU":"CPU");

    // Initialize A, B, C
    for (int i = 0; i < BUFFER_SIZE; i++) {
        A[i] = i;
        B[i] = i * 2;
        C[i] = 0;
    }

    try {
        std::vector<cl::Platform> platformList;

        // Pick platform
        cl::Platform::get(&platformList);

        // Pick first platform
        cl_context_properties cprops[] = {
            CL_CONTEXT_PLATFORM, (cl_context_properties)(platformList[0])(), 0};
        cl::Context context(use_gpu?CL_DEVICE_TYPE_GPU:CL_DEVICE_TYPE_CPU, cprops);

        // Query the set of devices attched to the context
        std::vector<cl::Device> devices = context.getInfo<CL_CONTEXT_DEVICES>();

        // Create and program from source
        cl::Program::Sources sources(1, std::make_pair(kernelSourceCode, 0));
        cl::Program program(context, sources);

        // Build program
        program.build(devices);

        // Create buffer for A and copy host contents
        //CL_SET_TYPE_POINTER(CL_SIGNED_INT32);
        cl::Buffer aBuffer = cl::Buffer(
            context, 
            CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, 
            BUFFER_SIZE * sizeof(int), 
            (void *) &A[0]);

        // Create buffer for B and copy host contents
        CL_SET_TYPE_POINTER(CL_SIGNED_INT32);
        cl::Buffer bBuffer = cl::Buffer(
            context, 
            CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, 
            BUFFER_SIZE * sizeof(int), 
            (void *) &B[0]);

        // Create buffer for that uses the host ptr C
        CL_SET_TYPE_POINTER(CL_SIGNED_INT32);
        cl::Buffer cBuffer = cl::Buffer(
            context, 
            CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR, 
            BUFFER_SIZE * sizeof(int), 
            (void *) &C[0]);

        // Create kernel object
        cl::Kernel kernel(program, "vadd");

        // Set kernel args
        kernel.setArg(0, aBuffer);
        kernel.setArg(1, bBuffer);
        kernel.setArg(2, cBuffer);

        // Create command queue
        cl::CommandQueue queue(context, devices[0], 0);
 
        // Do the work
        queue.enqueueNDRangeKernel(
            kernel, 
            cl::NullRange, 
            cl::NDRange(BUFFER_SIZE), 
            cl::NullRange);
 

        // Map cBuffer to host pointer. This enforces a sync with 
        // the host backing space, remember we choose GPU device.
        CL_SET_TYPE_POINTER(CL_SIGNED_INT32);
        int * output = (int *) queue.enqueueMapBuffer(
            cBuffer,
            CL_TRUE, // block 
            CL_MAP_READ,
            0,
            BUFFER_SIZE * sizeof(int));

        for (int i = 0; i < BUFFER_SIZE; i++) {
            std::cout << output[i] << " ";
        }
        std::cout << std::endl;

        // Finally release our hold on accessing the memory
        err = queue.enqueueUnmapMemObject(
            cBuffer,
            (void *) output);
 
        // There is no need to perform a finish on the final unmap
        // or release any objects as this all happens implicitly with
        // the C++ Wrapper API.
    } 
    catch (cl::Error err) {
         std::cerr
             << "ERROR: "
             << err.what()
             << "("
             << err.err()
             << ")"
             << std::endl;

         return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
