;------------------------------------------------------------------------------
;
; Copyright (c) 2006 - 2009, Intel Corporation. All rights reserved.<BR>
; Portions copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
; Portions copyright (c) 2011 - 2013, ARM Ltd. All rights reserved.<BR>
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/SwitchStack.S
;
; This program and the accompanying materials
; are licensed and made available under the terms and conditions of the BSD License
; which accompanies this distribution.  The full text of the license may be found at
; http://opensource.org/licenses/bsd-license.php.
;
; THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
; WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
;
;------------------------------------------------------------------------------

;#include <AsmMacroIoLibV8.h>

    INCLUDE AsmMacroIoLibV8.inc
    
    EXPORT SecSwitchStack

    AREA |.text$mn|, CODE, READONLY, ARM64

;/**
;  This allows the caller to switch the stack and return
;
; @param      StackDelta     Signed amount by which to modify the stack pointer
;
; @return     Nothing. Goes to the Entry Point passing in the new parameters
;
;**/
;VOID
;EFIAPI
;SecSwitchStack (
;  VOID  *StackDelta
;  )#
;

SecSwitchStack PROC
    mov   x1, sp
    add   x1, x0, x1
    mov   sp, x1
    ret
    ENDP
    
    END

