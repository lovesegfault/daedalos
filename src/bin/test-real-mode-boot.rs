#![no_std]
#![cfg_attr(not(test), no_main)]
#![cfg_attr(test, allow(dead_code, unused_macros, unused_imports))]

use daedalos::{serial::qemu::exit_qemu, serial_println, hlt_loop};

use core::panic::PanicInfo;

#[cfg(not(test))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    serial_println!("ok");

    unsafe {
        exit_qemu();
    }
    hlt_loop();
}

#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    serial_println!("failed");

    serial_println!("{}", info);

    unsafe {
        exit_qemu();
    }
    hlt_loop();
}
