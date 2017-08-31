#![feature(lang_items)]
#![no_std]
#![feature(const_fn, unique)]

extern crate rlibc;
extern crate volatile;
extern crate spin;
extern crate multiboot2;
#[macro_use]
extern crate bitflags;
extern crate x86_64;

#[macro_use]
mod vga_buffer;
mod memory;

#[no_mangle]
pub extern "C" fn rust_main(multiboot_information_address: usize) {
    use memory::FrameAllocator;

    vga_buffer::clear_screen();

    let boot_info = unsafe { multiboot2::load(multiboot_information_address) };
    let memory_map_tag = boot_info.memory_map_tag().expect("Memory map tag required");
    println!("Memory Areas:");
    for area in memory_map_tag.memory_areas() {
        println!(
            "    Start: {:#8x} | Length: 0x{:#x}",
            area.base_addr,
            area.length
        );
    }


    let elf_sections_tag = boot_info
        .elf_sections_tag()
        .expect("Elf-sections tag required");
    println!("Kernel Sections:");
    for section in elf_sections_tag.sections() {
        println!(
            "    Address: {:#8x} | Size: {:#6x} | Flags: {:#x}",
            section.addr,
            section.size,
            section.flags
        );
    }

    let kernel_start = elf_sections_tag.sections().map(|s| s.addr).min().unwrap();
    let kernel_end = elf_sections_tag
        .sections()
        .map(|s| s.addr + s.size)
        .max()
        .unwrap();
    let multiboot_start = multiboot_information_address;
    let multiboot_end = multiboot_start + (boot_info.total_size as usize);

    println!(
        "Kernel:\n    Start: {:#8x}\n      End: {:#8x}\n     Size: {:#x}",
        kernel_start,
        kernel_end,
        (kernel_end - kernel_start)
    );
    println!(
        "Multiboot:\n    Start: 0x{:x}\n      End: 0x{:x}\n     Size: 0x{:x}",
        multiboot_start,
        multiboot_end,
        (multiboot_end - multiboot_start)
    );

    let mut frame_allocator = memory::AreaFrameAllocator::new(
        kernel_start as usize,
        kernel_end as usize,
        multiboot_start,
        multiboot_end,
        memory_map_tag.memory_areas(),
    );
    for i in 0.. {
    if let None = frame_allocator.allocate_frame() {
        println!("Allocated {} frames", i);
        break;
    }
}

    loop {}
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[lang = "panic_fmt"]
#[no_mangle]
pub extern "C" fn panic_fmt(fmt: core::fmt::Arguments, file: &'static str, line: u32) -> ! {
    println!("\n\nPANIC in {} at line {}:", file, line);
    println!("    {}", fmt);
    loop {}
}
