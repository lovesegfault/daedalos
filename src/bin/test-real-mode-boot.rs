#![cfg_attr(not(test), no_std)]
#![cfg_attr(not(test), no_main)] // disable all Rust-level entry points
#![cfg_attr(test, allow(unused_imports))]

use core::panic::PanicInfo;
use daedalos::serial_println;
use daedalos::serial::qemu::exit_qemu;

/// This function is the entry point, since the linker looks for a function
/// named `_start` by default.
#[cfg(not(test))]
#[no_mangle]pub extern "C" fn _start() -> ! {
    serial_println!("ok");

    unsafe { exit_qemu(); }
    loop {}
}


/// This function is called on panic.
#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    serial_println!("failed");

    serial_println!("{}", info);

    unsafe { exit_qemu(); }
    loop {}
}
