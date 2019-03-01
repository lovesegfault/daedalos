#![cfg(not(test))]
#![no_std]
#![no_main]

use daedalos::{self, println};

use core::panic::PanicInfo;

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}

#[cfg(not(feature = "integration-test"))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello, world!");

    daedalos::interrupts::init_idt();

    x86_64::instructions::int3();

    println!("No crash");
    // unsafe { daedalos::serial::qemu::exit_qemu(); }
    loop {}
}
