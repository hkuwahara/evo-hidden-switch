#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
GREP=grep
NM=nm
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc
CCC=g++
CXX=g++
FC=gfortran
AS=as

# Macros
CND_PLATFORM=GNU-Linux-x86
CND_DLIB_EXT=so
CND_CONF=Release
CND_DISTDIR=dist
CND_BUILDDIR=build

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=${CND_BUILDDIR}/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/src/uniformly_distributed_random_generator.o \
	${OBJECTDIR}/src/hash_table.o \
	${OBJECTDIR}/src/strconv.o \
	${OBJECTDIR}/src/main.o \
	${OBJECTDIR}/src/options.o \
	${OBJECTDIR}/src/bug.o \
	${OBJECTDIR}/src/log.o \
	${OBJECTDIR}/src/normally_distributed_random_generator.o \
	${OBJECTDIR}/src/vector.o \
	${OBJECTDIR}/src/environment.o \
	${OBJECTDIR}/src/exponentially_distributed_random_generator.o \
	${OBJECTDIR}/src/random_number_generator.o \
	${OBJECTDIR}/src/util.o \
	${OBJECTDIR}/src/linked_list.o \
	${OBJECTDIR}/src/evolution.o \
	${OBJECTDIR}/src/uniformly_distributed_discrete_random_generator.o


# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=-lm -lpthread

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	"${MAKE}"  -f nbproject/Makefile-${CND_CONF}.mk bin/noiseevol5

bin/noiseevol5: ${OBJECTFILES}
	${MKDIR} -p bin
	${LINK.c} -o bin/noiseevol5 ${OBJECTFILES} ${LDLIBSOPTIONS} 

${OBJECTDIR}/src/uniformly_distributed_random_generator.o: src/uniformly_distributed_random_generator.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/uniformly_distributed_random_generator.o src/uniformly_distributed_random_generator.c

${OBJECTDIR}/src/hash_table.o: src/hash_table.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/hash_table.o src/hash_table.c

${OBJECTDIR}/src/strconv.o: src/strconv.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/strconv.o src/strconv.c

${OBJECTDIR}/src/main.o: src/main.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/main.o src/main.c

${OBJECTDIR}/src/options.o: src/options.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/options.o src/options.c

${OBJECTDIR}/src/bug.o: src/bug.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/bug.o src/bug.c

${OBJECTDIR}/src/log.o: src/log.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/log.o src/log.c

${OBJECTDIR}/src/normally_distributed_random_generator.o: src/normally_distributed_random_generator.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/normally_distributed_random_generator.o src/normally_distributed_random_generator.c

${OBJECTDIR}/src/vector.o: src/vector.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/vector.o src/vector.c

${OBJECTDIR}/src/environment.o: src/environment.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/environment.o src/environment.c

${OBJECTDIR}/src/exponentially_distributed_random_generator.o: src/exponentially_distributed_random_generator.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/exponentially_distributed_random_generator.o src/exponentially_distributed_random_generator.c

${OBJECTDIR}/src/random_number_generator.o: src/random_number_generator.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/random_number_generator.o src/random_number_generator.c

${OBJECTDIR}/src/util.o: src/util.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/util.o src/util.c

${OBJECTDIR}/src/linked_list.o: src/linked_list.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/linked_list.o src/linked_list.c

${OBJECTDIR}/src/evolution.o: src/evolution.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/evolution.o src/evolution.c

${OBJECTDIR}/src/uniformly_distributed_discrete_random_generator.o: src/uniformly_distributed_discrete_random_generator.c 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.c) -O2 -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/uniformly_distributed_discrete_random_generator.o src/uniformly_distributed_discrete_random_generator.c

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${CND_BUILDDIR}/${CND_CONF}
	${RM} bin/noiseevol5

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
