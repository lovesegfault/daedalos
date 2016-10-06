# Rationale
This is an attempt at explaining some of the decisions involved in the
development of this project


1.  Getting the source code (toolchain sources, core operating system, ports).
    *   What mirrors to download from?
        *   Right now we just get the from some predetermined mirrors, but
            eventually I'd like to do something for finding the fastest mirrors
            first. TODO.
    *   Where to install the source code?
        *   Right now, at least for the Cross-Compiling stuff it all goes under
            the `xcompiler/`. We'll see where this goes as the project
            develops.
2.  Install required programs as described in the documentation.
    *   Where to get the programs from?
        *   For the xcompiler we get from source and build it. For other
          requirements we will try and use the package manager.
    *   What version of the programs are used?
        *   A fixed one as will be described in the README file. We must try and
            constantly upgrade that to keep using the latest versions though.
    *   Where to install the programs?
        *   The xcompiler goes to the project folder, other dependencies such as
            `xorriso` (used for ISO creation) should be installed from the PM to
            the system normally.
3.  Build and install custom programs for this operating system.
    *   What compiler is used and which compiler options?
        *   GCC, compiler options are on the Makefile.
    *   Where to install the programs?
        *   TODO
4.  Prepare a System Root containing the standard library headers (needed to make a Hosted GCC Cross-Compiler).
    *   Where is the system root located?
    *   What processor architecture is used?
5.  Build and install a cross toolchain.
    *   What compiler and compiler options are used to compile the
        cross-compiler?
        *   GCC, check `scripts/xcompiler.sh`.
    *   Where to install the cross-compiler
        *   `xcompiler/` under the project root folder.
6.  Build the core operating system and ports and install into the system root.
    *   What cross-compiler to use and the compiler options used to compile your
        operating system and ports?
        *   TODO
    *   Whether this is a debug build and whether compiler sanitation and security measures are used.
        *   TODO
    *   What ports are to be built?
        *   TODO
7.  Create a bootable image from the sysroot contents.
    *   What boot method is used (cdrom, harddisk, floppy)?
        *   TODO
    *   What to include and what not to (if making a minimal build)
        *   TODO
    *   What drivers are needed in the initrd?
        *   TODO
8.  Run the operating system in a virtual machine.
    *   Which virtual machine is used?
        *   TODO
    *   What processor features, simulated hardware and how much memory is available.
        *   TODO
    *   Whether hardware acceleration is enabled.
        *   TODO
9.  Install the operating system on real hardware.
    *   What bootloader is used.
        *   TODO
    *   What harddisk and partition is used.
        *   TODO
    *   What filesystem is used.
        *   TODO
