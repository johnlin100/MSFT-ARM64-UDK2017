;%HEADER%
;/** @file
;  Macros to centralize the EXPORT, AREA, and definition of an assembly
;  function.  The AREA prefix is required to put the function in its own
;  section so that removal of unused functions in the final link is performed.
;  This provides  equivalent functionality to the compiler's --split-sections
;  option.
;
;  Copyright (c) 2015 HP Development Company, L.P.
;  Modified from AsmMacroExport.inc to meet MSFT ARMASM64 syntax.
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


  MACRO
  MSFT_ASM_EXPORT $func
    EXPORT  $func
    AREA |.text$mn|, CODE, READONLY, ARM64
$func
  MEND

  END
