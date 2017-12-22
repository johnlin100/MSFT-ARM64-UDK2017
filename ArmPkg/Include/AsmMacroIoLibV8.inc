;/** @file
;  Macros for MSFT ARMASM64
;
;  Copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
;  Portions copyright (c) 2011 - 2014, ARM Ltd. All rights reserved.<BR>
;  Copyright (c) 2016, Linaro Ltd. All rights reserved.<BR>
;  Modified from AsmMacroIoLibV8.h to meet MSFT ARMASM64 syntax.
;
;  This program and the accompanying materials
;  are licensed and made available under the terms and conditions of the BSD License
;  which accompanies this distribution.  The full text of the license may be found at
;  http://opensource.org/licenses/bsd-license.php
;
;  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
;  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
;
;**/


; CurrentEL : 0xC = EL3; 8 = EL2; 4 = EL1
; This only selects between EL1 and EL2, else we die.
; Provide the Macro with a safe temp xreg to use.
  MACRO
  EL1_OR_EL2   $SAFE_XREG, $L1="%F1", $L2="%F2"
  mrs    $SAFE_XREG, CurrentEL
  cmp    $SAFE_XREG, #0x8
  bgt    .
  beq    $L2
  cbnz   $SAFE_XREG, $L1
  b      .                    ; We should never get here
  MEND


; CurrentEL : 0xC = EL3; 8 = EL2; 4 = EL1
; This only selects between EL1 and EL2 and EL3, else we die.
; Provide the Macro with a safe temp xreg to use.
  MACRO
  EL1_OR_EL2_OR_EL3 $SAFE_XREG, $L1="%F1", $L2="%F2", $L3="%F3"
  mrs    $SAFE_XREG, CurrentEL
  cmp    $SAFE_XREG, #0x8
  bgt    $L3
  beq    $L2
  cbnz   $SAFE_XREG, $L1
  b      .
  MEND

  MACRO
  MOV32  $Reg, $Val
  movz   $Reg, ($Val) >> 16, lsl #16
  movk   $Reg, ($Val) & 0xffff
  MEND

  MACRO
  MOV64  $Reg, $Val
  movz   $Reg, ($Val) >> 48, lsl #48
  movk   $Reg, (($Val) >> 32) & 0xffff, lsl #32
  movk   $Reg, (($Val) >> 16) & 0xffff, lsl #16
  movk   $Reg, ($Val) & 0xffff
  MEND

  END