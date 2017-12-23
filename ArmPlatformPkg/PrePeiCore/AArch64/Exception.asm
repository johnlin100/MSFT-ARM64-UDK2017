;
;  Copyright (c) 2011-2014, ARM Limited. All rights reserved.
;  Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/Exception.S
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

    #include <Chipset/AArch64.h>
    #include <Base.h>
    #include <AutoGen.h>

    INCLUDE  AsmMacroIoLibV8.inc
    
    MACRO
    TO_HANDLER
    mrs    x1, CurrentEL
    cmp    x1, #0x8
    bgt    .
    beq    %F2
    cbnz   x1, %F1
    b      .              ;// We should never get here
1   mrs    x1, elr_el1    /* EL1 Exception Link Register */
    b      %F3
2   mrs    x1, elr_el2    /* EL2 Exception Link Register */
3   bl     PeiCommonExceptionEntry
    MEND
    
    MACRO
    VECTOR_SPACE_PAD $X
$X_end
    SPACE 0x80 - ($X_end - $X)
    MEND

    IMPORT  PeiCommonExceptionEntry
    EXPORT  PeiVectorTable

    // Set to DATA section because VS2017 link(14.12.25827) not allowed 128 byte alignment in CODE section.
    AREA    PrePeiCoreException, DATA, READONLY, ARM64, CODEALIGN, ALIGN=7
 
    ALIGN 128
  
//
// 0x0 - 0x180 
//
PeiVectorTable                // @todo  not finished
_DefaultSyncExceptHandler_t
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSyncExceptHandler_t

_DefaultIrq_t
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultIrq_t

_DefaultFiq_t
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultFiq_t

_DefaultSError_t
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSError_t

//
// 0x200 - 0x380
//
_DefaultSyncExceptHandler_h
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSyncExceptHandler_h

_DefaultIrq_h
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultIrq_h

_DefaultFiq_h
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultFiq_h

_DefaultSError_h
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSError_h

//
// 0x400 - 0x580
//
_DefaultSyncExceptHandler_LowerA64
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSyncExceptHandler_LowerA64

_DefaultIrq_LowerA64
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultIrq_LowerA64

_DefaultFiq_LowerA64
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultFiq_LowerA64

_DefaultSError_LowerA64
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSError_LowerA64

//
// 0x600 - 0x780
//
_DefaultSyncExceptHandler_LowerA32
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSyncExceptHandler_LowerA32

_DefaultIrq_LowerA32
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultIrq_LowerA32

_DefaultFiq_LowerA32
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultFiq_LowerA32

_DefaultSError_LowerA32
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  VECTOR_SPACE_PAD _DefaultSError_LowerA32

  END
