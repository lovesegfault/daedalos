#![cfg(not(test))]
#![no_std]
#![no_main]

use daedalos::{self, println, interrupts, gdt};

use core::panic::PanicInfo;

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    daedalos::hlt_loop();
}

#[cfg(not(feature = "integration-test"))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!(">>>> Booted");
    gdt::init();
    println!(">>>> Initialized GDT");
    interrupts::init_idt();
    println!(">>>> Initialized IDT");
    unsafe { interrupts::PICS.lock().initialize() };
    x86_64::instructions::interrupts::enable();
    println!(">>>> Initialized PIC Interrupt Controller");



    // unsafe { daedalos::serial::qemu::exit_qemu(); }
    daedalos::hlt_loop();
    println!(">>>> Shutting Down");
}
