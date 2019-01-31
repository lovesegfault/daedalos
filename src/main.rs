#![no_std]
#![no_main]

use core::panic::PanicInfo;
use daedalos::println;

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello, world!");
    loop {}
}
