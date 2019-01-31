#![no_std]
#![no_main]

use daedalos::println;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello, world!");
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
