;
;  Copyright (c) 2011-2013, ARM Limited. All rights reserved.
;  Copyright (c) 2016, Linaro Limited. All rights reserved.
;  Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/VirtHelper.S
;
;  This program and the accompanying materials
;  are licensed and made available under the terms and conditions of the BSD License
;  which accompanies this distribution.  The full text of the license may be found at
;  http://opensource.org/licenses/bsd-license.php
;
;  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
;  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
;
;


    #include <Library/ArmLib.h>
    #include <AutoGen.h>
    INCLUDE AsmMacroIoLibV8.inc
    
    EXPORT ArmPlatformPeiBootAction
    EXPORT ArmPlatformGetPrimaryCoreMpId
    EXPORT ArmPlatformIsPrimaryCore
    EXPORT ArmPlatformGetCorePosition
    EXPORT ArmGetPhysAddrTop
    
    AREA |.text$mn|, CODE, READONLY, ARM64

ArmPlatformPeiBootAction PROC
  ret
  ENDP

//UINTN
//ArmPlatformGetPrimaryCoreMpId (
//  VOID
//  );
ArmPlatformGetPrimaryCoreMpId PROC
  MOV32  w0, FixedPcdGet32 (PcdArmPrimaryCore)
  ret
  ENDP

//UINTN
//ArmPlatformIsPrimaryCore (
//  IN UINTN MpId
//  );
ArmPlatformIsPrimaryCore PROC
  mov   x0, #1
  ret
  ENDP

//UINTN
//ArmPlatformGetCorePosition (
//  IN UINTN MpId
//  );
// With this function: CorePos = (ClusterId * 4) + CoreId
ArmPlatformGetCorePosition PROC
  and   x1, x0, #ARM_CORE_MASK
  and   x0, x0, #ARM_CLUSTER_MASK
  add   x0, x1, x0, LSR #6
  ret
  ENDP

//EFI_PHYSICAL_ADDRESS
//GetPhysAddrTop (
//  VOID
//  );
ArmGetPhysAddrTop PROC
  mrs   x0, id_aa64mmfr0_el1
  adr   x1, LPARanges
  and   x0, x0, #7
  ldrb  w1, [x1, x0]
  mov   x0, #1
  lsl   x0, x0, x1
  ret
  ENDP

//
// Bits 0..2 of the AA64MFR0_EL1 system register encode the size of the
// physical address space support on this CPU:
// 0 == 32 bits, 1 == 36 bits, etc etc
// 6 and 7 are reserved
//
LPARanges
  DCB 32, 36, 40, 42, 44, 48, -1, -1

  END
