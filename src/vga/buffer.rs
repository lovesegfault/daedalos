use crate::vga::color::ColorCode;
use crate::vga::VGA_BUFFER;
use core::fmt;
use volatile::Volatile;

pub const BUFFER_HEIGHT: usize = 25;
pub const BUFFER_WIDTH: usize = 80;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(C)]
pub struct ScreenChar {
    ascii_char: u8,
    color: ColorCode,
}

impl ScreenChar {
    pub fn new(ascii_char: u8, color: ColorCode) -> Self {
        ScreenChar { ascii_char, color }
    }
}

impl Default for ScreenChar {
    fn default() -> Self {
        ScreenChar::new(b' ', ColorCode::default())
    }
}

pub struct Buffer {
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
                    color,
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

#[cfg(test)]
mod test {
    use super::*;
    use array_init::array_init;
    use std::boxed::Box;
    use volatile::Volatile;

    fn construct_buffer() -> Buffer {
        Buffer {
            chars: array_init(|_| array_init(|_| Volatile::new(ScreenChar::default()))),
        }
    }

    fn construct_writer() -> Writer {
        let buffer = construct_buffer();
        Writer {
            column: 0,
            color: ColorCode::default(),
            buffer: Box::leak(Box::new(buffer)),
        }
    }

    #[test]
    fn write_byte() {
        let mut writer = construct_writer();
        writer.write_byte(b'X');
        writer.write_byte(b'Y');

        for (i, row) in writer.buffer.chars.iter().enumerate() {
            for (j, screen_char) in row.iter().enumerate() {
                let screen_char = screen_char.read();
                if i == BUFFER_HEIGHT - 1 && j == 0 {
                    assert_eq!(screen_char.ascii_char, b'X');
                    assert_eq!(screen_char.color, writer.color);
                } else if i == BUFFER_HEIGHT - 1 && j == 1 {
                    assert_eq!(screen_char.ascii_char, b'Y');
                    assert_eq!(screen_char.color, writer.color);
                } else {
                    assert_eq!(screen_char, ScreenChar::default());
                }
            }
        }
    }

    #[test]
    fn write_formatted() {
        use core::fmt::Write;

        let mut writer = construct_writer();
        writeln!(&mut writer, "a").unwrap();
        let c = 'c';
        writeln!(&mut writer, "b{}", c).unwrap();

        for (i, row) in writer.buffer.chars.iter().enumerate() {
            for (j, screen_char) in row.iter().enumerate() {
                let screen_char = screen_char.read();
                if i == BUFFER_HEIGHT - 3 && j == 0 {
                    assert_eq!(screen_char.ascii_char, b'a');
                    assert_eq!(screen_char.color, writer.color);
                } else if i == BUFFER_HEIGHT - 2 && j == 0 {
                    assert_eq!(screen_char.ascii_char, b'b');
                    assert_eq!(screen_char.color, writer.color);
                } else if i == BUFFER_HEIGHT - 2 && j == 1 {
                    assert_eq!(screen_char.ascii_char, b'c');
                    assert_eq!(screen_char.color, writer.color);
                } else if i >= BUFFER_HEIGHT - 2 {
                    assert_eq!(screen_char.ascii_char, b' ');
                    assert_eq!(screen_char.color, writer.color);
                } else {
                    assert_eq!(screen_char, ScreenChar::default());
                }
            }
        }
    }
}
