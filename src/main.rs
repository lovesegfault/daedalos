#![cfg_attr(not(test), no_std)]
#![cfg_attr(not(test), no_main)]

#[cfg(not(test))]
use daedalos::{println, serial_println};
#[cfg(not(test))]
use daedalos::serial::qemu::exit_qemu;

#[cfg(not(feature = "integration-test"))]
#[cfg(not(test))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello, world!");
    serial_println!("Hello Host!");

    unsafe { exit_qemu(); }
    loop {}
}

#[cfg(feature = "integration-test")]
#[cfg(not(test))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    serial_println!("Hello Host{}", "!");

    unsafe { exit_qemu(); }
    loop {}
}

#[cfg(not(test))]
use core::panic::PanicInfo;
#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
