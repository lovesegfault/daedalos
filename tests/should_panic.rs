#![no_main]
#![no_std]

use daedalos::{qemu, serial_print, serial_println};

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    serial_println!("[ok]");
    qemu::exit(qemu::ExitCode::Success);
    daedalos::hlt_loop();
}

#[no_mangle]
pub extern fn _start() -> ! {
    should_fail();
    serial_println!("[test did not panic]");
    qemu::exit(qemu::ExitCode::Failed);
    daedalos::hlt_loop();
}

fn should_fail() {
    serial_print!("should_fail... ");
    assert_eq!(0, 1);
}
