#![cfg_attr(not(test), no_std)]
#![cfg_attr(not(test), no_main)]

#[cfg(not(test))]
use daedalos::{println, serial_println};
use daedalos::serial;

use x86_64::instructions::port::Port;

#[cfg(not(test))]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello, world!");
    serial_println!("Hello Host!");
    unsafe { exit_qemu(); }

    loop {}
}

pub unsafe fn exit_qemu() {
    let mut port = Port::<u32>::new(0xf4);
    port.write(0);
}

#[cfg(not(test))]
use core::panic::PanicInfo;
#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
