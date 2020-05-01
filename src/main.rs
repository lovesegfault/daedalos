#![no_std]
#![no_main]

mod vga;

use core::panic::PanicInfo;

/// This function is called on panic.
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    static HELLO: &[u8] = b"Hello, world!";
    for (i, &byte) in HELLO.iter().enumerate() {
        unsafe {
            *vga::VGA_BUFFER.offset(i as isize * 2) = byte;
            *vga::VGA_BUFFER.offset(i as isize * 2 + 1) = 0xb;
        }
    }
    loop {}
}
