use x86_64::instructions::port::Port;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u32)]
pub enum QemuExitCode {
    Success = 0x10,

    Failed = 0x11,
}

pub fn exit_qemu(exit_code: QemuExitCode) {
    unsafe {
        let mut port = Port::new(0xf4);

        port.write(exit_code as u32);
    }
}
