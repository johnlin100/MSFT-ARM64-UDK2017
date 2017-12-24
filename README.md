# MSFT-ARM64-UDK2017
Support VS2017 ARM64 Build for ArmVirtPkg in UDK2017

=== Overview ===

This project is branched from https://github.com/tianocore/edk2, UDK2017 breanch 
then update to support AARCH64 build with Microsoft VS2017 toolchain.

=== STATUS ===

Current capabilities:
* AARCH64 with Microsoft VS2017 version 15.5.1 released at 2017/12/7
* QEMU 2.10.1 (qemu-system-aarch64.exe)
  - Serial console mode.
  - Run UEFI Shell

=== FUTURE PLANS ===

* Update more ARM64 assembly files
* UEFI Linux Boot for ARM64

=== BUILD ArmVirtPkg ===

Pre-requisites:
* Build environment capable of build the edk2 MdeModulePkg.
* A properly configured ASL compiler:
  - Intel ASL compiler: Available from http://www.acpica.org
  - Microsoft ASL compiler: Available from http://www.acpi.info
* Win 8.1 SDK: https://developer.microsoft.com/en-us/windows/downloads/windows-8-sdk
* Visual Studio Community 2017 15.5.1 (15.5.2 or later not verified):
  - ARM Visual C++ Compiler and Library
  - ARM64 Visual C++ Compiler and Library

Following edk2 build process, there are two key points needs to be awared..
1. Extract UDK2017 win32 binary file to $WORKSPACE\BaseTools\Bin
2. Maybe need to customized WIN 8.1 SDK prefix environment setting in $WORKSPACE\BaseTools\set_vsprefix_envs.bat
The BIOS could be found in $WORKSPACE\Build\ArmVirtQemu-AARCH64\DEBUG_VS2017\FV\QEMU_EFI.fd

=== RUNING ARM64 BIOS on QEMU ===

* QEMU 2.10.1 (later not verified).
  - Install Windows QEMU from https://qemu.weilnetz.de/w64/
  - Use qemu-system-aarch64.exe
* Com0Com 3.0.0.0
  - Install virtual serial port driver to setup null-modem emulator from https://sourceforge.net/projects/com0com/
  - Customize port pair emuatolr (Example: COM5 <--> COM6) 
* Terminal program.
  - Tera Term
  - Putty
  - setup to serial port connection (Example: COM6 115200 8N1 no flow control)
* Lauch QEMU with ARM64 firmware
  - "c:\Program Files\qemu\qemu-system-aarch64.exe" -m 1024 -M virt -cpu cortex-a57 -serial COM5 -s -bios <$WORKSAPCE PATH>\Build\ArmVirtQemu-AARCH64\DEBUG_VS2017\FV\QEMU_EFI.fd
  - -m 1024: 1024MB memory
  - -M virt: QEMU ARM Virtual Machine
  - -cpu cortex-a57: assign CPU type
  - -serial COM5: Redirect the virtual serial port to host COM5
  - -s: Shorthand for -gdb tcp::1234, i.e. open a gdbserver on TCP port 1234
  - -bios <file path>: Set file name for BIOS.

=== RUNING GDB for Debug ===

* QEMU support gdbserver natively. So it's possible to use Cygwin GDB client to debug BIOS.
  - GDB not support Microsoft debug file (PDB). So it's only debugging in pure assembly environment.
  - Add /Facs to output assembly source code(.cod) and /Od to disable optimization in CC_FLAG to trace debug step from assembly source.
  - Native Cygwin GDB is built for x86 target. Need to re-build GDB for AARCH64 target.
* Build Cygwin GDB for AARCH64 Target:
  - Download setup fom https://www.cygwin.com/install.html
  - Excute setup and download following package.
    + gcc-gcc ++: GNU Compiler Collection
    + cygwin-devel: Core development files
    + binutils: GNU assembler, linker, and similar utilities
    + make: The GNU version of the 'make' utility
    + gdb: The GNU Debugger (source code not binary)
  - After install finished, launch Cygwin.
  - GDB source is at /use/src. Run following command to build gdb (source directory name could be vary)
    $ cd /usr/src/gdb-7.10.1-1.src
    $ tar xf gdb-7.10.1.tar.xz
    $ cd gdb-7.10.1
    $ ./configure --target=aarch64-elf --pefix=/opt/aarch64-gdb
    ........
    ........
    $ make
    ........
    ........
    $ make install
    ........
    ........
  - GDB client could be installed at /opt/aarch64-gdb/bin. Launch as
    $ cd /opt/aarch64-gdb/bin
    $ ./aarch64-elf-gdb.exe
* Debug with GDB
  - Launch QEMU with -S pause the virtual machine running at start up.
  - Add CpuDeadLoop () to stop BIOS at specific point.
  - Launch GDB client and run following command
    (gdb) target remote localhost:1234
    warning: Can not parse XML target description; XML support was disabled at compile time
    0x0000000000000000 in ?? ()
    (gdb) display/20i $pc
    1: x/20i $pc
    => 0x0: b       0x1000
       0x4: .inst   0xffffffff ; undefined
       0x8: .inst   0xffffffff ; undefined
       0xc: .inst   0xffffffff ; undefined
       0x10:        .inst   0xffffffff ; undefined
       0x14:        .inst   0xffffffff ; undefined
       0x18:        .inst   0xffffffff ; undefined
       .......
       .......
    (gdb)
  - Useful GDB Command
    + si: single step 
    + disas $pc, +0x10: disassemble starting at pc register with 16 bytes.
    + u *0x7FF0EC00: run until at address 0x7FF0EC00
  - Find more GDB command at https://sourceware.org/gdb/onlinedocs/gdb/



  
  
  
  
  

