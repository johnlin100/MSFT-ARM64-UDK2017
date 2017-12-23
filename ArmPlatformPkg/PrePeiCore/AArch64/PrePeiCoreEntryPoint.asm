//
//  Copyright (c) 2011-2014, ARM Limited. All rights reserved.
//  Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/PrePeiCoreEntryPoint.S
//
//  This program and the accompanying materials
//  are licensed and made available under the terms and conditions of the BSD License
//  which accompanies this distribution.  The full text of the license may be found at
//  http://opensource.org/licenses/bsd-license.php
//
//  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
//  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
//
//

    INCLUDE AsmMacroIoLibV8.inc

    EXPORT _ModuleEntryPoint

    IMPORT ArmPlatformPeiBootAction
    IMPORT CEntryPoint
    IMPORT SetupExceptionLevel1
    IMPORT SetupExceptionLevel2
    IMPORT ArmReadMpidr
    IMPORT ArmPlatformIsPrimaryCore
    IMPORT ArmPlatformGetCorePosition
    
TOP_OF_PRIMARY_STACK EQU  (FixedPcdGet64(PcdCPUCoresStackBase) + FixedPcdGet32(PcdCPUCorePrimaryStackSize))
    
    AREA |.text$mn|, CODE, READONLY, ARM64

_ModuleEntryPoint
  // Do early platform specific actions
  bl    ArmPlatformPeiBootAction

// NOTE: We could be booting from EL3, EL2 or EL1. Need to correctly detect
//       and configure the system accordingly. EL2 is default if possible.
// If we started in EL3 we need to switch and run at EL2.
// If we are running at EL2 stay in EL2
// If we are starting at EL1 stay in EL1.

// If started at EL3 Sec is run and switches to EL2 before jumping to PEI.
// If started at EL1 or EL2 Sec jumps directly to PEI without making any
// changes.

// Which EL are we running at? Every EL needs some level of setup
// We should not run this code in EL3
    EL1_OR_EL2 x0, %F1, %F2
1   bl    SetupExceptionLevel1
    b     MainEntryPoint
2   bl    SetupExceptionLevel2
    b     MainEntryPoint

MainEntryPoint
  // Identify CPU ID
  bl    ArmReadMpidr
  // Keep a copy of the MpId register value
  mov   x5, x0

  // Is it the Primary Core ?
  bl    ArmPlatformIsPrimaryCore

  // Get the top of the primary stacks (and the base of the secondary stacks)
  MOV64 x1, TOP_OF_PRIMARY_STACK

  // x0 is equal to 1 if I am the primary core
  cmp   x0, #1
  beq    _SetupPrimaryCoreStack

_SetupSecondaryCoreStack
  // x1 contains the base of the secondary stacks

  // Get the Core Position
  mov   x6, x1      // Save base of the secondary stacks
  mov   x0, x5
  bl    ArmPlatformGetCorePosition
  // The stack starts at the top of the stack region. Add '1' to the Core Position to get the top of the stack
  add   x0, x0, #1

  // StackOffset = CorePos * StackSize
  MOV32 x2, FixedPcdGet32(PcdCPUCoreSecondaryStackSize)
  mul   x0, x0, x2
  // SP = StackBase + StackOffset
  add   sp, x6, x0

_PrepareArguments
  // The PEI Core Entry Point has been computed by GenFV and stored in the second entry of the Reset Vector
  MOV64 x2, FixedPcdGet64(PcdFvBaseAddress)
  ldr   x1, [x2, #8]

  // Move sec startup address into a data register
  // Ensure we're jumping to FV version of the code (not boot remapped alias)
  ldr   x3, =CEntryPoint

  // Jump to PrePeiCore C code
  //    x0 = mp_id
  //    x1 = pei_core_address
  mov   x0, x5
  blr   x3

_SetupPrimaryCoreStack
  mov   sp, x1
  b     _PrepareArguments
  
  END
