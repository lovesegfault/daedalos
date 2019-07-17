#![no_std]
#![no_main]
#![feature(custom_test_frameworks)]
#![test_runner(daedalos::test_runner)]
#![reexport_test_harness_main = "test_main"]

use daedalos::{sprint, sprintln, println};

#[allow(unused)]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    test_main();

    loop {}
}

#[test_case]
fn test_println() {
    sprint!("test_println... ");
    println!("test_println output");
    sprintln!("[ok]");
}
