use core::fmt;
use lazy_static::lazy_static;
use spin::Mutex;

mod buffer;
mod color;
mod writer;

use buffer::Buffer;
use color::{Color, ColorCode};
use writer::Writer;

pub const BUFFER_HEIGHT: usize = 25;
pub const BUFFER_WIDTH: usize = 80;

lazy_static! {
    pub static ref WRITER: Mutex<Writer> = Mutex::new(Writer {
        column_position: 0,
        color_code: ColorCode::new(Color::Yellow, Color::Black),
        buffer: unsafe { &mut *(0xb8000 as *mut Buffer) },
    });
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
pub fn _print(args: fmt::Arguments) {
    use core::fmt::Write;
    WRITER.lock().write_fmt(args).unwrap();
}

#[cfg(test)]
mod tests {
    use super::{BUFFER_HEIGHT, WRITER};
    use crate::{println, sprint, sprintln};

    #[test_case]
    fn test_println_simple() {
        sprint!("test_println... ");

        println!("test_println_simple output");

        sprintln!("[ok]");
    }

    #[test_case]
    fn test_println_many() {
        sprint!("test_println_many... ");

        for _ in 0..200 {
            println!("test_println_many output");
        }

        sprintln!("[ok]");
    }

    #[test_case]

    fn test_println_output() {
        sprint!("test_println_output... ");

        let s = "Some test string that fits on a single line";
        println!("{}", s);
        for (i, c) in s.chars().enumerate() {
            let screen_char = WRITER.lock().buffer.chars[BUFFER_HEIGHT - 2][i].read();
            assert_eq!(char::from(screen_char.ascii_character), c);
        }

        sprintln!("[ok]");
    }
}
