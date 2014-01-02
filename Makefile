#
#  Makefile
#
#  Created by Anthony Liot.
#  Copyright (c) 2013 Anthony Liot. All rights reserved.
#

EMCC:=../../../../webcl-translator/emscripten
FREEIMAGE:=/Volumes/APPLE_MEDIA/WORKSPACE/webcl/FreeImage
BOOST:=../../boost_1_55_0

EMSCRIPTEN = $(EMCC)
CXX = $(EMSCRIPTEN)/emcc
AR = $(EMSCRIPTEN)/emar
EMCONFIGURE = $(EMSCRIPTEN)/emconfigure
EMMAKE = $(EMSCRIPTEN)/emmake

CHDIR_SHELL := $(SHELL)
define chdir
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

DEB=0
VAL=0

ifeq ($(VAL),1)
PREFIX = val_
VALIDATOR = '[""]' # Enable validator without parameter
$(info ************  Mode VALIDATOR : Enabled ************)
else
PREFIX = 
VALIDATOR = '[]' # disable validator
$(info ************  Mode VALIDATOR : Disabled ************)
endif

DEBUG = -O0 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s CL_PRINT_TRACE=1 -s DISABLE_EXCEPTION_CATCHING=0 -s WARN_ON_UNDEFINED_SYMBOLS=1 -s CL_PROFILE=1 -s CL_DEBUG=1 -s CL_GRAB_TRACE=1 -s CL_CHECK_VALID_OBJECT=1

NO_DEBUG = -02 -s CL_VALIDATOR=$(VAL) -s CL_VAL_PARAM=$(VALIDATOR) -s WARN_ON_UNDEFINED_SYMBOLS=0 -s CL_PROFILE=1 -s CL_DEBUG=0 -s CL_GRAB_TRACE=0 -s CL_PRINT_TRACE=0 -s CL_CHECK_VALID_OBJECT=0

ifeq ($(DEB),1)
MODE=$(DEBUG)
EMCCDEBUG = EMCC_DEBUG
$(info ************  Mode DEBUG : Enabled ************)
else
MODE=$(NO_DEBUG)
EMCCDEBUG = EMCCDEBUG
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

FREEIMAGE_INC = \
	-I$(FREEIMAGE)/Source/\
	-I$(FREEIMAGE)/Source/DeprecationManager/\
	-I$(FREEIMAGE)/Source/FreeImage\
	-I$(FREEIMAGE)/Source/FreeImageToolkit/\
	-I$(FREEIMAGE)/Source/LibJPEG/\
	-I$(FREEIMAGE)/Source/LibMNG/\
	-I$(FREEIMAGE)/Source/LibOpenJPEG/\
	-I$(FREEIMAGE)/Source/LibPNG/\
	-I$(FREEIMAGE)/Source/LibRawLite/\
	-I$(FREEIMAGE)/Source/LibTIFF/\
	-I$(FREEIMAGE)/Source/LibTIFF4/\
	-I$(FREEIMAGE)/Source/Metadata/\
	-I$(FREEIMAGE)/Source/OpenEXR/\
	-I$(FREEIMAGE)/Source/OpenEXR/Half/\
	-I$(FREEIMAGE)/Source/OpenEXR/Iex/\
	-I$(FREEIMAGE)/Source/OpenEXR/IlmImf/\
	-I$(FREEIMAGE)/Source/OpenEXR/IlmThread/\
	-I$(FREEIMAGE)/Source/OpenEXR/Imath/\
	-I$(FREEIMAGE)/Source/ZLib/

FREEIMAGE_SRC = \
	$(FREEIMAGE)/Source/DeprecationManager/Deprecated.cpp \
	$(FREEIMAGE)/Source/DeprecationManager/DeprecationMgr.cpp \
	\
	$(FREEIMAGE)/Source/FreeImage/BitmapAccess.cpp \
	$(FREEIMAGE)/Source/FreeImage/CacheFile.cpp \
	$(FREEIMAGE)/Source/FreeImage/ColorLookup.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion4.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion8.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion16_555.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion16_565.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion24.cpp \
	$(FREEIMAGE)/Source/FreeImage/Conversion32.cpp \
	$(FREEIMAGE)/Source/FreeImage/ConversionFloat.cpp \
	$(FREEIMAGE)/Source/FreeImage/ConversionRGB16.cpp \
	$(FREEIMAGE)/Source/FreeImage/ConversionRGBF.cpp \
	$(FREEIMAGE)/Source/FreeImage/ConversionType.cpp \
	$(FREEIMAGE)/Source/FreeImage/ConversionUINT16.cpp \
	$(FREEIMAGE)/Source/FreeImage/FreeImage.cpp \
	$(FREEIMAGE)/Source/FreeImage/FreeImageC.c \
	$(FREEIMAGE)/Source/FreeImage/FreeImageIO.cpp \
	$(FREEIMAGE)/Source/FreeImage/GetType.cpp \
	$(FREEIMAGE)/Source/FreeImage/Halftoning.cpp \
	$(FREEIMAGE)/Source/FreeImage/J2KHelper.cpp \
	$(FREEIMAGE)/Source/FreeImage/MemoryIO.cpp \
	$(FREEIMAGE)/Source/FreeImage/MNGHelper.cpp \
	$(FREEIMAGE)/Source/FreeImage/MultiPage.cpp \
	$(FREEIMAGE)/Source/FreeImage/NNQuantizer.cpp \
	$(FREEIMAGE)/Source/FreeImage/PixelAccess.cpp \
	$(FREEIMAGE)/Source/FreeImage/Plugin.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginBMP.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginCUT.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginDDS.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginEXR.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginG3.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginGIF.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginHDR.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginICO.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginIFF.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginJ2K.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginJNG.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginJP2.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginJPEG.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginKOALA.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginMNG.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPCD.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPCX.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPFM.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPICT.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPNG.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPNM.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginPSD.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginRAS.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginRAW.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginSGI.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginTARGA.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginTIFF.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginWBMP.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginXBM.cpp \
	$(FREEIMAGE)/Source/FreeImage/PluginXPM.cpp \
	$(FREEIMAGE)/Source/FreeImage/PSDParser.cpp \
	$(FREEIMAGE)/Source/FreeImage/TIFFLogLuv.cpp \
	$(FREEIMAGE)/Source/FreeImage/tmoColorConvert.cpp \
	$(FREEIMAGE)/Source/FreeImage/tmoDrago03.cpp \
	$(FREEIMAGE)/Source/FreeImage/tmoFattal02.cpp \
	$(FREEIMAGE)/Source/FreeImage/tmoReinhard05.cpp \
	$(FREEIMAGE)/Source/FreeImage/ToneMapping.cpp \
	$(FREEIMAGE)/Source/FreeImage/WuQuantizer.cpp \
	$(FREEIMAGE)/Source/FreeImage/ZLibInterface.cpp \
	\
	$(FREEIMAGE)/Source/FreeImageToolkit/Background.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/BSplineRotate.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/Channels.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/ClassicRotate.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/Colors.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/CopyPaste.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/Display.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/Flip.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/JPEGTransform.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/MultigridPoissonSolver.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/Rescale.cpp \
	$(FREEIMAGE)/Source/FreeImageToolkit/Resize.cpp \
	\
	$(FREEIMAGE)/Source/LibJPEG/ansi2knr.c \
	$(FREEIMAGE)/Source/LibJPEG/cjpeg.c \
	$(FREEIMAGE)/Source/LibJPEG/ckconfig.c \
	$(FREEIMAGE)/Source/LibJPEG/djpeg.c \
	$(FREEIMAGE)/Source/LibJPEG/jaricom.c \
	$(FREEIMAGE)/Source/LibJPEG/jcapimin.c \
	$(FREEIMAGE)/Source/LibJPEG/jcapistd.c \
	$(FREEIMAGE)/Source/LibJPEG/jcarith.c \
	$(FREEIMAGE)/Source/LibJPEG/jccoefct.c \
	$(FREEIMAGE)/Source/LibJPEG/jccolor.c \
	$(FREEIMAGE)/Source/LibJPEG/jcdctmgr.c \
	$(FREEIMAGE)/Source/LibJPEG/jchuff.c \
	$(FREEIMAGE)/Source/LibJPEG/jcinit.c \
	$(FREEIMAGE)/Source/LibJPEG/jcmainct.c \
	$(FREEIMAGE)/Source/LibJPEG/jcmarker.c \
	$(FREEIMAGE)/Source/LibJPEG/jcmaster.c \
	$(FREEIMAGE)/Source/LibJPEG/jcomapi.c \
	$(FREEIMAGE)/Source/LibJPEG/jcparam.c \
	$(FREEIMAGE)/Source/LibJPEG/jcprepct.c \
	$(FREEIMAGE)/Source/LibJPEG/jcsample.c \
	$(FREEIMAGE)/Source/LibJPEG/jctrans.c \
	$(FREEIMAGE)/Source/LibJPEG/jdapimin.c \
	$(FREEIMAGE)/Source/LibJPEG/jdapistd.c \
	$(FREEIMAGE)/Source/LibJPEG/jdarith.c \
	$(FREEIMAGE)/Source/LibJPEG/jdatadst.c \
	$(FREEIMAGE)/Source/LibJPEG/jdatasrc.c \
	$(FREEIMAGE)/Source/LibJPEG/jdcoefct.c \
	$(FREEIMAGE)/Source/LibJPEG/jdcolor.c \
	$(FREEIMAGE)/Source/LibJPEG/jddctmgr.c \
	$(FREEIMAGE)/Source/LibJPEG/jdhuff.c \
	$(FREEIMAGE)/Source/LibJPEG/jdinput.c \
	$(FREEIMAGE)/Source/LibJPEG/jdmainct.c \
	$(FREEIMAGE)/Source/LibJPEG/jdmarker.c \
	$(FREEIMAGE)/Source/LibJPEG/jdmaster.c \
	$(FREEIMAGE)/Source/LibJPEG/jdmerge.c \
	$(FREEIMAGE)/Source/LibJPEG/jdpostct.c \
	$(FREEIMAGE)/Source/LibJPEG/jdsample.c \
	$(FREEIMAGE)/Source/LibJPEG/jdtrans.c \
	$(FREEIMAGE)/Source/LibJPEG/jerror.c \
	$(FREEIMAGE)/Source/LibJPEG/jfdctflt.c \
	$(FREEIMAGE)/Source/LibJPEG/jfdctfst.c \
	$(FREEIMAGE)/Source/LibJPEG/jfdctint.c \
	$(FREEIMAGE)/Source/LibJPEG/jidctflt.c \
	$(FREEIMAGE)/Source/LibJPEG/jidctfst.c \
	$(FREEIMAGE)/Source/LibJPEG/jidctint.c \
	$(FREEIMAGE)/Source/LibJPEG/jmemansi.c \
	$(FREEIMAGE)/Source/LibJPEG/jmemmgr.c \
	$(FREEIMAGE)/Source/LibJPEG/jmemname.c \
	$(FREEIMAGE)/Source/LibJPEG/jmemnobs.c \
	$(FREEIMAGE)/Source/LibJPEG/jpegtran.c \
	$(FREEIMAGE)/Source/LibJPEG/jquant1.c \
	$(FREEIMAGE)/Source/LibJPEG/jquant2.c \
	$(FREEIMAGE)/Source/LibJPEG/jutils.c \
	$(FREEIMAGE)/Source/LibJPEG/rdbmp.c \
	$(FREEIMAGE)/Source/LibJPEG/rdcolmap.c \
	$(FREEIMAGE)/Source/LibJPEG/rdgif.c \
	$(FREEIMAGE)/Source/LibJPEG/rdppm.c \
	$(FREEIMAGE)/Source/LibJPEG/rdrle.c \
	$(FREEIMAGE)/Source/LibJPEG/rdswitch.c \
	$(FREEIMAGE)/Source/LibJPEG/rdtarga.c \
	$(FREEIMAGE)/Source/LibJPEG/transupp.c \
	$(FREEIMAGE)/Source/LibJPEG/wrbmp.c \
	$(FREEIMAGE)/Source/LibJPEG/wrgif.c \
	$(FREEIMAGE)/Source/LibJPEG/wrppm.c \
	$(FREEIMAGE)/Source/LibJPEG/wrrle.c \
	$(FREEIMAGE)/Source/LibJPEG/wrtarga.c \
	\
	$(FREEIMAGE)/Source/LibMNG/libmng_callback_xs.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_chunk_descr.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_chunk_io.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_chunk_prc.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_chunk_xs.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_cms.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_display.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_dither.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_error.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_filter.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_hlapi.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_jpeg.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_object_prc.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_pixels.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_prop_xs.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_read.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_trace.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_write.c \
	$(FREEIMAGE)/Source/LibMNG/libmng_zlib.c \
	$(FREEIMAGE)/Source/LibMNG/_FI_3151_PluginMNG.cpp \
	\
	$(FREEIMAGE)/Source/LibOpenJPEG/bio.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/cidx_manager.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/cio.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/dwt.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/event.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/image.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/j2k_lib.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/j2k.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/jp2.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/jpt.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/mct.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/mqc.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/openjpeg.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/phix_manager.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/pi.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/ppix_manager.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/raw.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/t1_generate_luts.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/t1.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/t2.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/tcd.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/tgt.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/thix_manager.c \
	$(FREEIMAGE)/Source/LibOpenJPEG/tpix_manager.c \
	\
	$(FREEIMAGE)/Source/LibPNG/png.c \
	$(FREEIMAGE)/Source/LibPNG/pngerror.c \
	$(FREEIMAGE)/Source/LibPNG/pngget.c \
	$(FREEIMAGE)/Source/LibPNG/pngmem.c \
	$(FREEIMAGE)/Source/LibPNG/pngpread.c \
	$(FREEIMAGE)/Source/LibPNG/pngread.c \
	$(FREEIMAGE)/Source/LibPNG/pngrio.c \
	$(FREEIMAGE)/Source/LibPNG/pngrtran.c \
	$(FREEIMAGE)/Source/LibPNG/pngrutil.c \
	$(FREEIMAGE)/Source/LibPNG/pngset.c \
	$(FREEIMAGE)/Source/LibPNG/pngtest.c \
	$(FREEIMAGE)/Source/LibPNG/pngtrans.c \
	$(FREEIMAGE)/Source/LibPNG/pngwio.c \
	$(FREEIMAGE)/Source/LibPNG/pngwrite.c \
	$(FREEIMAGE)/Source/LibPNG/pngwtran.c \
	$(FREEIMAGE)/Source/LibPNG/pngwutil.c \
	\
	$(FREEIMAGE)/Source/LibRawLite/internal/dcraw_common.cpp \
	$(FREEIMAGE)/Source/LibRawLite/internal/dcraw_fileio.cpp \
	$(FREEIMAGE)/Source/LibRawLite/internal/demosaic_packs.cpp \
	$(FREEIMAGE)/Source/LibRawLite/src/libraw_c_api.cpp \
	$(FREEIMAGE)/Source/LibRawLite/src/libraw_cxx.cpp \
	$(FREEIMAGE)/Source/LibRawLite/src/libraw_datastream.cpp \
	\
	$(FREEIMAGE)/Source/LibTIFF/mkg3states.c \
	$(FREEIMAGE)/Source/LibTIFF/mkspans.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_aux.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_close.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_codec.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_color.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_compress.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_dir.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_dirinfo.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_dirread.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_dirwrite.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_dumpmode.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_error.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_extension.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_fax3.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_fax3sm.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_flush.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_getimage.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_jbig.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_jpeg.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_luv.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_lzw.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_msdos.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_next.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_ojpeg.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_open.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_packbits.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_pixarlog.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_predict.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_print.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_read.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_strip.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_swab.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_thunder.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_tile.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_unix.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_version.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_vms.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_warning.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_win3.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_win32.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_wince.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_write.c \
	$(FREEIMAGE)/Source/LibTIFF/tif_zip.c \
	$(FREEIMAGE)/Source/LibTIFF/_FI_3151_PluginG3.cpp \
	$(FREEIMAGE)/Source/LibTIFF/_FI_3151_PluginTIFF.cpp \
	$(FREEIMAGE)/Source/LibTIFF/_FI_3151_XTIFF.cpp \
	$(FREEIMAGE)/Source/LibTIFF/tif_stream.cxx \
	\
	$(FREEIMAGE)/Source/LibTIFF4/mkg3states.c \
	$(FREEIMAGE)/Source/LibTIFF4/mkspans.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_aux.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_close.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_codec.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_color.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_compress.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_dir.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_dirinfo.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_dirread.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_dirwrite.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_dumpmode.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_error.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_extension.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_fax3.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_fax3sm.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_flush.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_getimage.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_jbig.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_jpeg_12.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_jpeg.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_luv.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_lzma.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_lzw.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_next.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_ojpeg.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_open.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_packbits.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_pixarlog.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_predict.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_print.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_read.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_strip.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_swab.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_thunder.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_tile.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_unix.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_version.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_vms.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_warning.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_win32.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_wince.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_write.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_zip.c \
	$(FREEIMAGE)/Source/LibTIFF4/tif_stream.cxx \
	\
	$(FREEIMAGE)/Source/Metadata/Exif.cpp \
	$(FREEIMAGE)/Source/Metadata/FIRational.cpp \
	$(FREEIMAGE)/Source/Metadata/FreeImageTag.cpp \
	$(FREEIMAGE)/Source/Metadata/IPTC.cpp \
	$(FREEIMAGE)/Source/Metadata/TagConversion.cpp \
	$(FREEIMAGE)/Source/Metadata/TagLib.cpp \
	$(FREEIMAGE)/Source/Metadata/XTIFF.cpp \
	\
	$(FREEIMAGE)/Source/OpenEXR/Half/eLut.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Half/half.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Half/toFloat.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Iex/IexBaseExc.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Iex/IexThrowErrnoExc.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/b44ExpLogTable.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfAcesFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfB44Compressor.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfBoxAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfChannelList.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfChannelListAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfChromaticities.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfChromaticitiesAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfCompressionAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfCompressor.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfConvert.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfCRgbaFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfDoubleAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfEnvmap.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfEnvmapAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfFloatAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfFrameBuffer.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfFramesPerSecond.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfHeader.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfHuf.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfInputFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfIntAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfIO.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfKeyCode.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfKeyCodeAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfLineOrderAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfLut.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfMatrixAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfMisc.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfMultiView.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfOpaqueAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfOutputFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfPizCompressor.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfPreviewImage.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfPreviewImageAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfPxr24Compressor.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfRational.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfRationalAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfRgbaFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfRgbaYca.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfRleCompressor.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfScanLineInputFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfStandardAttributes.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfStdIO.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfStringAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfStringVectorAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTestFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfThreading.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTileDescriptionAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTiledInputFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTiledMisc.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTiledOutputFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTiledRgbaFile.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTileOffsets.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTimeCode.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfTimeCodeAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfVecAttribute.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfVersion.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfWav.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmImf/ImfZipCompressor.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathBox.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathColorAlgo.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathFun.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathMatrixAlgo.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathRandom.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathShear.cpp \
	$(FREEIMAGE)/Source/OpenEXR/Imath/ImathVec.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThread.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadMutex.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadMutexPosix.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadMutexWin32.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadPool.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadPosix.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadSemaphore.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadSemaphorePosix.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadSemaphorePosixCompat.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadSemaphoreWin32.cpp \
	$(FREEIMAGE)/Source/OpenEXR/IlmThread/IlmThreadWin32.cpp \
	\
	$(FREEIMAGE)/Source/ZLib/adler32.c \
	$(FREEIMAGE)/Source/ZLib/compress.c \
	$(FREEIMAGE)/Source/ZLib/crc32.c \
	$(FREEIMAGE)/Source/ZLib/deflate.c \
	$(FREEIMAGE)/Source/ZLib/gzclose.c \
	$(FREEIMAGE)/Source/ZLib/gzlib.c \
	$(FREEIMAGE)/Source/ZLib/gzread.c \
	$(FREEIMAGE)/Source/ZLib/gzwrite.c \
	$(FREEIMAGE)/Source/ZLib/infback.c \
	$(FREEIMAGE)/Source/ZLib/inffast.c \
	$(FREEIMAGE)/Source/ZLib/inflate.c \
	$(FREEIMAGE)/Source/ZLib/inftrees.c \
	$(FREEIMAGE)/Source/ZLib/trees.c \
	$(FREEIMAGE)/Source/ZLib/uncompr.c \
	$(FREEIMAGE)/Source/ZLib/zutil.c

#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#
# BUILD
#----------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------#		

all: build_lib all_1 all_2 all_3

all_1: \
	hello_world_sample \
	info_sample \
	convolution_sample \
	buffer_sample \

all_2: \
	image_filter_sample \
	gl_interop_sample \
	sinewave_sample \
	vectoradd_sample \

all_3: \
	histogram_sample \
	dijkstra_sample \
	spmv_sample \

#	flow_sample \

build_lib:
	$(call chdir,libs/)
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 ../../webcl-translator/emscripten/emcc $(BOOST_SRC) -I$(BOOST)/ -o libboost.o	
	JAVA_HEAP_SIZE=8096m $(EMCCDEBUG)=1 ../../webcl-translator/emscripten/emcc $(FREEIMAGE_SRC) $(FREEIMAGE_INC) -o libfreeimage.o

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
	-I$(FREEIMAGE)/Source \
	$(MODE) \
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
	$(MODE) -s LEGACY_GL_EMULATION=1 -s GL_UNSAFE_OPTS=0 \
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
		../../../libs/libboost.o \
	$(MODE) \
	-I../../$(BOOST)/ \
	--preload-file dijkstra.cl \
	-o ../../../build/$(PREFIX)book_dijkstra.js

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
	../../webcl-translator/emscripten/emcc --clear-cache

