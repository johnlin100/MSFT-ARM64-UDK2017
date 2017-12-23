;------------------------------------------------------------------------------
;
; Copyright (c) 2011 - 2013, ARM Ltd. All rights reserved.<BR>
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/DebugAgentException.S
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

    MACRO
    VECTOR_SPACE_PAD $X
$X_end
    SPACE 0x80 - ($X_end - $X)
    MEND
    
    EXPORT DebugAgentVectorTable
    
    // Set to DATA section because VS2017 link(14.12.25827) not allowed 128 byte alignment in code segment
    AREA DebugAgentException, DATA, READONLY, ARM64, CODEALIGN, ALIGN=7

//
// Current EL with SP0 : 0x0 - 0x180
//
  ALIGN 128
DebugAgentVectorTable
SynchronousExceptionSP0
  b   SynchronousExceptionSP0
  VECTOR_SPACE_PAD SynchronousExceptionSP0
  
IrqSP0
  b   IrqSP0
  VECTOR_SPACE_PAD IrqSP0
  
FiqSP0
  b   FiqSP0
  VECTOR_SPACE_PAD FiqSP0
  
SErrorSP0
  b   SErrorSP0
  VECTOR_SPACE_PAD SErrorSP0

//
// Current EL with SPx: 0x200 - 0x380
//
SynchronousExceptionSPx
  b   SynchronousExceptionSPx
  VECTOR_SPACE_PAD SynchronousExceptionSPx

IrqSPx
  b IrqSPx
  VECTOR_SPACE_PAD IrqSPx
  
FiqSPx
  b FiqSPx
  VECTOR_SPACE_PAD FiqSPx
  
SErrorSPx
  b SErrorSPx
  VECTOR_SPACE_PAD SErrorSPx
  
//
// Lower EL using AArch64 : 0x400 - 0x580
//
SynchronousExceptionA64
  b   SynchronousExceptionA64
  VECTOR_SPACE_PAD SynchronousExceptionA64

IrqA64
  b   IrqA64
  VECTOR_SPACE_PAD IrqA64

FiqA64
  b   FiqA64
  VECTOR_SPACE_PAD FiqA64

SErrorA64
  b   SErrorA64
  VECTOR_SPACE_PAD SErrorA64

//
// Lower EL using AArch32 : 0x600 - 0x780
//
SynchronousExceptionA32
  b   SynchronousExceptionA32
  VECTOR_SPACE_PAD SynchronousExceptionA32

IrqA32
  b   IrqA32
  VECTOR_SPACE_PAD IrqA32

FiqA32
  b   FiqA32
  VECTOR_SPACE_PAD FiqA32

SErrorA32
  b   SErrorA32
  VECTOR_SPACE_PAD SErrorA32

    END
