
# This is a GNU Makefile.

# It can be used to compile an OpenCL program with
# the Altera Beta OpenCL Development Kit.
# See README.txt for more information.


# You must configure ALTERAOCLSDKROOT to point the root directory of the Altera SDK for OpenCL
# software installation.
# See doc/getting_started.txt for more information on installing and
# configuring the Altera SDK for OpenCL.


# Creating a static library
TARGET = pagerank 

# Where is the Altera SDK for OpenCL software?
# ifeq ($(wildcard $(ALTERAOCLSDKROOT)),)
# $(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation)
# endif
# ifeq ($(wildcard $(ALTERAOCLSDKROOT)/host/include/CL/opencl.h),)
# $(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation.)
# endif

# Libraries to use, objects to compile
SRCS = ./src/baseline.cc ./src/common.linux.cc ./src/deviceInfoQuery.cc ./src/edge_centric.cc ./src/pagerank.cc ./src/power.cc
SRCS_FILES = $(foreach F, $(SRCS), ./$(F)) 
OBJS=$(SRCS:.c=.o)

AOCL_SRCS = ./src/baseline.cc ./src/common.cc ./src/deviceInfoQuery.cc ./src/edge_centric.cc ./src/pagerank.cc ./src/power.cc
AOCL_SRCS_FILES = $(foreach F, $(AOCL_SRCS), ./$(F)) 
AOCL_OBJS=$(AOCL_SRCS:.c=.o)

COMMON_FILES = ./common/src/AOCL_Utils.cpp
CXX_FLAGS =-lm -O3

# arm cross compiler
CROSS-COMPILE = arm-linux-gnueabihf-

# OpenCL compile and link flags.
COMPILE_CONFIG=-I./inc -I./common/inc 
LINK_CONFIG=-lOpenCL

AOCL_COMPILE_CONFIG=$(shell aocl compile-config --arm) -I./inc -I./common/inc
AOCL_LINK_CONFIG=$(shell aocl link-config --arm) 

# Make it all!
all: 
	$ g++ $(SRCS_FILES) $(COMMON_FILES) $(CXX_FLAGS) -o $(TARGET)  $(COMPILE_CONFIG) $(LINK_CONFIG)

fpgapagerank :
	$(CROSS-COMPILE)g++ $(AOCL_SRCS_FILES) $(COMMON_FILES) $(CXX_FLAGS) -o $(TARGET)  $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG) 

edge_centric.aocx: 
	aoc ./device/edge_centric.cl -o edge_centric.aocx --board de1soc_sharedonly

power.aocx:
	aoc ./device/power.cl -o power.aocx --board de1soc_sharedonly

# Standard make targets
clean :
	@rm -f *.o $(TARGET)
