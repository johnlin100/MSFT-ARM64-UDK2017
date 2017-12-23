;------------------------------------------------------------------------------ 
;
; CpuFlushTlb() for ARM
;
; Copyright (c) 2006 - 2009, Intel Corporation. All rights reserved.<BR>
; Portions copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
; Convert GNU assembler syntax to MSFT ARMASM64 syntax from AArch64/CpuFlushTlb.S
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

  EXPORT CpuFlushTlb
  AREA cpu_flush_tlb, CODE, READONLY

;/**
;  Flushes all the Translation Lookaside Buffers(TLB) entries in a CPU.
;
;  Flushes all the Translation Lookaside Buffers(TLB) entries in a CPU.
;
;**/
;VOID
;EFIAPI
;CpuFlushTlb (
;  VOID
;  );
;
CpuFlushTlb 
  tlbi  VMALLE1                 // Invalidate Inst TLB and Data TLB
  DSB   SY
  ISB   SY
  ret

  END
