#![no_std]
#![no_main]

use core::panic::PanicInfo;
use daedalos::utils::print::*;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    print_vga(b"Hello, world!");
    loop {}
}
