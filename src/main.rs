#![no_std]
#![no_main]

#[allow(unused)]
use daedalos::println;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello World{}", "!");
    loop {}
}
