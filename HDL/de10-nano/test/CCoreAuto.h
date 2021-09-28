/*
 * CCoreAuto.h
 *
 * >>> AUTO-GENERATED. DO NOT EDIT. <<<
 *
 */

#include <stdint.h>

#ifdef HDL_SIM
extern "C" uint32_t read_ext  (uint32_t addr, uint32_t* data);
extern "C" void     write_ext (uint32_t addr, uint32_t  data);
#endif

#ifndef CCORE_AUTO_H_
#define CCORE_AUTO_H_

#include "core.h"

class CCoreAuto
{
    
private:
    // Single point read and write access methods to memory (allows overriding)
#ifdef HDL_SIM
    inline static uint32_t readReg (volatile uint32_t* p_addr)               {uint32_t addr, val; addr = (uint64_t)p_addr; read_ext(addr, &val); return val;};
    inline static void     writeReg(volatile uint32_t* p_addr, uint32_t val) {uint32_t addr = (uint64_t)p_addr; write_ext(addr, val);};
#else
    inline static uint32_t readReg (volatile uint32_t* p_addr)               {return *p_addr;};
    inline static void     writeReg(volatile uint32_t* p_addr, uint32_t val) {*p_addr = val;};
#endif

    // Internal register class definitions
    class CControl
    {
    public:
        CControl(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetControl(){return CCoreAuto::readReg(m_pvCsrBaseAddr + CSR_CORE_CONTROL/4);}
        inline uint32_t GetClrHalt(){return (GetControl() & CSR_CORE_CONTROL_CLR_HALT_MASK) >> CSR_CORE_CONTROL_CLR_HALT;}
        inline void SetClrHalt(uint32_t val){CCoreAuto::writeReg(m_pvCsrBaseAddr + CSR_CORE_CONTROL/4, ((GetControl() & ~CSR_CORE_CONTROL_CLR_HALT_MASK) | ((val << CSR_CORE_CONTROL_CLR_HALT) & CSR_CORE_CONTROL_CLR_HALT_MASK)));}
        inline uint32_t GetHaltOnAddr(){return (GetControl() & CSR_CORE_CONTROL_HALT_ON_ADDR_MASK) >> CSR_CORE_CONTROL_HALT_ON_ADDR;}
        inline void SetHaltOnAddr(uint32_t val){CCoreAuto::writeReg(m_pvCsrBaseAddr + CSR_CORE_CONTROL/4, ((GetControl() & ~CSR_CORE_CONTROL_HALT_ON_ADDR_MASK) | ((val << CSR_CORE_CONTROL_HALT_ON_ADDR) & CSR_CORE_CONTROL_HALT_ON_ADDR_MASK)));}
        inline uint32_t GetHaltOnUnimp(){return (GetControl() & CSR_CORE_CONTROL_HALT_ON_UNIMP_MASK) >> CSR_CORE_CONTROL_HALT_ON_UNIMP;}
        inline void SetHaltOnUnimp(uint32_t val){CCoreAuto::writeReg(m_pvCsrBaseAddr + CSR_CORE_CONTROL/4, ((GetControl() & ~CSR_CORE_CONTROL_HALT_ON_UNIMP_MASK) | ((val << CSR_CORE_CONTROL_HALT_ON_UNIMP) & CSR_CORE_CONTROL_HALT_ON_UNIMP_MASK)));}
        inline void SetControl(uint32_t val){CCoreAuto::writeReg(m_pvCsrBaseAddr + CSR_CORE_CONTROL/4, val);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CStatus
    {
    public:
        CStatus(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetStatus(){return CCoreAuto::readReg(m_pvCsrBaseAddr + CSR_CORE_STATUS/4);}
        inline uint32_t GetHalted(){return (GetStatus() & CSR_CORE_STATUS_HALTED_MASK) >> CSR_CORE_STATUS_HALTED;}
        inline uint32_t GetReset(){return (GetStatus() & CSR_CORE_STATUS_RESET_MASK) >> CSR_CORE_STATUS_RESET;}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CHaltAddr
    {
    public:
        CHaltAddr(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetHaltAddr(){return CCoreAuto::readReg(m_pvCsrBaseAddr + CSR_CORE_HALT_ADDR/4);}
        inline void SetHaltAddr(uint32_t val){CCoreAuto::writeReg(m_pvCsrBaseAddr + CSR_CORE_HALT_ADDR/4, val);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CGp
    {
    public:
        CGp(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetGp(){return CCoreAuto::readReg(m_pvCsrBaseAddr + CSR_CORE_GP/4);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    
public:
    // Constructor. Create register objects relative to the passed in base address
    CCoreAuto(uint32_t* csrBaseAddr = 0)
    {
        m_pvCsrBaseAddr = csrBaseAddr;

        pControl = new CControl(csrBaseAddr + CSR_CORE_LOCAL/4);
        pStatus = new CStatus(csrBaseAddr + CSR_CORE_LOCAL/4);
        pHaltAddr = new CHaltAddr(csrBaseAddr + CSR_CORE_LOCAL/4);
        pGp = new CGp(csrBaseAddr + CSR_CORE_LOCAL/4);
    };
    
public:
    
    // Pointers to the register objects
    CControl* pControl;
    CStatus* pStatus;
    CHaltAddr* pHaltAddr;
    CGp* pGp;
    
    // Pointers to the sub-block objects
    
    // Provide access to the base address used for this object
    inline volatile uint32_t* GetCsrBaseAddr() {return m_pvCsrBaseAddr;}
    
private:
    volatile uint32_t* m_pvCsrBaseAddr;
};

#endif /* CCORE_AUTO_H_ */
