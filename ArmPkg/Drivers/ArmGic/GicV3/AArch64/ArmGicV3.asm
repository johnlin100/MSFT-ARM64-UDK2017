;
;  Copyright (c) 2014, ARM Limited. All rights reserved.
;  Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/ArmGicV3.S
;
;  This program and the accompanying materials are licensed and made available
;  under the terms and conditions of the BSD License which accompanies this
;  distribution. The full text of the license may be found at
;  http://opensource.org/licenses/bsd-license.php
;
;  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
;  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
;
;

    INCLUDE AsmMacroIoLibV8.inc
    
    EXPORT  ArmGicV3GetControlSystemRegisterEnable
    EXPORT  ArmGicV3SetControlSystemRegisterEnable
    EXPORT  ArmGicV3EnableInterruptInterface
    EXPORT  ArmGicV3DisableInterruptInterface
    EXPORT  ArmGicV3EndOfInterrupt
    EXPORT  ArmGicV3AcknowledgeInterrupt
    EXPORT  ArmGicV3SetPriorityMask
    EXPORT  ArmGicV3SetBinaryPointer

//UINT32
//EFIAPI
//ArmGicV3GetControlSystemRegisterEnable (
//  VOID
//  );
ArmGicV3GetControlSystemRegisterEnable PROC
    EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1   mrs     x0, icc_sre_el1
    // DCB     0xa0, 0xcc, 0x38, 0xd5
    b       %F4
2   mrs     x0, icc_sre_el2
    // DCB     0xa0, 0xc9, 0x3c, 0xd5
    b       %F4
3   mrs     x0, icc_sre_el3
    // DCB     0xa0, 0xcc, 0x3e, 0xd5
4   ret
    ENDP

//VOID
//EFIAPI
//ArmGicV3SetControlSystemRegisterEnable (
//  IN UINT32         ControlSystemRegisterEnable
//  );
ArmGicV3SetControlSystemRegisterEnable PROC
     EL1_OR_EL2_OR_EL3 x1, %F1, %F2, %F3
1    msr     icc_sre_el1, x0
     // DCB     0xa0, 0xcc, 0x18, 0xd5
     b       %F4
2    msr     icc_sre_el2, x0
     // DCB     0xa0, 0xc9, 0x1c, 0xd5
     b       %F4
3    msr     icc_sre_el3, x0
     // DCB     0xa0, 0xcc, 0x1e, 0xd5
4    isb     sy
     ret
     ENDP

//VOID
//ArmGicV3EnableInterruptInterface (
//  VOID
//  );
ArmGicV3EnableInterruptInterface  PROC
        mov     x0, #1
        msr     icc_igrpen1_el1, x0
        // DCB     0xe0, 0xcc, 0x18, 0xd5
        ret
        ENDP

//VOID
//ArmGicV3DisableInterruptInterface (
//  VOID
//  );
ArmGicV3DisableInterruptInterface  PROC
        mov     x0, #0
        msr     icc_igrpen1_el1, x0
        // DCB     0xe0, 0xcc, 0x18, 0xd5
        ret
        ENDP

//VOID
//ArmGicV3EndOfInterrupt (
//  IN UINTN          InterruptId
//  );
ArmGicV3EndOfInterrupt  PROC
        msr     icc_eoir1_el1, x0
        // DCB     0x20, 0xcc, 0x18, 0xd5
        ret
        ENDP

//UINTN
//ArmGicV3AcknowledgeInterrupt (
//  VOID
//  );
ArmGicV3AcknowledgeInterrupt  PROC
        mrs     x0, icc_iar1_el1
        // DCB     0x00, 0xcc, 0x38, 0xd5
        ret
        ENDP

//VOID
//ArmGicV3SetPriorityMask (
//  IN UINTN          Priority
//  );
ArmGicV3SetPriorityMask  PROC
        msr     icc_pmr_el1, x0
        // DCB     0x00, 0x46, 0x18, 0xd5
        ret
        ENDP

//VOID
//ArmGicV3SetBinaryPointer (
//  IN UINTN          BinaryPoint
//  );
ArmGicV3SetBinaryPointer  PROC
        msr     icc_bpr1_el1, x0
        // DCB     0x60, 0xcc, 0x18, 0xd5
        ret
        ENDP
        
        
    END
