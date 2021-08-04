
PROJECT         = rv32

VOBJDIR         = obj
SRCDIR          = src
VLIB            = lib${PROJECT}.a

CPP_BASE        = rv32i_cpu_elf.cpp rv32i_cpu.cpp rv32csr_cpu.cpp rv32m_cpu.cpp rv32a_cpu.cpp rv32f_cpu.cpp rv32d_cpu.cpp

VOBJS           = ${addprefix ${VOBJDIR}/, ${CPP_BASE:%.cpp=%.o}}

C++             = g++
CFLAGS          = -fPIC                                 \
                  -m32                                  \
                  -g                                    \
                  -I${SRCDIR}                           \
                  -D_REENTRANT

all: ${VLIB}

${VOBJDIR}/%.o: ${SRCDIR}/%.cpp ${SRCDIR}/*.h
	@${C++} -Wno-write-strings -c ${CFLAGS} $< -o $@

${VLIB} : ${VOBJS} ${VOBJDIR}
	@ar cr ${VLIB} ${VOBJS}

${VOBJS}: | ${VOBJDIR}

${VOBJDIR}:
	@mkdir ${VOBJDIR}
    
clean:
	@rm -rf ${VOBJDIR}
	@rm -f ${VLIB}