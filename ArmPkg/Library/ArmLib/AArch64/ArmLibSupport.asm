;------------------------------------------------------------------------------
;
; Copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
; Copyright (c) 2011 - 2016, ARM Limited. All rights reserved.
; Copyright (c) 2016, Linaro Limited. All rights reserved.
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from ArmLibSupport.S
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

    INCLUDE AsmMacroIoLibV8.inc
    INCLUDE AsmMacroExportV8.inc

DAIF_RD_FIQ_BIT  EQU   (1 << 6)
DAIF_RD_IRQ_BIT  EQU   (1 << 7)

 MSFT_ASM_EXPORT ArmReadMidr
  mrs     x0, midr_el1        // Read from Main ID Register (MIDR)
  ret

 MSFT_ASM_EXPORT ArmCacheInfo
  mrs     x0, ctr_el0         // Read from Cache Type Regiter (CTR)
  ret

 MSFT_ASM_EXPORT ArmGetInterruptState
  mrs     x0, daif
  tst     w0, #DAIF_RD_IRQ_BIT  // Check if IRQ is enabled. Enabled if 0 (Z=1)
  cseteq  w0                    // if Z=1 return 1, else 0
  ret

 MSFT_ASM_EXPORT ArmGetFiqState
  mrs     x0, daif
  tst     w0, #DAIF_RD_FIQ_BIT  // Check if FIQ is enabled. Enabled if 0 (Z=1)
  cseteq  w0                    // if Z=1 return 1, else 0
  ret

 MSFT_ASM_EXPORT ArmWriteCpacr
  msr     cpacr_el1, x0      // Coprocessor Access Control Reg (CPACR)
  ret

 MSFT_ASM_EXPORT ArmWriteAuxCr
   EL1_OR_EL2 x1, %F1, %F2
1  msr     actlr_el1, x0      // Aux Control Reg (ACTLR) at EL1. Also available in EL2 and EL3
   ret
2  msr     actlr_el2, x0      // Aux Control Reg (ACTLR) at EL1. Also available in EL2 and EL3
   // DCB     0x20, 0x10, 0x1c, 0xd5
   ret

 MSFT_ASM_EXPORT ArmReadAuxCr
   EL1_OR_EL2 x1, %F1, %F2
1  mrs     x0, actlr_el1      // Aux Control Reg (ACTLR) at EL1. Also available in EL2 and EL3
   ret
2  mrs     x0, actlr_el2      // Aux Control Reg (ACTLR) at EL1. Also available in EL2 and EL3
   // DCB     0x20, 0x10, 0x3c, 0xd5
   ret

 MSFT_ASM_EXPORT ArmSetTTBR0
   EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1  msr     ttbr0_el1, x0      // Translation Table Base Reg 0 (TTBR0)
   b       %F4
2  msr     ttbr0_el2, x0      // Translation Table Base Reg 0 (TTBR0)
   b       %F4
3  msr     ttbr0_el3, x0      // Translation Table Base Reg 0 (TTBR0)
   // DCB     0x00, 0x20, 0x1e, 0xd5
4  isb     sy
   ret


 MSFT_ASM_EXPORT ArmGetTTBR0BaseAddress
   EL1_OR_EL2 x1, %F1, %F2
1  mrs     x0, ttbr0_el1
   b       %F3
2  mrs     x0, ttbr0_el2
3  and     x0, x0, 0xFFFFFFFFFFFF  /* Look at bottom 48 bits */
   isb     sy
   ret

 MSFT_ASM_EXPORT ArmGetTCR
   EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1  mrs     x0, tcr_el1
   b       %F4
2  mrs     x0, tcr_el2
   b       %F4
3  mrs     x0, tcr_el3
   // DCB     0x40, 0x20, 0x3e, 0xd5
4  isb     sy
   ret

 MSFT_ASM_EXPORT ArmSetTCR
   EL1_OR_EL2_OR_EL3  x1, %F1, %F2, %F3
1  msr     tcr_el1, x0
   b       %F4
2  msr     tcr_el2, x0
   b       %F4
3  msr     tcr_el3, x0
   // DCB     0x40, 0x20, 0x1e, 0xd5
4  isb     sy
   ret

 MSFT_ASM_EXPORT ArmGetMAIR
    EL1_OR_EL2_OR_EL3  x1, %F1, %F2, %F3
1   mrs     x0, mair_el1
    b       %F4
2   mrs     x0, mair_el2
    b       %F4
3   mrs     x0, mair_el3
    // DCB     0x00, 0xa2, 0x3e, 0xd5
4   isb     sy
    ret

 MSFT_ASM_EXPORT ArmSetMAIR
    EL1_OR_EL2_OR_EL3  x1, %F1, %F2, %F3
1   msr     mair_el1, x0
    b       %F4
2   msr     mair_el2, x0
    b       %F4
3   msr     mair_el3, x0
    // DCB     0x00, 0xa2, 0x1e, 0xd5
4   isb     sy
    ret


//
//VOID
//ArmUpdateTranslationTableEntry (
//  IN VOID  *TranslationTableEntry  // X0
//  IN VOID  *MVA                    // X1
//  );
 MSFT_ASM_EXPORT ArmUpdateTranslationTableEntry
   dc      civac, x0             // Clean and invalidate data line
   dsb     sy
     EL1_OR_EL2_OR_EL3  x0, %F1, %F2, %F3
1    tlbi    vaae1, x1             // TLB Invalidate VA , EL1
     b       %F4
2    tlbi    vae2, x1              // TLB Invalidate VA , EL2
     b       %F4
3    tlbi    vae3, x1              // TLB Invalidate VA , EL3
4    dsb     sy
     isb     sy
     ret

 MSFT_ASM_EXPORT ArmInvalidateTlb
     EL1_OR_EL2_OR_EL3 x0, %F1, %F2, %F3
1    tlbi  VMALLE1
     // DCB   0x1f, 0x87, 0x08, 0xd5
     b     %F4
2    tlbi  alle2
     b     %F4
3    tlbi  alle3
4    dsb   sy
     isb   sy
     ret

 MSFT_ASM_EXPORT ArmWriteCptr
  msr     cptr_el3, x0           // EL3 Coprocessor Trap Reg (CPTR)
  ret

 MSFT_ASM_EXPORT ArmWriteScr
  msr     scr_el3, x0            // Secure configuration register EL3
  isb     sy
  ret

 MSFT_ASM_EXPORT ArmWriteMVBar
  msr    vbar_el3, x0            // Exception Vector Base address for Monitor on EL3
  // DCB     0x00, 0xc0, 0x1e, 0xd5
  ret

 MSFT_ASM_EXPORT ArmCallWFE
  wfe
  ret

 MSFT_ASM_EXPORT ArmCallSEV
  sev
  ret

 MSFT_ASM_EXPORT ArmReadCpuActlr
  // @todo mrs   x0, s3_1_c15_c2_0
  DCB   0x00, 0xf2, 0x39, 0xd5   // Use byte code because MSFT ARMASM64 not support yet.
  ret

 MSFT_ASM_EXPORT ArmWriteCpuActlr
  // @todo ;msr   s3_1_c15_c2_0, x0
  DCB   0x00, 0xf2, 0x19, 0xd5   // Use byte code because MSFT ARMASM64 not support yet.
  dsb   sy
  isb   sy
  ret

 MSFT_ASM_EXPORT ArmReadSctlr
    EL1_OR_EL2_OR_EL3  x1, %F1, %F2, %F3
1   mrs   x0, sctlr_el1
    ret
2   mrs   x0, sctlr_el2
    ret
3   mrs   x0, sctlr_el3
4   ret


  END
