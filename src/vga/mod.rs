pub const VGA_BUFFER: *mut u8 = 0xb8000 as *mut u8;

pub mod color;
pub mod buffer;

pub use color::*;
pub use buffer::Writer;

use lazy_static::lazy_static;
use spin::Mutex;


lazy_static! {
    pub static ref WRITER: Mutex<Writer> = Mutex::new(Writer::new(ColorCode::new(Color::Yellow, Color::Black)));
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
    use core::fmt::Write;
    WRITER.lock().write_fmt(args).unwrap();
}
