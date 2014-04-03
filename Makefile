#
#  Makefile
#  Licence : https://github.com/wolfviking0/webcl-translator/blob/master/LICENSE
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

# Default parameter
DEB = 0
VAL = 0
NAT = 0
ORIG= 0
FAST= 1

# Chdir function
CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

# Current Folder
CURRENT_ROOT:=$(PWD)

# Emscripten Folder
EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)/../webcl-translator/emscripten

# Native build
ifeq ($(NAT),1)
$(info ************ NATIVE : (GLEW)           ************)

CXX = clang++
CC  = clang

BUILD_FOLDER = $(CURRENT_ROOT)/bin/
EXTENSION = .out

ifeq ($(DEB),1)
$(info ************ NATIVE : DEBUG = 1        ************)

CFLAGS = -O0 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework AppKit -framework IOKit -framework CoreVideo -framework CoreGraphics -lGLEW

else
$(info ************ NATIVE : DEBUG = 0        ************)

CFLAGS = -O2 -framework OpenCL -framework OpenGL -framework GLUT -framework CoreFoundation -framework AppKit -framework IOKit -framework CoreVideo -framework CoreGraphics -lGLEW

endif

# Emscripten build
else
ifeq ($(ORIG),1)
$(info ************ EMSCRIPTEN : SUBMODULE     = 0 ************)

EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)/../emscripten
else
$(info ************ EMSCRIPTEN : SUBMODULE     = 1 ************)
endif

CXX = $(EMSCRIPTEN_ROOT)/em++
CC  = $(EMSCRIPTEN_ROOT)/emcc

BUILD_FOLDER = $(CURRENT_ROOT)/js/
EXTENSION = .js
GLOBAL =

ifeq ($(DEB),1)
$(info ************ EMSCRIPTEN : DEBUG         = 1 ************)

GLOBAL += EMCC_DEBUG=1

CFLAGS = -s OPT_LEVEL=1 -s DEBUG_LEVEL=1 -s CL_PRINT_TRACE=1 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1
else
$(info ************ EMSCRIPTEN : DEBUG         = 0 ************)

CFLAGS = -s OPT_LEVEL=3 -s DEBUG_LEVEL=0 -s CL_PRINT_TRACE=0 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=0 -s CL_GRAB_TRACE=0 -s CL_CHECK_VALID_OBJECT=0
endif

ifeq ($(VAL),1)
$(info ************ EMSCRIPTEN : VALIDATOR     = 1 ************)

PREFIX = val_

CFLAGS += -s CL_VALIDATOR=1
else
$(info ************ EMSCRIPTEN : VALIDATOR     = 0 ************)
endif

ifeq ($(FAST),1)
$(info ************ EMSCRIPTEN : FAST_COMPILER = 1 ************)

GLOBAL += EMCC_FAST_COMPILER=1
else
$(info ************ EMSCRIPTEN : FAST_COMPILER = 0 ************)
endif

endif

SOURCES_helloworld		=	HelloWorld.cpp
SOURCES_info			= 	OpenCLInfo.cpp	
SOURCES_buffer			=	simple.cpp
SOURCES_convolution		=	Convolution.cpp
SOURCES_glinterop		=	GLinterop.cpp
SOURCES_vectoradd		=	vecadd.cpp

INCLUDES_helloworld		=	-I./
INCLUDES_info			=	-I./
INCLUDES_buffer			= 	-I./
INCLUDES_convolution	=	-I./
INCLUDES_glinterop		=	-I./ -I$(EMSCRIPTEN_ROOT)/system/include/
INCLUDES_vectoradd		=	-I./ -I$(EMSCRIPTEN_ROOT)/system/include/


ifeq ($(NAT),0)

KERNEL_helloworld		= 	--preload-file HelloWorld.cl
KERNEL_info				= 	
KERNEL_buffer			= 	--preload-file simple.cl
KERNEL_convolution		= 	--preload-file Convolution.cl
KERNEL_glinterop		= 	--preload-file GLinterop.cl
KERNEL_vectoradd		= 	

CFLAGS_helloworld		=	
CFLAGS_info				=	
CFLAGS_buffer			=	
CFLAGS_convolution		=	
CFLAGS_glinterop		=	-s GL_FFP_ONLY=1 -s LEGACY_GL_EMULATION=1
CFLAGS_vectoradd		=	

VALPARAM_helloworld		=	-s CL_VAL_PARAM='[""]'
VALPARAM_info			=	-s CL_VAL_PARAM='[""]'
VALPARAM_buffer			=	-s CL_VAL_PARAM='[""]'
VALPARAM_convolution	=	-s CL_VAL_PARAM='[""]'
VALPARAM_glinterop		=	-s CL_VAL_PARAM='[""]'
VALPARAM_vectoradd		=	-s CL_VAL_PARAM='[""]'

else

COPY_helloworld			= 	cp HelloWorld.cl $(BUILD_FOLDER) &&
COPY_info				= 	 
COPY_buffer				= 	cp simple.cl $(BUILD_FOLDER) &&
COPY_convolution		= 	cp Convolution.cl $(BUILD_FOLDER) &&
COPY_glinterop			= 	cp GLinterop.cl $(BUILD_FOLDER) &&
COPY_vectoradd			= 	

endif

.PHONY:    
	all clean

all: \
	all_1 all_2 all_3

all_1: \
	helloworld_sample info_sample

all_2: \
	buffer_sample convolution_sample

all_3: \
	glinterop_sample vectoradd_sample

# Create build folder is necessary))
mkdir:
	mkdir -p $(BUILD_FOLDER);

helloworld_sample: mkdir
	$(call chdir,src/Chapter_2/HelloWorld/)
	$(COPY_helloworld) 	$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_helloworld)		$(SOURCES_helloworld) 		$(INCLUDES_helloworld)		$(VALPARAM_helloworld) 	$(KERNEL_helloworld) 	-o $(BUILD_FOLDER)$(PREFIX)helloworld$(EXTENSION) 

info_sample: mkdir
	$(call chdir,src/Chapter_3/OpenCLInfo/)
	$(COPY_info) 		$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_info)			$(SOURCES_info)				$(INCLUDES_info)			$(VALPARAM_info) 		$(KERNEL_info) 			-o $(BUILD_FOLDER)$(PREFIX)info$(EXTENSION) 

buffer_sample: mkdir
	$(call chdir,src/Chapter_7/SimpleBufferSubBuffer/)
	$(COPY_buffer) 		$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_buffer)			$(SOURCES_buffer)			$(INCLUDES_buffer)			$(VALPARAM_buffer) 		$(KERNEL_buffer) 		-o $(BUILD_FOLDER)$(PREFIX)buffer$(EXTENSION) 

convolution_sample: mkdir
	$(call chdir,src/Chapter_3/OpenCLConvolution/)
	$(COPY_convolution) $(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_convolution)	$(SOURCES_convolution)		$(INCLUDES_convolution)		$(VALPARAM_convolution) $(KERNEL_convolution) 	-o $(BUILD_FOLDER)$(PREFIX)convolution$(EXTENSION) 

glinterop_sample: mkdir
	$(call chdir,src/Chapter_10/GLinterop/)
	$(COPY_glinterop) 	$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_glinterop)		$(SOURCES_glinterop)		$(INCLUDES_glinterop)		$(VALPARAM_glinterop) 	$(KERNEL_glinterop) 	-o $(BUILD_FOLDER)$(PREFIX)glinterop$(EXTENSION) 

vectoradd_sample: mkdir
	$(call chdir,src/Chapter_12/VectorAdd/)
	$(COPY_vectoradd) 	$(GLOBAL) $(CXX) $(CFLAGS) $(CFLAGS_vectoradd)		$(SOURCES_vectoradd)		$(INCLUDES_vectoradd)		$(VALPARAM_vectoradd) 	$(KERNEL_vectoradd) 	-o $(BUILD_FOLDER)$(PREFIX)vectoradd$(EXTENSION) 

clean:
	rm -rf bin/
	mkdir -p bin/
	mkdir -p tmp/
	cp js/memoryprofiler.js tmp/ && cp js/settings.js tmp/ && cp js/index.html tmp/
	rm -rf js/
	mkdir js/
	cp tmp/memoryprofiler.js js/ && cp tmp/settings.js js/ && cp tmp/index.html js/
	rm -rf tmp/
	$(EMSCRIPTEN_ROOT)/emcc --clear-cache


