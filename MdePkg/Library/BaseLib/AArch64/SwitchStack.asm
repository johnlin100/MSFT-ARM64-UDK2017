//------------------------------------------------------------------------------
//
// Copyright (c) 2006 - 2009, Intel Corporation. All rights reserved.<BR>
// Portions copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
// Portions copyright (c) 2011 - 2013, ARM Limited. All rights reserved.<BR>
// Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/SwitchStack.S
//
// This program and the accompanying materials
// are licensed and made available under the terms and conditions of the BSD License
// which accompanies this distribution.  The full text of the license may be found at
// http://opensource.org/licenses/bsd-license.php.
//
// THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
// WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
//
//------------------------------------------------------------------------------

    EXPORT InternalSwitchStackAsm
    EXPORT CpuPause
            
    AREA |.text$mn|, CODE, READONLY, ARM64, CODEALIGN, ALIGN=5
    ALIGN  32

/**
//
//  This allows the caller to switch the stack and goes to the new entry point
//
// @param      EntryPoint   The pointer to the location to enter
// @param      Context      Parameter to pass in
// @param      Context2     Parameter2 to pass in
// @param      NewStack     New Location of the stack
//
// @return     Nothing. Goes to the Entry Point passing in the new parameters
//
VOID
EFIAPI
InternalSwitchStackAsm (
  SWITCH_STACK_ENTRY_POINT EntryPoint,
  VOID  *Context,
  VOID  *Context2,
  VOID  *NewStack
  );
**/
InternalSwitchStackAsm FUNCTION
    mov   x29, #0
    mov   x30, x0
    mov   sp, x3
    mov   x0, x1
    mov   x1, x2
    ret
    ENDFUNC

/**
//
//  Requests CPU to pause for a short period of time.
//
//  Requests CPU to pause for a short period of time. Typically used in MP
//  systems to prevent memory starvation while waiting for a spin lock.
//
VOID
EFIAPI
CpuPause (
  VOID
  )
**/
CpuPause FUNCTION
    nop
    nop
    nop
    nop
    nop
    ret
    ENDFUNC
    
    END
