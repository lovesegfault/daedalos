#![feature(custom_test_frameworks)]
#![no_main]
#![no_std]
#![reexport_test_harness_main = "test_main"]
#![test_runner(test_runner)]

use daedalos::{exit_qemu, serial_print, serial_println, QemuExitCode};

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    serial_println!("[ok]");
    exit_qemu(QemuExitCode::Success);
    loop {}
}

pub fn test_runner(tests: &[&dyn Fn()]) {
    serial_println!("Running {} tests", tests.len());
    for test in tests {
        test();
        serial_println!("[test did not panic]");
        exit_qemu(QemuExitCode::Failed);
    }
    exit_qemu(QemuExitCode::Success);
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    test_main();

    loop {}
}

#[test_case]
fn should_fail() {
    serial_print!("should_fail... ");
    assert_eq!(0, 1);
}
