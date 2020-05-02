#![no_main]
#![no_std]

use daedalos::{exit_qemu, serial_print, serial_println, QemuExitCode};

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    serial_println!("[ok]");
    exit_qemu(QemuExitCode::Success);
    daedalos::hlt_loop();
}

#[no_mangle]
pub extern fn _start() -> ! {
    should_fail();
    serial_println!("[test did not panic]");
    exit_qemu(QemuExitCode::Failed);
    daedalos::hlt_loop();
}

fn should_fail() {
    serial_print!("should_fail... ");
    assert_eq!(0, 1);
}
