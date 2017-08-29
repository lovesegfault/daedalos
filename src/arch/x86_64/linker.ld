ENTRY(start)

SECTIONS {
    . = 1M;

    .boot :
    {
        /* Ensure that the multiboot header is at the beginning */
        KEEP(*(.multiboot_header))
    }

    .text :
    {
        *(.text)
    }
}