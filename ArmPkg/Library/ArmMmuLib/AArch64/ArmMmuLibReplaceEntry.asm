;------------------------------------------------------------------------------
;
; Copyright (c) 2016, Linaro Limited. All rights reserved.
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from ArmMmuLibReplaceEntry.S
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
    
    EXPORT ArmReplaceLiveTranslationEntry
    EXPORT ArmReplaceLiveTranslationEntrySize

CTRL_M_BIT        EQU      (1 << 0)
ARM_REPLACE_SIZE  EQU (ArmReplaceLiveTranslationEntrySize - ArmReplaceLiveTranslationEntry)

    MACRO
    __replace_entry  $el

    // disable the MMU
    mrs   x8, sctlr_el$el
    bic   x9, x8, #CTRL_M_BIT
    msr   sctlr_el$el, x9
    isb   sy

    // write updated entry
    str   x1, [x0]

    // invalidate again to get rid of stale clean cachelines that may
    // have been filled speculatively since the last invalidate
    dmb   sy
    dc    ivac, x0

    // flush the TLBs
    IF   "$el" == "1"
      tlbi  VMALLE1
      // DCB   0x1f, 0x87, 0x08, 0xd5
    ELSE
      tlbi  alle$el
    ENDIF
    dsb   sy

    // re-enable the MMU
    msr   sctlr_el$el, x8
    isb   sy
    MEND

//VOID
//ArmReplaceLiveTranslationEntry (
//  IN  UINT64  *Entry,
//  IN  UINT64  Value
//  )
ArmReplaceLiveTranslationEntry PROC

    // disable interrupts
    mrs   x2, daif
    msr   daifset, #0xf
    isb   sy

    // clean and invalidate first so that we don't clobber
    // adjacent entries that are dirty in the caches
    dc    civac, x0
    dsb   ish

    EL1_OR_EL2_OR_EL3 x3, %F1, %F2, %F3
1   __replace_entry 1
    b     %F4
2   __replace_entry 2
    b     %F4
3   __replace_entry 3
4   msr   daif, x2
    ret
    ENDP

    ALIGN 8
ArmReplaceLiveTranslationEntrySize
    DCQ   ARM_REPLACE_SIZE
  
  
    END
