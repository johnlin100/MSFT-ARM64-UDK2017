//------------------------------------------------------------------------------
//
// Copyright (c) 2011 - 2013, ARM Limited. All rights reserved.
// Copyright (c) 2016, Linaro Limited. All rights reserved.
// Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64ArchTimerSupport.S
//
// This program and the accompanying materials
// are licensed and made available under the terms and conditions of the BSD License
// which accompanies this distribution.  The full text of the license may be found at
// http://opensource.org/licenses/bsd-license.php
//
// THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
// WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
//
//------------------------------------------------------------------------------

    INCLUDE AsmMacroExportV8.inc

 MSFT_ASM_EXPORT ArmReadCntFrq
  mrs   x0, cntfrq_el0           // Read CNTFRQ
  // DCB 0x00, 0xe0, 0x3b, 0xd5
  ret


// NOTE - Can only write while at highest implemented EL level (EL3 on model). Else ReadOnly (EL2, EL1, EL0)
 MSFT_ASM_EXPORT ArmWriteCntFrq
  msr   cntfrq_el0, x0           // Write to CNTFRQ
  // DCB 0x00, 0xe0, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntPct
  mrs   x0, cntpct_el0           // Read CNTPCT (Physical counter register)
  // DCB 0x20, 0xe0, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntkCtl
  mrs   x0, cntkctl_el1          // Read CNTK_CTL (Timer PL1 Control Register)
  // DCB 0x00, 0xe1, 0x38, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntkCtl
  msr   cntkctl_el1, x0          // Write to CNTK_CTL (Timer PL1 Control Register)
  // DCB 0x00, 0xe1, 0x18, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntpTval
  mrs   x0, cntp_tval_el0        // Read CNTP_TVAL (PL1 physical timer value register)
  // DCB 0x00, 0xe2, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntpTval
  msr   cntp_tval_el0, x0        // Write to CNTP_TVAL (PL1 physical timer value register)
  // DCB 0x00, 0xe2, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntpCtl
  mrs   x0, cntp_ctl_el0         // Read CNTP_CTL (PL1 Physical Timer Control Register)
  // DCB 0x20, 0xe2, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntpCtl
  msr   cntp_ctl_el0, x0         // Write to  CNTP_CTL (PL1 Physical Timer Control Register)
  // DCB 0x20, 0xe2, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntvTval
  mrs   x0, cntv_tval_el0        // Read CNTV_TVAL (Virtual Timer Value register)
  // DCB 0x00, 0xe3, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntvTval
  msr   cntv_tval_el0, x0        // Write to CNTV_TVAL (Virtual Timer Value register)
  // DCB 0x00, 0xe3, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntvCtl
  mrs   x0, cntv_ctl_el0         // Read CNTV_CTL (Virtual Timer Control Register)
  // DCB 0x20, 0xe3, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntvCtl
 msr   cntv_ctl_el0, x0         // Write to CNTV_CTL (Virtual Timer Control Register)
  // DCB 0x20, 0xe3, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntvCt
  mrs  x0, cntvct_el0            // Read CNTVCT  (Virtual Count Register)
  // DCB 0x40, 0xe0, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntpCval
  mrs   x0, cntp_cval_el0        // Read CNTP_CTVAL (Physical Timer Compare Value Register)
  // DCB 0x40, 0xe2, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntpCval
  msr   cntp_cval_el0, x0        // Write to CNTP_CTVAL (Physical Timer Compare Value Register)
  // DCB 0x40, 0xe2, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntvCval
  mrs   x0, cntv_cval_el0        // Read CNTV_CTVAL (Virtual Timer Compare Value Register)
  // DCB 0x40, 0xe3, 0x3b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntvCval
  msr   cntv_cval_el0, x0        // write to  CNTV_CTVAL (Virtual Timer Compare Value Register)
  // DCB 0x40, 0xe3, 0x1b, 0xd5
  ret


 MSFT_ASM_EXPORT ArmReadCntvOff
  mrs   x0, cntvoff_el2          // Read CNTVOFF (virtual Offset register)
  // DCB 0x60, 0xe0, 0x3c, 0xd5
  ret


 MSFT_ASM_EXPORT ArmWriteCntvOff
  msr   cntvoff_el2, x0          // Write to CNTVOFF (Virtual Offset register)
  // DCB 0x60, 0xe0, 0x1c, 0xd5
  ret


 END
