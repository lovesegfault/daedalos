pub const VGA_BUFFER: *mut u8 = 0xb8000 as *mut u8;

pub mod buffer;
pub mod color;

pub use buffer::Writer;
pub use color::*;

use lazy_static::lazy_static;
use spin::Mutex;
use x86_64::instructions::interrupts;

use core::fmt::Write;

lazy_static! {
    pub static ref WRITER: Mutex<Writer> =
        Mutex::new(Writer::new(ColorCode::new(Color::Yellow, Color::Black)));
}

#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => ($crate::vga::_print(format_args!($($arg)*)));
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("{}\n", format_args!($($arg)*)));
}

#[doc(hidden)]
pub fn _print(args: core::fmt::Arguments) {
    interrupts::without_interrupts(|| {
        WRITER.lock().write_fmt(args).unwrap();
    });
}
