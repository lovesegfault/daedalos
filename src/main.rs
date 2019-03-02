#![cfg(not(test))]
#![no_std]
#![no_main]

use daedalos::{self, gdt, interrupts, memory, println};

use bootloader::{bootinfo::BootInfo, entry_point};

use core::panic::PanicInfo;

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    daedalos::hlt_loop();
}

entry_point!(kernel_main);

#[cfg(not(test))]
fn kernel_main(boot_info: &'static BootInfo) -> ! {
    println!(">>>> Booted");
    // println!("{:#?}", boot_info);
    gdt::init();
    println!(">>>> Initialized GDT");
    interrupts::init_idt();
    println!(">>>> Initialized IDT");
    unsafe { interrupts::PICS.lock().initialize() };
    x86_64::instructions::interrupts::enable();
    println!(">>>> Initialized PIC Interrupt Controller");
    let mut recursive_page_table = unsafe { memory::init(boot_info.p4_table_addr as usize) };
    println!(">>>> Initialized Page Tables");
    let mut frame_allocator = memory::init_frame_allocator(&boot_info.memory_map);
    memory::create_mapping(&mut recursive_page_table, &mut frame_allocator);
    println!(">>>> Initialized Frame Allocator");

    unsafe { (0xdeadbeaf900 as *mut u64).write_volatile(0xf021f077f065f04e)};

    // unsafe { daedalos::serial::qemu::exit_qemu(); }
    daedalos::hlt_loop();
    //println!(">>>> Shutting Down");
}
