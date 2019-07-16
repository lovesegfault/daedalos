use crate::vga::color::ColorCode;
use crate::vga::{BUFFER_HEIGHT, BUFFER_WIDTH};
use volatile::Volatile;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(C)]
pub struct ScreenChar {
    pub ascii_character: u8,
    pub color_code: ColorCode,
}

#[repr(transparent)]
pub struct Buffer {
    pub(super) chars: [[Volatile<ScreenChar>; BUFFER_WIDTH]; BUFFER_HEIGHT],
}
