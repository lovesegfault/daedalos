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
    use core::fmt::Write;
    vga::WRITER.lock().write_str("Hello again").unwrap();
    write!(vga::WRITER.lock(), ", some numbers: {} {}", 42, 1.337).unwrap();
    loop {}
}
