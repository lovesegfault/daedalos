#![feature(custom_test_frameworks)]
#![no_main]
#![no_std]
#![reexport_test_harness_main = "test_main"]
#![test_runner(daedalos::test_runner)]

use daedalos::{println, serial_print, serial_println};

#[panic_handler]
fn panic(info: &core::panic::PanicInfo) -> ! { daedalos::test_panic_handler(info) }

#[no_mangle]
pub extern fn _start() -> ! {
    test_main();

    daedalos::hlt_loop();
}

#[test_case]
fn test_println() {
    serial_print!("test_println... ");
    println!("test_println output");
    serial_println!("[ok]");
}
