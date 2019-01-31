use crate::VGA_BUFFER;

#[no_mangle]
pub fn print_vga(text: &[u8]) {
    for (idx, &byte) in text.iter().enumerate() {
        unsafe {
            *VGA_BUFFER.offset(idx as isize * 2) = byte;
            *VGA_BUFFER.offset(idx as isize * 2 + 1) = 0xb;
        }
    }

}

