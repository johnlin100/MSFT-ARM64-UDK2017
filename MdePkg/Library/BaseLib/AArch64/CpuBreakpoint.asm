;------------------------------------------------------------------------------
;
; CpuBreakpoint() for AArch64
;
; Copyright (c) 2006 - 2009, Intel Corporation. All rights reserved.<BR>
; Portions copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
; Portions copyright (c) 2011 - 2013, ARM Ltd. All rights reserved.<BR>
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/CpuBreakpoint.S
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

    EXPORT CpuBreakpoint

    AREA |.text$mn|, CODE, READONLY, ARM64, CODEALIGN, ALIGN=2
    ALIGN 4

;/**
;  Generates a breakpoint on the CPU.
;
;  Generates a breakpoint on the CPU. The breakpoint must be implemented such
;  that code can resume normal execution after the breakpoint.
;
;**/
;VOID
;EFIAPI
;CpuBreakpoint (
;  VOID
;  );
;
CpuBreakpoint FUNCTION
    SVC    0xDBDB //56283   // Superviser exception. Takes 16bit arg -> Armv7 had 'swi' here.
    ret
    ENDFUNC
    
    END