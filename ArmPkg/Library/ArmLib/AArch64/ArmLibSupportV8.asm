;------------------------------------------------------------------------------
;
; Copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
; Copyright (c) 2011 - 2014, ARM Limited. All rights reserved.
; Copyright (c) 2016, Linaro Limited. All rights reserved.
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from ArmLibSupportV8.S
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

MPIDR_U_BIT  EQU    (30)
MPIDR_U_MASK EQU    (1 << MPIDR_U_BIT)

// DAIF bit definitions for writing through msr daifclr/sr daifset
DAIF_WR_FIQ_BIT    EQU   (1 << 0)
DAIF_WR_IRQ_BIT    EQU   (1 << 1)
DAIF_WR_ABORT_BIT  EQU   (1 << 2)
DAIF_WR_DEBUG_BIT  EQU   (1 << 3)
DAIF_WR_INT_BITS   EQU   (DAIF_WR_FIQ_BIT | DAIF_WR_IRQ_BIT)
DAIF_WR_ALL_TEMP   EQU   (DAIF_WR_DEBUG_BIT | DAIF_WR_ABORT_BIT)  //@wa to fix compiler bug
DAIF_WR_ALL        EQU   (DAIF_WR_ALL_TEMP | DAIF_WR_INT_BITS)

 MSFT_ASM_EXPORT ArmIsMpCore
  mrs   x0, mpidr_el1         // Read EL1 Mutliprocessor Affinty Reg (MPIDR)
  and   x0, x0, #MPIDR_U_MASK // U Bit clear, the processor is part of a multiprocessor system
  lsr   x0, x0, #MPIDR_U_BIT
  eor   x0, x0, #1
  ret


 MSFT_ASM_EXPORT ArmEnableAsynchronousAbort
  msr   daifclr, #DAIF_WR_ABORT_BIT
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmDisableAsynchronousAbort
  msr   daifset, #DAIF_WR_ABORT_BIT
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmEnableIrq
  msr   daifclr, #DAIF_WR_IRQ_BIT
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmDisableIrq
  msr   daifset, #DAIF_WR_IRQ_BIT
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmEnableFiq
  msr   daifclr, #DAIF_WR_FIQ_BIT
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmDisableFiq
  msr   daifset, #DAIF_WR_FIQ_BIT
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmEnableInterrupts
  msr   daifclr, #DAIF_WR_INT_BITS
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmDisableInterrupts
  msr   daifset, #DAIF_WR_INT_BITS
  isb   sy
  ret


 MSFT_ASM_EXPORT ArmDisableAllExceptions
  msr   daifset, #DAIF_WR_ALL
  isb   sy
  ret


// UINT32
// ReadCCSIDR (
//   IN UINT32 CSSELR
//   )
 MSFT_ASM_EXPORT ReadCCSIDR
  msr   csselr_el1, x0        // Write Cache Size Selection Register (CSSELR)
  isb   sy
  mrs   x0, ccsidr_el1        // Read current Cache Size ID Register (CCSIDR)
  ret


// UINT32
// ReadCLIDR (
//   IN UINT32 CSSELR
//   )
 MSFT_ASM_EXPORT ReadCLIDR
  mrs   x0, clidr_el1         // Read Cache Level ID Register
  ret

  END
