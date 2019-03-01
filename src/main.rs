#![cfg(not(test))]
#![no_std]
#![no_main]
#![allow(clippy::empty_loop)]

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
    println!("Starting");

    daedalos::gdt::init();
    daedalos::interrupts::init_idt();


   #[allow(unconditional_recursion)]
    fn stack_overflow() {
        stack_overflow(); // for each recursion, the return address is pushed
    }

    // trigger a stack overflow
    stack_overflow();


    println!("No crash");
    // unsafe { daedalos::serial::qemu::exit_qemu(); }
    loop {}
}
