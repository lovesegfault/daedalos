#![feature(custom_test_frameworks)]
#![no_main]
#![no_std]
#![reexport_test_harness_main = "test_main"]
#![test_runner(daedalos::test_runner)]

extern crate alloc;

use bootloader::{entry_point, BootInfo};
use core::panic::PanicInfo;
use daedalos::{serial_print, serial_println};

#[panic_handler]
fn panic(info: &PanicInfo) -> ! { daedalos::test_panic_handler(info) }

entry_point!(main);

fn main(boot_info: &'static BootInfo) -> ! {
    daedalos::init(boot_info);

    test_main();
    loop {}
}

#[test_case]
fn simple_allocation() {
    use alloc::boxed::Box;
    serial_print!("simple_allocation... ");
    let heap_value = Box::new(41);
    assert_eq!(*heap_value, 41);
    serial_println!("[ok]");
}

#[test_case]
fn large_vec() {
    use alloc::vec::Vec;
    serial_print!("large_vec... ");
    let n = 1000;
    let mut vec = Vec::new();
    for i in 0..n {
        vec.push(i);
    }
    assert_eq!(vec.iter().sum::<u64>(), (n - 1) * n / 2);
    serial_println!("[ok]");
}

#[test_case]
fn many_boxes() {
    use alloc::boxed::Box;
    use daedalos::allocator::HEAP_SIZE;
    serial_print!("many_boxes... ");
    for i in 0..HEAP_SIZE {
        let x = Box::new(i);
        assert_eq!(*x, i);
    }
    serial_println!("[ok]");
}
