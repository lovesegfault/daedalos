#![no_std]
#![cfg_attr(test, no_main)]
#![feature(custom_test_frameworks)]
#![test_runner(crate::test_runner)]
#![reexport_test_harness_main = "test_main"]

use core::panic::PanicInfo;

pub mod qemu;
pub mod serial;
pub mod vga;

#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}

#[cfg(test)]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    test_panic(info)
}

#[allow(dead_code)]
fn test_panic(info: &PanicInfo) -> ! {
    sprintln!("[failed]\n");
    sprintln!("Error: {}\n", info);
    qemu::exit_qemu(qemu::QemuExitCode::Failed);
    loop {}
}

pub fn test_runner(tests: &[&dyn Fn()]) {
    sprintln!("Running {} tests", tests.len());
    for test in tests {
        test();
    }
    qemu::exit_qemu(qemu::QemuExitCode::Success);
}

#[cfg(test)]
#[allow(unused)]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    test_main();
    loop {}
}
