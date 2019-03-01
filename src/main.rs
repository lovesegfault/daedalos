#![cfg(not(test))]
#![no_std]
#![no_main]
#![allow(clippy::empty_loop)]

use daedalos::{self, println, interrupts, gdt};

use core::panic::PanicInfo;

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
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



    println!(">>>> Shutting Down");
    // unsafe { daedalos::serial::qemu::exit_qemu(); }
    loop {}
}
