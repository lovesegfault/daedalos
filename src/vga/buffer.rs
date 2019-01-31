use core::fmt;
use crate::vga::VGA_BUFFER;
use crate::vga::color::ColorCode;
use volatile::Volatile;

pub const BUFFER_HEIGHT: usize = 25;
pub const BUFFER_WIDTH: usize = 80;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(C)]
struct ScreenChar {
    ascii_char: u8,
    color: ColorCode,
}

impl ScreenChar {
    pub fn new(ascii_char: u8, color: ColorCode) -> Self {
        ScreenChar {ascii_char, color}
    }
}

impl Default for ScreenChar {
    fn default() -> Self {
        ScreenChar::new(b' ', ColorCode::default())
    }
}

struct Buffer {
    chars: [[Volatile<ScreenChar>; BUFFER_WIDTH]; BUFFER_HEIGHT],
}

pub struct Writer {
    column: usize,
    color: ColorCode,
    buffer: &'static mut Buffer,
}

impl Writer {
    pub fn new(color: ColorCode) -> Self {
        Writer {
            column: 0,
            color,
            buffer: unsafe { &mut *(VGA_BUFFER as *mut Buffer) },
        }
    }
    pub fn write_byte(&mut self, byte: u8) {
        match byte {
            b'\n' => self.new_line(),
            byte => {
                if self.column >= BUFFER_WIDTH {
                    self.new_line();
                }

                let row = BUFFER_HEIGHT - 1;
                let col = self.column;

                let color = self.color;
                self.buffer.chars[row][col].write(ScreenChar {
                    ascii_char: byte,
                    color
                });
                self.column += 1;
            }
        }
    }

    fn new_line(&mut self) {
        for row in 1..BUFFER_HEIGHT {
            for col in 0..BUFFER_WIDTH {
                let character = self.buffer.chars[row][col].read();
                self.buffer.chars[row - 1][col].write(character);
            }
        }
        self.clear_row(BUFFER_HEIGHT - 1);
        self.column = 0;
    }

    fn clear_row(&mut self, row: usize) {
        let blank = ScreenChar::new(b' ', self.color);
        for col in 0..BUFFER_WIDTH {
            self.buffer.chars[row][col].write(blank);
        }
    }
}

impl fmt::Write for Writer {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for byte in s.bytes() {
            match byte {
                // Printable
                0x20...0x7e | b'\n' => self.write_byte(byte),
                // Not printable
                _ => self.write_byte(0xfe),
            }
        }
        Ok(())
    }
}
