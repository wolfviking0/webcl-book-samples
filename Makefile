#
#  Makefile
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

CURRENT_ROOT:=$(PWD)/

ORIG=0
ifeq ($(ORIG),1)
EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)../emscripten
else

$(info )
$(info )
$(info **************************************************************)
$(info **************************************************************)
$(info ************ /!\ BUILD USE SUBMODULE CARREFUL /!\ ************)
$(info **************************************************************)
$(info **************************************************************)
$(info )
$(info )

EMSCRIPTEN_ROOT:=$(CURRENT_ROOT)../webcl-translator/emscripten
endif

CXX = $(EMSCRIPTEN_ROOT)/em++
MAKE = $(EMSCRIPTEN_ROOT)/emmake

BOOST:=../../../boost
FREEIMAGE:=../freeimage

CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

DEB=0
VAL=0
FAST=1

ifeq ($(VAL),1)
PREFIX = val_
VALIDATOR = '[""]' # Enable validator without parameter
$(info ************  Mode VALIDATOR : Enabled ************)
else
PREFIX = 
VALIDATOR = '[]' # disable validator
$(info ************  Mode VALIDATOR : Disabled ************)
endif

DEBUG = -s OPT_LEVEL=1 -s DEBUG_LEVEL=1 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s CL_PRINT_TRACE=1 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1

NO_DEBUG = -s OPT_LEVEL=2 -s DEBUG_LEVEL=0 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s WARN_ON_UNDEFINED_SYMBOLS=0  -s CL_DEBUG=0 -s CL_GRAB_TRACE=0 -s CL_PRINT_TRACE=0 -s CL_CHECK_VALID_OBJECT=0

ifeq ($(DEB),1)
MODE=$(DEBUG)
EMCCDEBUG = EMCC_FAST_COMPILER=$(FAST) EMCC_DEBUG
$(info ************  Mode DEBUG : Enabled ************)
else
MODE=$(NO_DEBUG)
EMCCDEBUG = EMCC_FAST_COMPILER=$(FAST) EMCCDEBUG
$(info ************  Mode DEBUG : Disabled ************)
endif

$(info )
$(info )

BOOST_SRC = \
	$(BOOST)/libs/system/src/error_code.cpp \
	$(BOOST)/libs/program_options/src/options_description.cpp \
	$(BOOST)/libs/program_options/src/cmdline.cpp \
	$(BOOST)/libs/program_options/src/variables_map.cpp \
	$(BOOST)/libs/program_options/src/value_semantic.cpp \
	$(BOOST)/libs/program_options/src/positional_options.cpp \
	$(BOOST)/libs/program_options/src/convert.cpp \
	$(BOOST)/libs/regex/src/regex.cpp \
	$(BOOST)/libs/regex/src/cpp_regex_traits.cpp \
	$(BOOST)/libs/regex/src/regex_raw_buffer.cpp \
	$(BOOST)/libs/regex/src/regex_traits_defaults.cpp \
	$(BOOST)/libs/regex/src/static_mutex.cpp \
	$(BOOST)/libs/regex/src/instances.cpp \
	$(BOOST)/libs/filesystem/src/operations.cpp \

#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#
# BUILD
#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#		

all: all_1 all_2 all_3

all_1: \
	build_lib \
	hello_world_sample \
	info_sample \


all_2: \
	buffer_sample \
	convolution_sample \

all_3: \
	gl_interop_sample \
	vectoradd_sample \

#   image_filter_sample \
#	sinewave_sample \
#	histogram_sample \
#	dijkstra_sample \
#	spmv_sample \
#	flow_sample \

build_freeimage:
	$(call chdir,$(FREEIMAGE))
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(MAKE) make

build_lib:
	$(call chdir,externs/lib/)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) $(BOOST_SRC) -I../../externs/include/ -o libboost.o	

hello_world_sample:
	$(call chdir,src/Chapter_2/HelloWorld)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		HelloWorld.cpp \
	$(MODE) \
	--preload-file HelloWorld.cl \
	-o ../../../build/$(PREFIX)book_hello_world.js

info_sample:
	$(call chdir,src/Chapter_3/OpenCLInfo)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		OpenCLInfo.cpp \
	$(MODE) \
	-o ../../../build/$(PREFIX)book_info.js

convolution_sample:
	$(call chdir,src/Chapter_3/OpenCLConvolution)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		Convolution.cpp \
	$(MODE) \
	--preload-file Convolution.cl \
	-o ../../../build/$(PREFIX)book_convolution.js

buffer_sample:
	$(call chdir,src/Chapter_7/SimpleBufferSubBuffer)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		simple.cpp \
	$(MODE) \
	--preload-file simple.cl \
	-o ../../../build/$(PREFIX)book_buffer.js

#not yet working
image_filter_sample:
	$(call chdir,src/Chapter_8/ImageFilter2D)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		ImageFilter2D.cpp \
		../../../externs/lib/libfreeimage-3.15.4.so \
	-I../../../externs/include/ \
	$(MODE) -s GL_FFP_ONLY=1 -s LEGACY_GL_EMULATION=1 \
	--preload-file data/lena.png \
	--preload-file ImageFilter2D.cl \
	-o ../../../build/$(PREFIX)book_image_filter.js

gl_interop_sample:
	$(call chdir,src/Chapter_10/GLinterop)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		GLinterop.cpp \
	$(MODE) -s GL_FFP_ONLY=1 -s LEGACY_GL_EMULATION=1 \
	--preload-file GLinterop.cl \
	-o ../../../build/$(PREFIX)book_gl_interop.js

#not yet working
sinewave_sample:
	$(call chdir,src/Chapter_12/Sinewave)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		bmpLoader.cpp \
		sinewave.cpp \
	$(MODE) -s TOTAL_MEMORY=1024*1024*50 -s GL_UNSAFE_OPTS=0 -s GL_MAX_TEMP_BUFFER_SIZE=8388608 -s GL_FFP_ONLY=1 -s LEGACY_GL_EMULATION=1 \
	--preload-file sinewave.cl \
	--preload-file ATIStream.bmp \
	-o ../../../build/$(PREFIX)book_sinewave.js

vectoradd_sample:
	$(call chdir,src/Chapter_12/VectorAdd)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		vecadd.cpp \
	$(MODE) \
	-o ../../../build/$(PREFIX)book_vecadd.js

histogram_sample:
	$(call chdir,src/Chapter_14/histogram)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		histogram.cpp \
	$(MODE) -s TOTAL_MEMORY=1024*1024*150 \
	--preload-file histogram_image.cl \
	-o ../../../build/$(PREFIX)book_histogram.js

dijkstra_sample:
	$(call chdir,src/Chapter_16/Dijkstra)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		oclDijkstra.cpp \
		oclDijkstraKernel.cpp \
		../../../externs/lib/libboost.o \
	$(MODE) -s TOTAL_MEMORY=1024*1024*150 \
	-I../../../externs/include/ \
	--preload-file dijkstra.cl \
	-o ../../../build/$(PREFIX)book_dijkstra.js

# Use OpenCV :(
flow_sample:
	$(call chdir,src/Chapter_19/oclFlow)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		flowGL.cpp \
		oclFlow.cpp \
	$(MODE) \
	--preload-file filters.cl \
	--preload-file lkflow.cl \
	--preload-file motion.cl \
	--preload-file data/minicooper/frame10.png \
	--preload-file data/minicooper/frame11.png \
	--preload-file data/minicooper/frame10.pgm \
	--preload-file data/minicooper/frame11.pgm \
	-o ../../../build/$(PREFIX)book_flow.js

spmv_sample:
	$(call chdir,src/Chapter_22/spmv)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 $(CXX) \
		matrix_gen.c \
		spmv.c \
	$(MODE) \
	--preload-file spmv.mm \
	--preload-file spmv.cl \
	-o ../../../build/$(PREFIX)book_spmv.js

clean:
	$(call chdir,build/)
	rm -rf tmp/	
	mkdir tmp
	cp memoryprofiler.js tmp/
	cp settings.js tmp/
	rm -f *.data
	rm -f *.js
	rm -f *.map
	cp tmp/memoryprofiler.js ./
	cp tmp/settings.js ./
	rm -rf tmp/
	$(CXX) --clear-cache

