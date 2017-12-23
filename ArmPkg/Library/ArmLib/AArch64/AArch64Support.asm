;------------------------------------------------------------------------------
;
; Copyright (c) 2008 - 2010, Apple Inc. All rights reserved.<BR>
; Copyright (c) 2011 - 2014, ARM Limited. All rights reserved.
; Copyright (c) 2016, Linaro Limited. All rights reserved.
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64Support.S
;
; This program and the accompanying materials
; are licensed and made available under the terms and conditions of the BSD License
; which accompanies this distribution.  The full text of the license may be found at
; http://opensource.org/licenses/bsd-license.php
;
; THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
; WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
;
;------------------------------------------------------------------------------

#include <Chipset/AArch64.h>

    INCLUDE AsmMacroIoLibV8.inc
    INCLUDE AsmMacroExport.inc
    INCLUDE AsmMacroExportV8.inc

CTRL_M_BIT     EQU  (1 << 0)
CTRL_A_BIT     EQU  (1 << 1)
CTRL_C_BIT     EQU  (1 << 2)
CTRL_SA_BIT    EQU  (1 << 3)
CTRL_I_BIT     EQU  (1 << 12)
CTRL_V_BIT     EQU  (1 << 12)
CPACR_VFP_BITS EQU  (3 << 20)

CTRL_MASK_TEMP EQU  (CTRL_M_BIT | CTRL_C_BIT)
CTRL_MASK_ALL  EQU ~(CTRL_MASK_TEMP | CTRL_I_BIT)

 MSFT_ASM_EXPORT ArmInvalidateDataCacheEntryByMVA
  dc      ivac, x0    // Invalidate single data cache line
  ret


 MSFT_ASM_EXPORT ArmCleanDataCacheEntryByMVA
  dc      cvac, x0    // Clean single data cache line
  ret


 MSFT_ASM_EXPORT ArmCleanDataCacheEntryToPoUByMVA
  dc      cvau, x0    // Clean single data cache line to PoU
  ret

 MSFT_ASM_EXPORT ArmInvalidateInstructionCacheEntryToPoUByMVA
  ic      ivau, x0    // Invalidate single instruction cache line to PoU
  ret


 MSFT_ASM_EXPORT ArmCleanInvalidateDataCacheEntryByMVA
  dc      civac, x0   // Clean and invalidate single data cache line
  ret


 MSFT_ASM_EXPORT ArmInvalidateDataCacheEntryBySetWay
  dc      isw, x0     // Invalidate this line
  ret


 MSFT_ASM_EXPORT ArmCleanInvalidateDataCacheEntryBySetWay
  dc      cisw, x0    // Clean and Invalidate this line
  ret


 MSFT_ASM_EXPORT ArmCleanDataCacheEntryBySetWay
  dc      csw, x0     // Clean this line
  ret


 MSFT_ASM_EXPORT ArmInvalidateInstructionCache
  ic      iallu       // Invalidate entire instruction cache
  dsb     sy
  isb     sy
  ret


 MSFT_ASM_EXPORT ArmEnableMmu
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1       // Read System control register EL1
     b       %F4
2    mrs     x0, sctlr_el2       // Read System control register EL2
     b       %F4
3    mrs     x0, sctlr_el3       // Read System control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    orr     x0, x0, #CTRL_M_BIT // Set MMU enable bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    tlbi    VMALLE1
     // DCB     0x1f, 0x87, 0x08, 0xd5
     dsb     nsh
     isb     sy
     msr     sctlr_el1, x0       // Write back
     b       %F4
2    tlbi    alle2
     dsb     nsh
     isb     sy
     msr     sctlr_el2, x0       // Write back
     b       %F4
3    tlbi    alle3
     dsb     nsh
     isb     sy
     msr     sctlr_el3, x0       // Write back
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    isb     sy
     ret


 MSFT_ASM_EXPORT ArmDisableMmu
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Read System Control Register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Read System Control Register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Read System Control Register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    and     x0, x0, #~CTRL_M_BIT  // Clear MMU enable bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back
     tlbi    VMALLE1
     // DCB     0x1f, 0x87, 0x08, 0xd5
     b       %F4
2    msr     sctlr_el2, x0        // Write back
     tlbi    alle2
     b       %F4
3    msr     sctlr_el3, x0        // Write back
     // DCB     0x00, 0x10, 0x1e, 0xd5
     tlbi    alle3
4    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmDisableCachesAndMmu
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    mov     x1, #CTRL_MASK_ALL   // Disable MMU, D & I caches
     and     x0, x0, x1
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmMmuEnabled
    EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1   mrs     x0, sctlr_el1        // Get control register EL1
    b       %F4
2   mrs     x0, sctlr_el2        // Get control register EL2
    b       %F4
3   mrs     x0, sctlr_el3        // Get control register EL3
    // DCB     0x00, 0x10, 0x3e, 0xd5
4   and     x0, x0, #CTRL_M_BIT
    ret


 MSFT_ASM_EXPORT ArmEnableDataCache
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    orr     x0, x0, #CTRL_C_BIT  // Set C bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmDisableDataCache
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    and     x0, x0, #~CTRL_C_BIT  // Clear C bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmEnableInstructionCache
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    orr     x0, x0, #CTRL_I_BIT  // Set I bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmDisableInstructionCache
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    and     x0, x0, #~CTRL_I_BIT  // Clear I bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmEnableAlignmentCheck
     EL1_OR_EL2 x1, %F1, %F2
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F3
2    mrs     x0, sctlr_el2        // Get control register EL2
3    orr     x0, x0, #CTRL_A_BIT  // Set A (alignment check) bit
     EL1_OR_EL2 x1, %F1, %F2
1    msr     sctlr_el1, x0        // Write back control register
     b       %F3
2    msr     sctlr_el2, x0        // Write back control register
3    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmDisableAlignmentCheck
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    and     x0, x0, #~CTRL_A_BIT  // Clear A (alignment check) bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret

 MSFT_ASM_EXPORT ArmEnableStackAlignmentCheck
     EL1_OR_EL2 x1, %F1, %F2
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F3
2    mrs     x0, sctlr_el2        // Get control register EL2
3    orr     x0, x0, #CTRL_SA_BIT // Set SA (stack alignment check) bit
     EL1_OR_EL2 x1, %F1, %F2
1    msr     sctlr_el1, x0        // Write back control register
     b       %F3
2    msr     sctlr_el2, x0        // Write back control register
3    dsb     sy
     isb     sy
     ret


 MSFT_ASM_EXPORT ArmDisableStackAlignmentCheck
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs     x0, sctlr_el1        // Get control register EL1
     b       %F4
2    mrs     x0, sctlr_el2        // Get control register EL2
     b       %F4
3    mrs     x0, sctlr_el3        // Get control register EL3
     // DCB     0x00, 0x10, 0x3e, 0xd5
4    bic     x0, x0, #CTRL_SA_BIT // Clear SA (stack alignment check) bit
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     sctlr_el1, x0        // Write back control register
     b       %F4
2    msr     sctlr_el2, x0        // Write back control register
     b       %F4
3    msr     sctlr_el3, x0        // Write back control register
     // DCB     0x00, 0x10, 0x1e, 0xd5
4    dsb     sy
     isb     sy
     ret


// Always turned on in AArch64. Else implementation specific. Leave in for C compatibility for now
 MSFT_ASM_EXPORT ArmEnableBranchPrediction
  ret


// Always turned on in AArch64. Else implementation specific. Leave in for C compatibility for now.
 MSFT_ASM_EXPORT ArmDisableBranchPrediction
  ret


 MSFT_ASM_EXPORT AArch64AllDataCachesOperation
// We can use regs 0-7 and 9-15 without having to save/restore.
// Save our link register on the stack. - The stack must always be quad-word aligned
  stp   x29, x30, [sp, #-16]!
  mov   x29, sp
  mov   x1, x0                  // Save Function call in x1
  mrs   x6, clidr_el1           // Read EL1 CLIDR
  and   x3, x6, #0x7000000      // Mask out all but Level of Coherency (LoC)
  lsr   x3, x3, #23             // Left align cache level value - the level is shifted by 1 to the
                                // right to ease the access to CSSELR and the Set/Way operation.
  cbz   x3, L_Finished          // No need to clean if LoC is 0
  mov   x10, #0                 // Start clean at cache level 0

Loop1
  add   x2, x10, x10, lsr #1    // Work out 3x cachelevel for cache info
  lsr   x12, x6, x2             // bottom 3 bits are the Cache type for this level
  and   x12, x12, #7            // get those 3 bits alone
  cmp   x12, #2                 // what cache at this level?
  blt   L_Skip                  // no cache or only instruction cache at this level
  msr   csselr_el1, x10         // write the Cache Size selection register with current level (CSSELR)
  isb   sy                      // isb to sync the change to the CacheSizeID reg
  mrs   x12, ccsidr_el1         // reads current Cache Size ID register (CCSIDR)
  and   x2, x12, #0x7           // extract the line length field
  add   x2, x2, #4              // add 4 for the line length offset (log2 16 bytes)
  mov   x4, #0x400
  sub   x4, x4, #1
  and   x4, x4, x12, lsr #3     // x4 is the max number on the way size (right aligned)
  clz   w5, w4                  // w5 is the bit position of the way size increment
  mov   x7, #0x00008000
  sub   x7, x7, #1
  and   x7, x7, x12, lsr #13    // x7 is the max number of the index size (right aligned)

Loop2
  mov   x9, x4                  // x9 working copy of the max way size (right aligned)

Loop3
  lsl   x11, x9, x5
  orr   x0, x10, x11            // factor in the way number and cache number
  lsl   x11, x7, x2
  orr   x0, x0, x11             // factor in the index number

  blr   x1                      // Goto requested cache operation

  subs  x9, x9, #1              // decrement the way number
  bge   Loop3
  subs  x7, x7, #1              // decrement the index
  bge   Loop2
L_Skip
  add   x10, x10, #2            // increment the cache number
  cmp   x3, x10
  bgt   Loop1

L_Finished
  dsb   sy
  isb   sy
  ldp   x29, x30, [sp], #0x10
  ret


 MSFT_ASM_EXPORT ArmDataMemoryBarrier
  dmb   sy
  ret


 MSFT_ASM_EXPORT ArmDataSynchronizationBarrier
  dsb   sy
  ret


 MSFT_ASM_EXPORT ArmInstructionSynchronizationBarrier
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmWriteVBar
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr   vbar_el1, x0            // Set the Address of the EL1 Vector Table in the VBAR register
     b     %F4
2    msr   vbar_el2, x0            // Set the Address of the EL2 Vector Table in the VBAR register
     b     %F4
3    msr   vbar_el3, x0            // Set the Address of the EL3 Vector Table in the VBAR register
     // DCB   0x00, 0xc0, 0x1e, 0xd5
4    isb   sy
     ret

 MSFT_ASM_EXPORT ArmReadVBar
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    mrs   x0, vbar_el1            // Set the Address of the EL1 Vector Table in the VBAR register
     ret
2    mrs   x0, vbar_el2            // Set the Address of the EL2 Vector Table in the VBAR register
     ret
3    mrs   x0, vbar_el3            // Set the Address of the EL3 Vector Table in the VBAR register
     // DCB   0x00, 0xc0, 0x3e, 0xd5
     ret


 MSFT_ASM_EXPORT ArmEnableVFP
    // Check whether floating-point is implemented in the processor.
    mov   x1, x30                 // Save LR
    bl    ArmReadIdPfr0           // Read EL1 Processor Feature Register (PFR0)
    mov   x30, x1                 // Restore LR
    ands  x0, x0, #AARCH64_PFR0_FP// Extract bits indicating VFP implementation
    cmp   x0, #0                  // VFP is implemented if '0'.
    bne   %F4                      // Exit if VFP not implemented.
    // FVP is implemented.
    // Make sure VFP exceptions are not trapped (to any exception level).
    mrs   x0, cpacr_el1           // Read EL1 Coprocessor Access Control Register (CPACR)
    orr   x0, x0, #CPACR_VFP_BITS // Disable FVP traps to EL1
    msr   cpacr_el1, x0           // Write back EL1 Coprocessor Access Control Register (CPACR)
    mov   x1, #AARCH64_CPTR_TFP   // TFP Bit for trapping VFP Exceptions
    EL1_OR_EL2_OR_EL3 x2, %F1, %F2, %F3
1   ret                           // Not configurable in EL1
2   mrs   x0, cptr_el2            // Disable VFP traps to EL2
    // DCB   0x40, 0x11, 0x3c, 0xd5
    bic   x0, x0, x1
    msr   cptr_el2, x0
    // DCB   0x40, 0x11, 0x1c, 0xd5
    ret
3   mrs   x0, cptr_el3            // Disable VFP traps to EL3
    bic   x0, x0, x1
    msr   cptr_el3, x0
4   ret


 MSFT_ASM_EXPORT ArmCallWFI
  wfi
  ret


 MSFT_ASM_EXPORT ArmReadMpidr
  mrs   x0, mpidr_el1           // read EL1 MPIDR
  ret


// Keep old function names for C compatibilty for now. Change later?
 MSFT_ASM_EXPORT ArmReadTpidrurw
  mrs   x0, tpidr_el0           // read tpidr_el0 (v7 TPIDRURW) -> (v8 TPIDR_EL0)
  ret


// Keep old function names for C compatibilty for now. Change later?
 MSFT_ASM_EXPORT ArmWriteTpidrurw
  msr   tpidr_el0, x0           // write tpidr_el0 (v7 TPIDRURW) -> (v8 TPIDR_EL0)
  ret


// Arch timers are mandatory on AArch64
 MSFT_ASM_EXPORT ArmIsArchTimerImplemented
  mov   x0, #1
  ret


 MSFT_ASM_EXPORT ArmReadIdPfr0
  mrs   x0, id_aa64pfr0_el1   // Read ID_AA64PFR0 Register
  ret


// Q: id_aa64pfr1_el1 not defined yet. What does this funtion want to access?
// A: used to setup arch timer. Check if we have security extensions, permissions to set stuff.
//    See: ArmPkg/Library/ArmArchTimerLib/AArch64/ArmArchTimerLib.c
//    Not defined yet, but stick in here for now, should read all zeros.
 MSFT_ASM_EXPORT ArmReadIdPfr1
  mrs   x0, id_aa64pfr1_el1   // Read ID_PFR1 Register
  ret

// VOID ArmWriteHcr(UINTN Hcr)
 MSFT_ASM_EXPORT ArmWriteHcr
  msr   hcr_el2, x0        // Write the passed HCR value
  ret

// UINTN ArmReadHcr(VOID)
 MSFT_ASM_EXPORT ArmReadHcr
  mrs   x0, hcr_el2
  ret

// UINTN ArmReadCurrentEL(VOID)
 MSFT_ASM_EXPORT ArmReadCurrentEL
  mrs   x0, CurrentEL
  ret

  END
